//=========================================================================
// GcdUnitFL Unit Test Harness
//=========================================================================
// This harness is meant to be instantiated for a specific implementation
// of GCD using the special IMPL macro like this:
//
//  `define EX_GCD_IMPL ex_gcd_Impl
//
//  `include "ex-gcd-Impl.v"
//  `include "ex-gcd-test-harness.v"
//

`include "vc-TestRandDelaySource.v"
`include "vc-TestRandDelaySink.v"
`include "vc-preprocessor.v"
`include "vc-test.v"
`include "vc-trace.v"

//------------------------------------------------------------------------
// Helper Module
//------------------------------------------------------------------------

module TestHarness
(
  input  logic        clk,
  input  logic        reset,
  input  logic [31:0] src_max_delay,
  input  logic [31:0] sink_max_delay,
  output logic        done
);

  logic [31:0] src_msg;
  logic        src_val;
  logic        src_rdy;
  logic        src_done;

  logic [15:0] sink_msg;
  logic        sink_val;
  logic        sink_rdy;
  logic        sink_done;

  vc_TestRandDelaySource#(32) src
  (
    .clk         (clk),
    .reset       (reset),

    .max_delay   (src_max_delay),

    .val         (src_val),
    .rdy         (src_rdy),
    .msg         (src_msg),

    .done        (src_done)
  );

  `EX_GCD_IMPL gcd
  (
    .clk         (clk),
    .reset       (reset),

    .req_val     (src_val),
    .req_rdy     (src_rdy),
    .req_a       (src_msg[31:16]),
    .req_b       (src_msg[15:0]),

    .resp_result (sink_msg),
    .resp_val    (sink_val),
    .resp_rdy    (sink_rdy)
  );

  vc_TestRandDelaySink#(16) sink
  (
    .clk         (clk),
    .reset       (reset),

    .max_delay   (sink_max_delay),

    .val         (sink_val),
    .rdy         (sink_rdy),
    .msg         (sink_msg),

    .done        (sink_done)
  );

  assign done = src_done && sink_done;

  `VC_TRACE_BEGIN
  begin
    src.trace( trace_str );
    vc_trace.append_str( trace_str, " > " );
    gcd.trace( trace_str );
    vc_trace.append_str( trace_str, " > " );
    sink.trace( trace_str );
  end
  `VC_TRACE_END

endmodule

//------------------------------------------------------------------------
// Main Tester Module
//------------------------------------------------------------------------

module top;
  `VC_TEST_SUITE_BEGIN( `VC_PREPROCESSOR_TOSTR(`EX_GCD_IMPL) )

  // Not really used, but the python-generated verilog will set this

  integer num_inputs;

  //----------------------------------------------------------------------
  // Test setup
  //----------------------------------------------------------------------

  // Instantiate the test harness

  logic        th_reset = 1;
  logic [31:0] th_src_max_delay;
  logic [31:0] th_sink_max_delay;
  logic        th_done;

  TestHarness th
  (
    .clk            (clk),
    .reset          (th_reset),
    .src_max_delay  (th_src_max_delay),
    .sink_max_delay (th_sink_max_delay),
    .done           (th_done)
  );

  // Helper task to initialize sorce sink

  task init
  (
    input [ 9:0] i,
    input [15:0] a,
    input [15:0] b,
    input [15:0] result
  );
  begin
    th.src.src.m[i]   = { a, b };
    th.sink.sink.m[i] = result;
  end
  endtask

  // Simple dataset

  task init_simple;
  begin
    //       a         b         result
    init( 0, 16'd27,   16'd15,   16'd3  );
    init( 1, 16'd21,   16'd49,   16'd7  );
    init( 2, 16'd25,   16'd30,   16'd5  );
    init( 3, 16'd19,   16'd27,   16'd1  );
    init( 4, 16'd40,   16'd40,   16'd40 );
    init( 5, 16'd250,  16'd190,  16'd10 );
    init( 6, 16'd5,    16'd250,  16'd5  );
    init( 7, 16'd0,    16'd0,    16'd0  );
    init( 8, 16'hffff, 16'h00ff, 16'hff );
  end
  endtask

  // Helper task to initialize source/sink

  task init_rand_delays
  (
    input logic [31:0] src_max_delay,
    input logic [31:0] sink_max_delay
  );
  begin
    th_src_max_delay  = src_max_delay;
    th_sink_max_delay = sink_max_delay;
  end
  endtask

  // Helper task to run test

  task run_test;
  begin
    #1;   th_reset = 1'b1;
    #20;  th_reset = 1'b0;

    while ( !th_done && (th.vc_trace.cycles < 5000) ) begin
      th.display_trace();
      #10;
    end

    `VC_TEST_NET( th_done, 1'b1 );
  end
  endtask

  //----------------------------------------------------------------------
  // Test Case: src delay = 0, sink delay = 0
  //----------------------------------------------------------------------

  `VC_TEST_CASE_BEGIN( 1, "src delay = 0, sink delay = 0" )
  begin
    init_rand_delays( 0, 0 );
    init_simple;
    run_test;
  end
  `VC_TEST_CASE_END

  //----------------------------------------------------------------------
  // Test Case: src delay = 5, sink delay = 0
  //----------------------------------------------------------------------

  `VC_TEST_CASE_BEGIN( 2, "src delay = 5, sink delay = 0" )
  begin
    init_rand_delays( 5, 0 );
    init_simple;
    run_test;
  end
  `VC_TEST_CASE_END

  //----------------------------------------------------------------------
  // Test Case: src delay = 0, sink delay = 5
  //----------------------------------------------------------------------

  `VC_TEST_CASE_BEGIN( 3, "src delay = 0, sink delay = 5" )
  begin
    init_rand_delays( 0, 5 );
    init_simple;
    run_test;
  end
  `VC_TEST_CASE_END

  //----------------------------------------------------------------------
  // Test Case: src delay = 3, sink delay = 10
  //----------------------------------------------------------------------

  `VC_TEST_CASE_BEGIN( 4, "src delay = 3, sink delay = 10" )
  begin
    init_rand_delays( 3, 10 );
    init_simple;
    run_test;
  end
  `VC_TEST_CASE_END

  //----------------------------------------------------------------------
  // Test Case: src delay = 3, sink delay = 10, random-a dataset
  //----------------------------------------------------------------------

  `VC_TEST_CASE_BEGIN( 5, "src delay = 3, sink delay = 10, random-a dataset" )
  begin
    init_rand_delays( 3, 10 );
    `include "ex-gcd-gen-input_random-a.py.v"
    run_test;
  end
  `VC_TEST_CASE_END

  //----------------------------------------------------------------------
  // Test Case: src delay = 3, sink delay = 10, random-b dataset
  //----------------------------------------------------------------------

  `VC_TEST_CASE_BEGIN( 6, "src delay = 3, sink delay = 10, random-b dataset" )
  begin
    init_rand_delays( 3, 10 );
    `include "ex-gcd-gen-input_random-b.py.v"
    run_test;
  end
  `VC_TEST_CASE_END

  `VC_TEST_SUITE_END
endmodule
