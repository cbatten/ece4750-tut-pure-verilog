//=========================================================================
// GCD Unit Functional-Level Implementation
//=========================================================================

`ifndef GCD_GCD_UNIT_FL_V
`define GCD_GCD_UNIT_FL_V

`include "ex-gcd-msgs.v"
`include "vc-assert.v"
`include "vc-trace.v"

module ex_gcd_GcdUnitFL
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
    .clk   (clk),
    .reset (reset),
    .val   (req_val),
    .rdy   (req_rdy),
    .msg   (req_msg)
  );

  //----------------------------------------------------------------------
  // Implement GCD with Euclid's Algorithm
  //----------------------------------------------------------------------

  logic [`EX_GCD_REQ_MSG_A_NBITS-1:0]       A;
  logic [`EX_GCD_REQ_MSG_B_NBITS-1:0]       B;
  logic [`EX_GCD_RESP_MSG_RESULT_NBITS-1:0] temp;

  logic full, req_go, resp_go, done;

  always @( posedge clk ) begin

    // Ensure that we clear the full bit if we are in reset.

    if ( reset )
      full = 0;

    // At the end of the cycle, we AND together the val/rdy bits to
    // determine if the input/output message transactions occured.

    req_go  = req_val  && req_rdy;
    resp_go = resp_val && resp_rdy;

    // If the output transaction occured, then clear the buffer full bit.
    // Note that we do this _first_ before we process the input
    // transaction so we can essentially pipeline this control logic.

    if ( resp_go )
      full = 0;

    // If the input transaction occured, then write the input message
    // into our internal buffer and update the buffer full bit.

    if ( req_go ) begin
      A    = req_msg.a;
      B    = req_msg.b;
      full = 1;
    end

    // The output message is always the GCD of the buffer

    done = 0;
    while ( !done ) begin
      if ( A < B ) begin
        temp = A;
        A = B;
        B = temp;
      end
      else if ( B != 0 )
        A = A - B;
      else
        done = 1;
    end

    resp_msg.result <= A;

    // The output message is valid if the buffer is full

    resp_val <= full;

  end

  // Connect output ready signal to input to ensure pipeline behavior

  assign req_rdy = resp_rdy;

  //----------------------------------------------------------------------
  // Assertions
  //----------------------------------------------------------------------

  `ifndef SYNTHESIS
  always @( posedge clk ) begin
    if ( !reset ) begin
      `VC_ASSERT_NOT_X( req_val  );
      `VC_ASSERT_NOT_X( req_rdy  );
      `VC_ASSERT_NOT_X( resp_val );
      `VC_ASSERT_NOT_X( resp_rdy );
    end
  end
  `endif /* SYNTHESIS */

  //----------------------------------------------------------------------
  // Line Tracing
  //----------------------------------------------------------------------

  `ifndef SYNTHESIS

  logic [`VC_TRACE_NBITS_TO_NCHARS(`EX_GCD_RESP_MSG_RESULT_NBITS)*8-1:0] str;

  `VC_TRACE_BEGIN
  begin

    req_msg_trace.trace( trace_str );

    vc_trace.append_str( trace_str, "()" );

    $sformat( str, "%x", resp_msg );
    vc_trace.append_val_rdy_str( trace_str, resp_val, resp_rdy, str );

  end
  `VC_TRACE_END

   `endif /* SYNTHESIS */

endmodule

`endif /* EX_GCD_GCD_UNIT_V */

