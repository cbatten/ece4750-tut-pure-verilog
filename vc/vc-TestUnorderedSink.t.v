//========================================================================
// Test Source/Unordered Sink Unit Tests
//========================================================================

`include "vc-TestSource.v"
`include "vc-TestUnorderedSink.v"
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

  vc_TestUnorderedSink#(p_msg_nbits,p_num_msgs) sink
  (
    .clk        (clk),
    .reset      (reset),
    .val        (val),
    .rdy        (rdy),
    .msg        (msg),
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
  `VC_TEST_SUITE_BEGIN( "vc-TestUnorderedSink" )

  //----------------------------------------------------------------------
  // Test Case: ordered 8b messages
  //----------------------------------------------------------------------

  wire        t1_done;
  reg         t1_reset = 1;

  TestHarness#(8) t1
  (
    .clk        (clk),
    .reset      (t1_reset),
    .done       (t1_done)
  );

  `VC_TEST_CASE_BEGIN( 1, "ordered 8b messages" )
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

    `VC_TEST_NET( t1_done, 1'b1 );
  end
  `VC_TEST_CASE_END

  //----------------------------------------------------------------------
  // Test Case: ordered 12b messages
  //----------------------------------------------------------------------

  wire        t2_done;
  reg         t2_reset = 1;

  TestHarness#(13) t2
  (
    .clk        (clk),
    .reset      (t2_reset),
    .done       (t2_done)
  );

  `VC_TEST_CASE_BEGIN( 2, "ordered 13b messages" )
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

    `VC_TEST_NET( t2_done, 1'b1 );
  end
  `VC_TEST_CASE_END

  //----------------------------------------------------------------------
  // Test Case: unordered 8b messages
  //----------------------------------------------------------------------

  wire        t3_done;
  reg         t3_reset = 1;

  TestHarness#(8) t3
  (
    .clk        (clk),
    .reset      (t3_reset),
    .done       (t3_done)
  );

  `VC_TEST_CASE_BEGIN( 3, "ordered 8b messages" )
  begin

    t3.src.m[0] = 8'haa; t3.sink.m[0] = 8'hdd;
    t3.src.m[1] = 8'hbb; t3.sink.m[1] = 8'hcc;
    t3.src.m[2] = 8'hcc; t3.sink.m[2] = 8'hbb;
    t3.src.m[3] = 8'hdd; t3.sink.m[3] = 8'haa;
    t3.src.m[4] = 8'hee; t3.sink.m[4] = 8'hff;
    t3.src.m[5] = 8'hff; t3.sink.m[5] = 8'hee;

    #1;  t3_reset = 1'b1;
    #20; t3_reset = 1'b0;

    while ( !t3_done && (t3.vc_trace.cycles < 5000) ) begin
      t3.display_trace();
      #10;
    end

    `VC_TEST_NET( t3_done, 1'b1 );
  end
  `VC_TEST_CASE_END

  //----------------------------------------------------------------------
  // Test Case: unordered 12b messages
  //----------------------------------------------------------------------

  wire        t4_done;
  reg         t4_reset = 1;

  TestHarness#(13) t4
  (
    .clk        (clk),
    .reset      (t4_reset),
    .done       (t4_done)
  );

  `VC_TEST_CASE_BEGIN( 4, "ordered 13b messages" )
  begin

    t4.src.m[0] = 13'h11aa; t4.sink.m[0] = 13'h06ff;
    t4.src.m[1] = 13'h02bb; t4.sink.m[1] = 13'h15ee;
    t4.src.m[2] = 13'h13cc; t4.sink.m[2] = 13'h04dd;
    t4.src.m[3] = 13'h04dd; t4.sink.m[3] = 13'h13cc;
    t4.src.m[4] = 13'h15ee; t4.sink.m[4] = 13'h02bb;
    t4.src.m[5] = 13'h06ff; t4.sink.m[5] = 13'h11aa;

    #1;   t4_reset = 1'b1;
    #20;  t4_reset = 1'b0;

    while ( !t4_done && (t4.vc_trace.cycles < 5000) ) begin
      t4.display_trace();
      #10;
    end

    `VC_TEST_NET( t4_done, 1'b1 );
  end
  `VC_TEST_CASE_END

  `VC_TEST_SUITE_END
endmodule

