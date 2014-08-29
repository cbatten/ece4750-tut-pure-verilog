//========================================================================
// vc-TestRandDelaySource Unit Tests
//========================================================================

`include "vc-TestRandDelaySource.v"
`include "vc-TestSink.v"
`include "vc-test.v"
`include "vc-trace.v"

//------------------------------------------------------------------------
// Test Harness
//------------------------------------------------------------------------

module TestHarness
#(
  parameter p_msg_nbits = 8,
  parameter p_num_msgs  = 1024
)(
  input         clk,
  input         reset,
  input  [31:0] max_delay,
  output [31:0] num_failed,
  output        done
);

  wire                   val;
  wire                   rdy;
  wire [p_msg_nbits-1:0] msg;

  wire                   src_done;
  wire                   sink_done;

  vc_TestRandDelaySource#(p_msg_nbits,p_num_msgs) src
  (
    .clk        (clk),
    .reset      (reset),
    .max_delay  (max_delay),
    .val        (val),
    .rdy        (rdy),
    .msg        (msg),
    .done       (src_done)
  );

  vc_TestSink#(p_msg_nbits,p_num_msgs) sink
  (
    .clk        (clk),
    .reset      (reset),
    .val        (val),
    .rdy        (rdy),
    .msg        (msg),
    .num_failed (num_failed),
    .done       (sink_done)
  );

  assign done = src_done && sink_done;

  `VC_TRACE_BEGIN
  begin
    src.trace( trace_str );
    vc_trace.append_str( trace_str, " > " );
    sink.trace( trace_str );
  end
  endtask

endmodule

//------------------------------------------------------------------------
// Main Tester Module
//------------------------------------------------------------------------

module top;
  `VC_TEST_SUITE_BEGIN( "vc-TestRandDelaySource" )

  //----------------------------------------------------------------------
  // Test setup
  //----------------------------------------------------------------------

  // Instantiate the test harness

  reg         th_reset = 1;
  reg  [31:0] th_max_delay;
  wire [31:0] th_num_failed;
  wire        th_done;

  TestHarness th
  (
    .clk        (clk),
    .reset      (th_reset),
    .max_delay  (th_max_delay),
    .num_failed (th_num_failed),
    .done       (th_done)
  );

  // Load source/sinks

  initial begin
    `define SRC_MEM  th.src.src.m
    `define SINK_MEM th.sink.m
    `include "vc-test-src-sink-input-gen_ordered.py.v"
  end

  // Helper task to run test

  task run_test;
  begin
    #1;   th_reset = 1'b1;
    #20;  th_reset = 1'b0;

    while ( !th_done && (th.vc_trace.cycles < 5000) ) begin
      th.display_trace();
      #10;
    end

    `VC_TEST_INCREMENT_NUM_FAILED( th_num_failed );
    `VC_TEST_NET( th_done, 1'b1 );
  end
  endtask

  //----------------------------------------------------------------------
  // Test Case: random delay = 0
  //----------------------------------------------------------------------

  `VC_TEST_CASE_BEGIN( 1, "random delay = 0" )
  begin
    th_max_delay = 0;
    run_test();
  end
  `VC_TEST_CASE_END

  //----------------------------------------------------------------------
  // Test Case: random delay = 1
  //----------------------------------------------------------------------

  `VC_TEST_CASE_BEGIN( 2, "random delay = 1" )
  begin
    th_max_delay = 1;
    run_test();
  end
  `VC_TEST_CASE_END

  //----------------------------------------------------------------------
  // Test Case: random delay = 2
  //----------------------------------------------------------------------

  `VC_TEST_CASE_BEGIN( 3, "random delay = 2" )
  begin
    th_max_delay = 2;
    run_test();
  end
  `VC_TEST_CASE_END

  //----------------------------------------------------------------------
  // Test Case: random delay = 10
  //----------------------------------------------------------------------

  `VC_TEST_CASE_BEGIN( 4, "random delay = 10" )
  begin
    th_max_delay = 10;
    run_test();
  end
  `VC_TEST_CASE_END

  `VC_TEST_SUITE_END
endmodule

