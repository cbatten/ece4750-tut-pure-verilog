//========================================================================
// Simulator Harness for Sorter
//========================================================================
// This harness is meant to be instantiated for a specific implementation
// of the sorter using the special IMPL macro like this:
//
//  `define EX_SORTER_IMPL ex_sorter_Impl
//
//  `include "ex-sorter-Impl.v"
//  `include "ex-sorter-sim-harness.v"
//

module top;

  //----------------------------------------------------------------------
  // Process command line flags
  //----------------------------------------------------------------------

  logic [(512<<3)-1:0] input_dataset;
  logic [(512<<3)-1:0] vcd_dump_file_name;
  logic                stats_en = 0;

  initial begin

    // Input dataset

    if ( !$value$plusargs( "input=%s", input_dataset ) ) begin
      input_dataset = "random";
    end

    // VCD dumping

    if ( $value$plusargs( "dump-vcd=%s", vcd_dump_file_name ) ) begin
      $dumpfile(vcd_dump_file_name);
      $dumpvars;
    end

    // Output stats

    if ( $test$plusargs( "stats" ) ) begin
      stats_en = 1;
    end

    // Usage message

    if ( $test$plusargs( "help" ) ) begin
      $display( "" );
      $display( " ex-sorter-sim-<impl> [options]" );
      $display( "" );
      $display( "   +help                 : this message" );
      $display( "   +input=<dataset>      : {random,sorted-fwd,sorted-rev}" );
      $display( "   +trace=<int>          : enable line tracing" );
      $display( "   +dump-vcd=<file-name> : dump VCD to given file name" );
      $display( "   +stats                : display statistics" );
      $display( "" );
      $finish;
    end

  end

  //----------------------------------------------------------------------
  // Generate clock
  //----------------------------------------------------------------------

  logic clk = 1;
  always #5 clk = ~clk;

  //----------------------------------------------------------------------
  // Instantiate the implementation
  //----------------------------------------------------------------------

  logic        t1_reset = 1;

  logic        t1_in_val;
  logic  [7:0] t1_in0;
  logic  [7:0] t1_in1;
  logic  [7:0] t1_in2;
  logic  [7:0] t1_in3;

  logic       t1_out_val;
  logic [7:0] t1_out0;
  logic [7:0] t1_out1;
  logic [7:0] t1_out2;
  logic [7:0] t1_out3;

  `EX_SORTER_IMPL#(8) sorter
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

  //----------------------------------------------------------------------
  // Helper task
  //----------------------------------------------------------------------

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
    sorter.display_trace();
    #9;
  end
  endtask

  //----------------------------------------------------------------------
  // Drive the simulation
  //----------------------------------------------------------------------

  integer num_inputs = 0;

  initial begin

    // Reset signal

    #1;  t1_reset = 1'b1;
    #20; t1_reset = 1'b0;

    // Input dataset

    if ( input_dataset == "random" ) begin
      `include "ex-sorter-gen-input_random.py.v"
    end
    else if ( input_dataset == "sorted-fwd" ) begin
      `include "ex-sorter-gen-input_sorted-fwd.py.v"
    end
    else if ( input_dataset == "sorted-rev" ) begin
      `include "ex-sorter-gen-input_sorted-rev.py.v"
    end
    else begin
      $display( "" );
      $display( " ERROR: Unrecognized input dataset specified with +input!" );
      $display( "" );
      $finish_and_return(1);
    end

    // Output stats (assumes we are doing 100 sorts)

    if ( stats_en ) begin
      $display( "num_cycles              = %0d", sorter.vc_trace.cycles );
      $display( "avg_num_cycles_per_sort = %f",  sorter.vc_trace.cycles/(1.0*num_inputs) );
    end

    // Finish simulation

    $finish;

  end

endmodule

