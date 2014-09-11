//=========================================================================
// GCD Unit Functional-Level Implementation
//=========================================================================

`ifndef GCD_GCD_UNIT_FL_V
`define GCD_GCD_UNIT_FL_V

`include "vc-assert.v"
`include "vc-trace.v"

module ex_gcd_GcdUnitFL
(
  input  logic             clk,
  input  logic             reset,

  input  logic             req_val,
  output logic             req_rdy,
  input  logic [15:0]      req_a,
  input  logic [15:0]      req_b,

  output logic             resp_val,
  input  logic             resp_rdy,
  output logic [15:0]      resp_result
);

  //----------------------------------------------------------------------
  // Implement GCD with Euclid's Algorithm
  //----------------------------------------------------------------------

  logic [15:0] A;
  logic [15:0] B;
  logic [15:0] temp;

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
      A    = req_a;
      B    = req_b;
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

    resp_result <= A;

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

  logic [`VC_TRACE_NBITS_TO_NCHARS(16)*8-1:0] str;

  `VC_TRACE_BEGIN
  begin

    $sformat( str, "%x:%x", req_a, req_b );
    vc_trace.append_val_rdy_str( trace_str, req_val, req_rdy, str );

    vc_trace.append_str( trace_str, "()" );

    $sformat( str, "%x", resp_result );
    vc_trace.append_val_rdy_str( trace_str, resp_val, resp_rdy, str );

  end
  `VC_TRACE_END

   `endif /* SYNTHESIS */

endmodule

`endif /* EX_GCD_GCD_UNIT_V */

