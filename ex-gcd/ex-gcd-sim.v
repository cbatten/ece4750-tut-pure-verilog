//========================================================================
// Simulator for GCD
//========================================================================

`include "ex-gcd-GcdUnit.v"
`include "vc-TestRandDelaySource.v"
`include "vc-TestRandDelaySink.v"

`include "vc-test.v"
`include "vc-trace.v"

//------------------------------------------------------------------------
// Helper Module
//------------------------------------------------------------------------

module TestHarness
(
  input  logic clk,
  input  logic reset,
  output logic done
);

  logic [31:0] src_msg;
  logic        src_val;
  logic        src_rdy;
  logic        src_done;

  logic [15:0] sink_msg;
  logic        sink_val;
  logic        sink_rdy;
  logic        sink_done;

  vc_TestSource
  #(
    .p_msg_nbits (32),
    .p_num_msgs  (1024)
  )
  src
  (
    .clk         (clk),
    .reset       (reset),

    .val         (src_val),
    .rdy         (src_rdy),
    .msg         (src_msg),

    .done        (src_done)
  );

  ex_gcd_GcdUnit gcd
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

  vc_TestSink
  #(
    .p_msg_nbits (16),
    .p_num_msgs  (1024),
    .p_sim_mode  (1)
  )
  sink
  (
    .clk         (clk),
    .reset       (reset),

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
// Simulation driver
//------------------------------------------------------------------------

module top;

  //----------------------------------------------------------------------
  // Process command line flags
  //----------------------------------------------------------------------

  logic [(512<<3)-1:0] input_dataset;
  logic [(512<<3)-1:0] vcd_dump_file_name;
  integer              stats_en = 0;
  integer              max_cycles;

  initial begin

    // Input dataset

    if ( !$value$plusargs( "input=%s", input_dataset ) ) begin
      input_dataset = "random-a";
    end

    // Maximum cycles

    if ( !$value$plusargs( "max-cycles=%d", max_cycles ) ) begin
      max_cycles = 5000;
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
      $display( " ex-gcd-sim [options]" );
      $display( "" );
      $display( "   +help                 : this message" );
      $display( "   +input=<dataset>      : {random-a,random-b}" );
      $display( "   +max-cycles=<int>     : max cycles to wait until done" );
      $display( "   +trace=<int>          : 1 turns on line tracing" );
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
  // Instantiate the harness
  //----------------------------------------------------------------------

  logic th_reset = 1'b1;
  logic th_done;

  TestHarness th
  (
    .clk   (clk),
    .reset (th_reset),
    .done  (th_done)
  );

  //----------------------------------------------------------------------
  // Helper task to initialize source/sink
  //----------------------------------------------------------------------

  task init
  (
    input logic [ 9:0] i,
    input logic [15:0] a,
    input logic [15:0] b,
    input logic [15:0] result
  );
  begin
    th.src.m[i]  = { a, b };
    th.sink.m[i] = result;
  end
  endtask

  //----------------------------------------------------------------------
  // Drive the simulation
  //----------------------------------------------------------------------

  integer num_inputs = 0;

  initial begin

    #1;

    // Input dataset

    if ( input_dataset == "random-a" ) begin
      `include "ex-gcd-gen-input_random-a.py.v"
    end
    else if ( input_dataset == "random-b" ) begin
      `include "ex-gcd-gen-input_random-b.py.v"
    end
    else begin
      $display( "" );
      $display( " ERROR: Unrecognized input dataset specified with +input!" );
      $display( "" );
      $finish_and_return(1);
    end

    // Reset signal

         th_reset = 1'b1;
    #20; th_reset = 1'b0;

    // Run the simulation

    while ( !th_done && (th.vc_trace.cycles < max_cycles) ) begin
      th.display_trace();
      #10;
    end

    // Check that the simulation actually finished

    if ( !th_done ) begin
      $display( "" );
      $display( " ERROR: Simulation did not finish in time. Maybe increase" );
      $display( " the simulation time limit using the +max-cycles=<int>" );
      $display( " command line parameter?" );
      $display( "" );
      $finish_and_return(1);
    end

    // Output stats

    if ( stats_en ) begin
      $display( "num_cycles              = %0d", th.vc_trace.cycles );
      $display( "avg_num_cycles_per_gcd  = %f",  th.vc_trace.cycles/(1.0*num_inputs) );
    end

    // Finish simulation

    $finish;

  end

endmodule
