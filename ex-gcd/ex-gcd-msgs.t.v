//========================================================================
// ex-gcd-msgs Unit Tests
//========================================================================

`include "ex-gcd-msgs.v"
`include "vc-test.v"

module top;
  `VC_TEST_SUITE_BEGIN( "ex-gcd-msgs" )

  //----------------------------------------------------------------------
  // Test GCD Request Message
  //----------------------------------------------------------------------

  // Declare request message variable

  ex_gcd_req_msg_t req_msg;

  // Helper task

  task t1
  (
    input [15:0] a,
    input [15:0] b
  );
  begin
    req_msg.a = a;
    req_msg.b = b;
    #1;
    `VC_TEST_NET( req_msg.a, a );
    `VC_TEST_NET( req_msg.b, b );
    #9;
  end
  endtask

  // Test case

  `VC_TEST_CASE_BEGIN( 1, "ex_gcd_req_msg_t" )
  begin

    #21;

    t1( 16'h0a0a, 16'h0b0b );
    t1( 16'h0c0c, 16'h0d0d );
    t1( 16'h0e0e, 16'h0f0f );

  end
  `VC_TEST_CASE_END

  //----------------------------------------------------------------------
  // Test GCD Response Message
  //----------------------------------------------------------------------

  // Declare response message variable

  ex_gcd_resp_msg_t resp_msg;

  // Helper task

  task t2
  (
    input [15:0] result
  );
  begin
    resp_msg.result = result;
    #1;
    `VC_TEST_NET( resp_msg, result );
    #9;
  end
  endtask

  // Test case

  `VC_TEST_CASE_BEGIN( 2, "ex_gcd_resp_msg_t" )
  begin

    #21;

    t2( 16'h0a0a );
    t2( 16'h0c0c );
    t2( 16'h0e0e );

  end
  `VC_TEST_CASE_END

  `VC_TEST_SUITE_END
endmodule

