//========================================================================
// Verilog Components: Test Sink
//========================================================================
// p_sim_mode should be set to one in simulators. This will cause the
// sink to abort after the first failure with an appropriate error
// message.

`ifndef VC_TEST_SINK_V
`define VC_TEST_SINK_V

`include "vc-regs.v"
`include "vc-test.v"

module vc_TestSink
#(
  parameter p_msg_nbits = 1,
  parameter p_num_msgs  = 1024,
  parameter p_sim_mode  = 0
)(
  input                    clk,
  input                    reset,

  // Sink message interface

  input                    val,
  output                   rdy,
  input  [p_msg_nbits-1:0] msg,

  // Keeps track of how many messages failed

  output [31:0]            num_failed,

  // Goes high once all sink data has been received

  output                   done
);

  //----------------------------------------------------------------------
  // Local parameters
  //----------------------------------------------------------------------

  // Size of a physical address for the memory in bits

  localparam c_index_nbits = $clog2(p_num_msgs);

  //----------------------------------------------------------------------
  // State
  //----------------------------------------------------------------------

  // Memory which stores messages to verify against those received

  reg [p_msg_nbits-1:0] m[p_num_msgs-1:0];

  // Index register pointing to next message to verify

  wire                     index_en;
  wire [c_index_nbits-1:0] index_next;
  wire [c_index_nbits-1:0] index;

  vc_EnResetReg#(c_index_nbits,{c_index_nbits{1'b0}}) index_reg
  (
    .clk   (clk),
    .reset (reset),
    .en    (index_en),
    .d     (index_next),
    .q     (index)
  );

  // Register reset

  reg reset_reg;
  always @( posedge clk )
    reset_reg <= reset;

  //----------------------------------------------------------------------
  // Combinational logic
  //----------------------------------------------------------------------

  // We use a behavioral hack to easily detect when we have gone off the
  // end of the valid messages in the memory.

  assign done = !reset_reg && ( m[index] === {p_msg_nbits{1'bx}} );

  // Sink message interface is ready as long as we are not done

  assign rdy = !reset_reg && !done;

  // We bump the index pointer every time we successfully receive a
  // message, otherwise the index stays the same.

  assign index_en   = val && rdy;
  assign index_next = index + 1'b1;

  // The go signal is high when a message is transferred

  wire go = val && rdy;

  //----------------------------------------------------------------------
  // Verification logic
  //----------------------------------------------------------------------

  reg [31:0] num_failed_next;
  reg [31:0] num_failed;
  reg  [3:0] verbose;

  initial begin
    if ( !$value$plusargs( "verbose=%d", verbose ) )
      verbose = 0;
  end

  always @( posedge clk ) begin
    if ( reset ) begin
      num_failed <= 0;
    end
    else if ( !reset && go ) begin

      if ( verbose > 1 )
        $display( "                %m checking message number %0d", index );

      // Cut-and-paste from VC_TEST_NET in vc-test.v

      if ( msg === 'hz ) begin
        num_failed_next = num_failed + 1;
        if ( verbose > 0 ) begin
          $display( "     [ FAILED ]%s, expected = %x, actual = %x",
                    "msg", m[index], msg );
        end
      end
      else
        casez ( msg )
          m[index] :
            if ( verbose > 1 )
               $display( "     [ passed ]%s, expected = %x, actual = %x",
                         "msg", m[index], msg );
          default : begin
            num_failed_next = num_failed + 1;
            if ( verbose > 0 ) begin
              $display( "     [ FAILED ]%s, expected = %x, actual = %x",
                        "msg", m[index], msg );
            end
          end
        endcase

      num_failed <= num_failed_next;

      if ( p_sim_mode && (num_failed_next > 0) ) begin
        $display( "" );
        $display( " ERROR: Test sink found a failure!" );
        $display( "  - module   : %m" );
        $display( "  - expected : %x", m[index] );
        $display( "  - actual   : %x", msg );
        $display( "" );
        $display( " Verify that all unit tests pass; if they do, then debug" );
        $display( " the failure and add a new unit test which would have" );
        $display( " caught the bug in the first place." );
        $display( "" );
        $finish_and_return(1);
      end

    end
  end

  //----------------------------------------------------------------------
  // Assertions
  //----------------------------------------------------------------------

  always @( posedge clk ) begin
    if ( !reset ) begin
      `VC_ASSERT_NOT_X( val );
      `VC_ASSERT_NOT_X( rdy );
    end
  end

  //----------------------------------------------------------------------
  // Line Tracing
  //----------------------------------------------------------------------

  reg [`VC_TRACE_NBITS_TO_NCHARS(p_msg_nbits)*8-1:0] msg_str;

  `VC_TRACE_BEGIN
  begin
    $sformat( msg_str, "%x", msg );
    vc_trace.append_val_rdy_str( trace_str, val, rdy, msg_str );
  end
  `VC_TRACE_END

endmodule

`endif /* VC_TEST_SINK_V */
