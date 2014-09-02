//========================================================================
// GCD Unit RTL Implementation
//========================================================================

`ifndef GCD_GCD_UNIT_V
`define GCD_GCD_UNIT_V

`include "ex-gcd-msgs.v"
`include "vc-assert.v"
`include "vc-muxes.v"
`include "vc-regs.v"
`include "vc-arithmetic.v"
`include "vc-trace.v"

//========================================================================
// Control and status signal structs
//========================================================================

// Control signals (ctrl->dpath)

typedef struct packed {

  logic       a_reg_en;   // Enable for A register
  logic       b_reg_en;   // Enable for B register
  logic [1:0] a_mux_sel;  // Sel for mux in front of A reg
  logic       b_mux_sel;  // sel for mux in front of B reg

} ex_gcd_cs_t;

// Status signals (dpath->ctrl)

typedef struct packed {

  logic       is_b_zero;  // Output of zero comparator
  logic       is_a_lt_b;  // Output of less-than comparator

} ex_gcd_ss_t;

//========================================================================
// GCD Unit Datapath
//========================================================================

module ex_gcd_GcdUnitDpath
(
  input  logic             clk,
  input  logic             reset,

  // Data signals

  input  ex_gcd_req_msg_t  req_msg,
  output ex_gcd_resp_msg_t resp_msg,

  // Control and satus signals

  input  ex_gcd_cs_t       cs,
  output ex_gcd_ss_t       ss
);

  localparam c_nbits = `EX_GCD_REQ_MSG_A_NBITS;

  // A Mux

  logic [c_nbits-1:0] b_reg_out;
  logic [c_nbits-1:0] sub_out;
  logic [c_nbits-1:0] a_mux_out;

  vc_Mux3#(c_nbits) a_mux
  (
    .sel   (cs.a_mux_sel),
    .in0   (req_msg.a),
    .in1   (b_reg_out),
    .in2   (sub_out),
    .out   (a_mux_out)
  );

  // A register

  logic [c_nbits-1:0] a_reg_out;

  vc_EnReg#(c_nbits) a_reg
  (
    .clk   (clk),
    .reset (reset),
    .en    (cs.a_reg_en),
    .d     (a_mux_out),
    .q     (a_reg_out)
  );

  // B Mux

  logic [c_nbits-1:0] b_mux_out;

  vc_Mux2#(c_nbits) b_mux
  (
    .sel   (cs.b_mux_sel),
    .in0   (req_msg.b),
    .in1   (a_reg_out),
    .out   (b_mux_out)
  );

  // B register

  vc_EnReg#(c_nbits) b_reg
  (
    .clk   (clk),
    .reset (reset),
    .en    (cs.b_reg_en),
    .d     (b_mux_out),
    .q     (b_reg_out)
  );

  // Less-than comparator

  vc_LtComparator#(c_nbits) a_lt_b
  (
    .in0   (a_reg_out),
    .in1   (b_reg_out),
    .out   (ss.is_a_lt_b)
  );

  // Zero comparator

  vc_ZeroComparator#(c_nbits) b_zero
  (
    .in    (b_reg_out),
    .out   (ss.is_b_zero)
  );

  // Subtractor

  vc_Subtractor#(c_nbits) sub
  (
    .in0   (a_reg_out),
    .in1   (b_reg_out),
    .out   (sub_out)
  );

  // Connect to output port

  assign resp_msg.result = sub_out;

endmodule

//========================================================================
// GCD Unit Control
//========================================================================

module ex_gcd_GcdUnitCtrl
(
  input  logic                 clk,
  input  logic                 reset,

  // Dataflow signals

  input  logic                 req_val,
  output logic                 req_rdy,
  output logic                 resp_val,
  input  logic                 resp_rdy,

  // Control and satus signals

  output ex_gcd_cs_t           cs,
  input  ex_gcd_ss_t           ss
);

  //----------------------------------------------------------------------
  // State Definitions
  //----------------------------------------------------------------------

  typedef enum logic [$clog2(3)-1:0] {
    STATE_IDLE,
    STATE_CALC,
    STATE_DONE
  } state_t;

  //----------------------------------------------------------------------
  // State
  //----------------------------------------------------------------------

  state_t state_reg;
  state_t state_next;

  always @( posedge clk ) begin
    if ( reset ) begin
      state_reg <= STATE_IDLE;
    end
    else begin
      state_reg <= state_next;
    end
  end

  //----------------------------------------------------------------------
  // State Transitions
  //----------------------------------------------------------------------

  logic req_go;
  logic resp_go;
  logic is_calc_done;

  assign req_go       = req_val  && req_rdy;
  assign resp_go      = resp_val && resp_rdy;
  assign is_calc_done = !ss.is_a_lt_b && ss.is_b_zero;

  always @(*) begin

    state_next = state_reg;

    case ( state_reg )

      STATE_IDLE: if ( req_go    )    state_next = STATE_CALC;
      STATE_CALC: if ( is_calc_done ) state_next = STATE_DONE;
      STATE_DONE: if ( resp_go   )    state_next = STATE_IDLE;

    endcase

  end

  //----------------------------------------------------------------------
  // State Outputs
  //----------------------------------------------------------------------

  localparam a_x   = 2'dx;
  localparam a_ld  = 2'd0;
  localparam a_b   = 2'd1;
  localparam a_sub = 2'd2;

  localparam b_x   = 1'dx;
  localparam b_ld  = 1'd0;
  localparam b_a   = 1'd1;

  task set_cs
  (
    input logic       cs_req_rdy,
    input logic       cs_resp_val,
    input logic [1:0] cs_a_mux_sel,
    input logic       cs_a_reg_en,
    input logic       cs_b_mux_sel,
    input logic       cs_b_reg_en
  );
  begin
    req_rdy      = cs_req_rdy;
    resp_val     = cs_resp_val;
    cs.a_reg_en  = cs_a_reg_en;
    cs.b_reg_en  = cs_b_reg_en;
    cs.a_mux_sel = cs_a_mux_sel;
    cs.b_mux_sel = cs_b_mux_sel;
  end
  endtask

  // Labels for Mealy transistions

  logic do_swap;
  logic do_sub;

  assign do_swap = ss.is_a_lt_b;
  assign do_sub  = !ss.is_b_zero;

  // Set outputs using a control signal "table"

  always @(*) begin

    set_cs( 0, 0, a_x, 0, b_x, 0 );
    case ( state_reg )
      //                                 req resp a mux  a  b mux b
      //                                 rdy val  sel    en sel   en
      STATE_IDLE:                set_cs( 1,  0,   a_ld,  1, b_ld, 1 );
      STATE_CALC: if ( do_swap ) set_cs( 0,  0,   a_b,   1, b_a,  1 );
             else if ( do_sub  ) set_cs( 0,  0,   a_sub, 1, b_x,  0 );
      STATE_DONE:                set_cs( 0,  1,   a_x,   0, b_x,  0 );

    endcase

  end

  //----------------------------------------------------------------------
  // Assertions
  //----------------------------------------------------------------------

  `ifndef SYNTHESIS
  always @( posedge clk ) begin
    if ( !reset ) begin
      `VC_ASSERT_NOT_X( req_val     );
      `VC_ASSERT_NOT_X( req_rdy     );
      `VC_ASSERT_NOT_X( resp_val    );
      `VC_ASSERT_NOT_X( resp_rdy    );
      `VC_ASSERT_NOT_X( cs.a_reg_en );
      `VC_ASSERT_NOT_X( cs.b_reg_en );
    end
  end
  `endif /* SYNTHESIS */

endmodule

//========================================================================
// GCD Unit
//========================================================================

module ex_gcd_GcdUnit
(
  input  logic             clk,
  input  logic             reset,

  input  logic             req_val,
  output logic             req_rdy,
  input  ex_gcd_req_msg_t  req_msg,

  output logic             resp_val,
  input  logic             resp_rdy,
  output ex_gcd_resp_msg_t resp_msg
);

  //----------------------------------------------------------------------
  // Trace request message
  //----------------------------------------------------------------------

  ex_gcd_GcdReqMsgTrace req_msg_trace
  (
    .clk      (clk),
    .reset    (reset),
    .val      (req_val),
    .rdy      (req_rdy),
    .msg      (req_msg)
  );

  //----------------------------------------------------------------------
  // Control Unit
  //----------------------------------------------------------------------

  ex_gcd_cs_t cs;
  ex_gcd_ss_t ss;

  ex_gcd_GcdUnitCtrl ctrl
  (
    .clk      (clk),
    .reset    (reset),

    .req_val  (req_val),
    .req_rdy  (req_rdy),
    .resp_val (resp_val),
    .resp_rdy (resp_rdy),

    .cs       (cs),
    .ss       (ss)
  );

  //----------------------------------------------------------------------
  // Datapath
  //----------------------------------------------------------------------

  ex_gcd_GcdUnitDpath dpath
  (
    .clk      (clk),
    .reset    (reset),

    .req_msg  (req_msg),
    .resp_msg (resp_msg),

    .cs       (cs),
    .ss       (ss)
  );

  //----------------------------------------------------------------------
  // Line Tracing
  //----------------------------------------------------------------------

  `ifndef SYNTHESIS

  logic [`VC_TRACE_NBITS_TO_NCHARS(`EX_GCD_REQ_MSG_A_NBITS)*8-1:0] str;

  `VC_TRACE_BEGIN
  begin

    req_msg_trace.trace( trace_str );

    vc_trace.append_str( trace_str, "(" );

    $sformat( str, "%x", dpath.a_reg_out );
    vc_trace.append_str( trace_str, str );
    vc_trace.append_str( trace_str, " " );

    $sformat( str, "%x", dpath.b_reg_out );
    vc_trace.append_str( trace_str, str );
    vc_trace.append_str( trace_str, " " );

    case ( ctrl.state_reg )

      ctrl.STATE_IDLE:
        vc_trace.append_str( trace_str, "I " );

      ctrl.STATE_CALC:
      begin
        if ( ctrl.do_swap )
          vc_trace.append_str( trace_str, "Cs" );
        else if ( ctrl.do_sub )
          vc_trace.append_str( trace_str, "C-" );
        else
          vc_trace.append_str( trace_str, "C " );
      end

      ctrl.STATE_DONE:
        vc_trace.append_str( trace_str, "D " );

      default:
        vc_trace.append_str( trace_str, "? " );

    endcase

    vc_trace.append_str( trace_str, ")" );

    $sformat( str, "%x", resp_msg );
    vc_trace.append_val_rdy_str( trace_str, resp_val, resp_rdy, str );

  end
  `VC_TRACE_END

  `endif /* SYNTHESIS */

endmodule

`endif /* EX_GCD_GCD_UNIT_V */

