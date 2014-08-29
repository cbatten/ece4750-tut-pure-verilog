//========================================================================
// Test Source/Sink Unit Tests
//========================================================================

`include "vc-TestSource.v"
`include "vc-TestSink.v"
`include "vc-test.v"
`include "vc-trace.v"

//------------------------------------------------------------------------
// Test Harness
//------------------------------------------------------------------------

module TestHarness
#(
  parameter p_msg_nbits = 1,
  parameter p_num_msgs  = 1024
)(
  input         clk,
  input         reset,
  output [31:0] num_failed,
  output        done
);

  wire                   val;
  wire                   rdy;
  wire [p_msg_nbits-1:0] msg;

  wire                   src_done;
  wire                   sink_done;

  vc_TestSource#(p_msg_nbits,p_num_msgs) src
  (
    .clk        (clk),
    .reset      (reset),
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
  `VC_TRACE_END

endmodule

//------------------------------------------------------------------------
// Main Tester Module
//------------------------------------------------------------------------

module top;
  `VC_TEST_SUITE_BEGIN( "vc-TestSink" )

  //----------------------------------------------------------------------
  // Test Case: 8b messages
  //----------------------------------------------------------------------

  wire [31:0] t1_num_failed;
  wire        t1_done;
  reg         t1_reset = 1;

  TestHarness#(8) t1
  (
    .clk        (clk),
    .reset      (t1_reset),
    .num_failed (t1_num_failed),
    .done       (t1_done)
  );

  `VC_TEST_CASE_BEGIN( 1, "8b messages" )
  begin

    t1.src.m[0] = 8'haa; t1.sink.m[0] = 8'haa;
    t1.src.m[1] = 8'hbb; t1.sink.m[1] = 8'hbb;
    t1.src.m[2] = 8'hcc; t1.sink.m[2] = 8'hcc;
    t1.src.m[3] = 8'hdd; t1.sink.m[3] = 8'hdd;
    t1.src.m[4] = 8'hee; t1.sink.m[4] = 8'hee;
    t1.src.m[5] = 8'hff; t1.sink.m[5] = 8'hff;

    #1;  t1_reset = 1'b1;
    #20; t1_reset = 1'b0;

    while ( !t1_done && (t1.vc_trace.cycles < 5000) ) begin
      t1.display_trace();
      #10;
    end

    `VC_TEST_INCREMENT_NUM_FAILED( t1_num_failed );
    `VC_TEST_NET( t1_done, 1'b1 );
  end
  `VC_TEST_CASE_END

  //----------------------------------------------------------------------
  // Test Case: 12b messages
  //----------------------------------------------------------------------

  wire [31:0] t2_num_failed;
  wire        t2_done;
  reg         t2_reset = 1;

  TestHarness#(13) t2
  (
    .clk        (clk),
    .reset      (t2_reset),
    .num_failed (t2_num_failed),
    .done       (t2_done)
  );

  `VC_TEST_CASE_BEGIN( 2, "13b messages" )
  begin

    t2.src.m[0] = 13'h11aa; t2.sink.m[0] = 13'h11aa;
    t2.src.m[1] = 13'h02bb; t2.sink.m[1] = 13'h02bb;
    t2.src.m[2] = 13'h13cc; t2.sink.m[2] = 13'h13cc;
    t2.src.m[3] = 13'h04dd; t2.sink.m[3] = 13'h04dd;
    t2.src.m[4] = 13'h15ee; t2.sink.m[4] = 13'h15ee;
    t2.src.m[5] = 13'h06ff; t2.sink.m[5] = 13'h06ff;

    #1;   t2_reset = 1'b1;
    #20;  t2_reset = 1'b0;

    while ( !t2_done && (t2.vc_trace.cycles < 5000) ) begin
      t2.display_trace();
      #10;
    end

    `VC_TEST_INCREMENT_NUM_FAILED( t2_num_failed );
    `VC_TEST_NET( t2_done, 1'b1 );
  end
  `VC_TEST_CASE_END

  `VC_TEST_SUITE_END
endmodule

