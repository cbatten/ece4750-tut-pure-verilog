//========================================================================
// ex-sorter-SorterFlat Unit Test Harness
//========================================================================
// This harness is meant to be instantiated for a specific implementation
// of the sorter using the special IMPL macro like this:
//
//  `define EX_SORTER_IMPL ex_sorter_Impl
//
//  `include "ex-sorter-Impl.v"
//  `include "ex-sorter-test-harness.v"
//

`include "vc-preprocessor.v"
`include "vc-test.v"
`include "vc-trace.v"

module top;
  `VC_TEST_SUITE_BEGIN( `VC_PREPROCESSOR_TOSTR(`EX_SORTER_IMPL) )

  // Not really used, but the python-generated verilog will set this

  integer num_inputs;

  //----------------------------------------------------------------------
  // Instantiate DUT and create helper task
  //----------------------------------------------------------------------

  logic        t1_reset = 1;
  logic        t1_in_val;
  logic [7:0]  t1_in0, t1_in1, t1_in2, t1_in3;
  logic       t1_out_val;
  logic [7:0] t1_out0, t1_out1, t1_out2, t1_out3;

  `EX_SORTER_IMPL#(8) t1_sorter
  (
    .clk     (clk),
    .reset   (t1_reset),

    .in_val  (t1_in_val),
    .in0     (t1_in0),
    .in1     (t1_in1),
    .in2     (t1_in2),
    .in3     (t1_in3),

    .out_val (t1_out_val),
    .out0    (t1_out0),
    .out1    (t1_out1),
    .out2    (t1_out2),
    .out3    (t1_out3)
  );

  // Helper task

  task t1
  (
    input logic       in_val,
    input logic [7:0] in0, in1, in2, in3,
    input logic       out_val,
    input logic [7:0] out0, out1, out2, out3
  );
  begin
    t1_in_val = in_val;
    t1_in0 = in0; t1_in1 = in1; t1_in2 = in2; t1_in3 = in3;
    #1;
    t1_sorter.display_trace();
    `VC_TEST_NOTE_INPUTS_1( in_val );
    `VC_TEST_NOTE_INPUTS_4( in0, in1, in2, in3 );
    `VC_TEST_NET( t1_out_val, out_val );
    `VC_TEST_NET( t1_out0, out0 );
    `VC_TEST_NET( t1_out1, out1 );
    `VC_TEST_NET( t1_out2, out2 );
    `VC_TEST_NET( t1_out3, out3 );
    #9;
  end
  endtask

  //----------------------------------------------------------------------
  // Test Basic
  //----------------------------------------------------------------------

  `VC_TEST_CASE_BEGIN( 1, "directed tests" )
  begin

    #1;  t1_reset = 1'b1;
    #20; t1_reset = 1'b0;

    // One sort at a time

    //  v  in0    in1    in2    in3    v  out0   out1   out2   out3
    t1( 1, 8'h01, 8'h02, 8'h03, 8'h04, 0, 8'h??, 8'h??, 8'h??, 8'h?? );
    t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx, 0, 8'h??, 8'h??, 8'h??, 8'h?? );
    t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx, 0, 8'h??, 8'h??, 8'h??, 8'h?? );
    t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx, 1, 8'h01, 8'h02, 8'h03, 8'h04 );

    //  v  in0    in1    in2    in3    v  out0   out1   out2   out3
    t1( 1, 8'h04, 8'h03, 8'h02, 8'h01, 0, 8'h??, 8'h??, 8'h??, 8'h?? );
    t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx, 0, 8'h??, 8'h??, 8'h??, 8'h?? );
    t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx, 0, 8'h??, 8'h??, 8'h??, 8'h?? );
    t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx, 1, 8'h01, 8'h02, 8'h03, 8'h04 );

    //  v  in0    in1    in2    in3    v  out0   out1   out2   out3
    t1( 1, 8'h04, 8'h02, 8'h03, 8'h01, 0, 8'h??, 8'h??, 8'h??, 8'h?? );
    t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx, 0, 8'h??, 8'h??, 8'h??, 8'h?? );
    t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx, 0, 8'h??, 8'h??, 8'h??, 8'h?? );
    t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx, 1, 8'h01, 8'h02, 8'h03, 8'h04 );

    //  v  in0    in1    in2    in3    v  out0   out1   out2   out3
    t1( 1, 8'h00, 8'h01, 8'h00, 8'h01, 0, 8'h??, 8'h??, 8'h??, 8'h?? );
    t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx, 0, 8'h??, 8'h??, 8'h??, 8'h?? );
    t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx, 0, 8'h??, 8'h??, 8'h??, 8'h?? );
    t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx, 1, 8'h00, 8'h00, 8'h01, 8'h01 );

    // Multiple sorts at once

    //  v  in0    in1    in2    in3    v  out0   out1   out2   out3
    t1( 1, 8'h04, 8'h03, 8'h02, 8'h01, 0, 8'h??, 8'h??, 8'h??, 8'h?? );
    t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx, 0, 8'h??, 8'h??, 8'h??, 8'h?? );
    t1( 1, 8'h05, 8'h07, 8'h06, 8'h08, 0, 8'h??, 8'h??, 8'h??, 8'h?? );
    t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx, 1, 8'h01, 8'h02, 8'h03, 8'h04 );
    t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx, 0, 8'h??, 8'h??, 8'h??, 8'h?? );
    t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx, 1, 8'h05, 8'h06, 8'h07, 8'h08 );

    //  v  in0    in1    in2    in3    v  out0   out1   out2   out3
    t1( 1, 8'h04, 8'h03, 8'h02, 8'h01, 0, 8'h??, 8'h??, 8'h??, 8'h?? );
    t1( 1, 8'ha5, 8'ha3, 8'ha2, 8'ha7, 0, 8'h??, 8'h??, 8'h??, 8'h?? );
    t1( 1, 8'h05, 8'h07, 8'h06, 8'h08, 0, 8'h??, 8'h??, 8'h??, 8'h?? );
    t1( 1, 8'hb0, 8'hb1, 8'hb0, 8'hb1, 1, 8'h01, 8'h02, 8'h03, 8'h04 );
    t1( 1, 8'hc7, 8'hc1, 8'hc2, 8'hc6, 1, 8'ha2, 8'ha3, 8'ha5, 8'ha7 );
    t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx, 1, 8'h05, 8'h06, 8'h07, 8'h08 );
    t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx, 1, 8'hb0, 8'hb0, 8'hb1, 8'hb1 );
    t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx, 1, 8'hc1, 8'hc2, 8'hc6, 8'hc7 );

    t1( 0, 8'hxx, 8'hxx, 8'hxx, 8'hxx, 0, 8'h??, 8'h??, 8'h??, 8'h?? );

  end
  `VC_TEST_CASE_END

  //+++ gen-harness : begin cut ++++++++++++++++++++++++++++++++++++++++++

  //----------------------------------------------------------------------
  // Test Case: random inputs
  //----------------------------------------------------------------------

  `VC_TEST_CASE_BEGIN( 2, "random inputs" )
  begin

    #1;  t1_reset = 1'b1;
    #20; t1_reset = 1'b0;

    `include "ex-sorter-gen-input_random.py.v"

  end
  `VC_TEST_CASE_END

  //----------------------------------------------------------------------
  // Test Case: sorted forward inputs
  //----------------------------------------------------------------------

  `VC_TEST_CASE_BEGIN( 3, "sorted forward inputs" )
  begin

    #1;  t1_reset = 1'b1;
    #20; t1_reset = 1'b0;

    `include "ex-sorter-gen-input_sorted-fwd.py.v"

  end
  `VC_TEST_CASE_END

  //----------------------------------------------------------------------
  // Test Case: sorted reverse inputs
  //----------------------------------------------------------------------

  `VC_TEST_CASE_BEGIN( 4, "sorted reverse inputs" )
  begin

    #1;  t1_reset = 1'b1;
    #20; t1_reset = 1'b0;

    `include "ex-sorter-gen-input_sorted-rev.py.v"

  end
  `VC_TEST_CASE_END

  //+++ gen-harness : end cut ++++++++++++++++++++++++++++++++++++++++++++

  `VC_TEST_SUITE_END
endmodule

