//========================================================================
// Verilog Basics: Display
//========================================================================

// A module is the most fundamental unit of hardware design. In this case
// we are simply using a module to encapsulate a sequence of initial
// statements that we will use to experiement with basic Verilog
// constructs.

module top;

  // An initial block executes at the very beginning of "time" in the
  // simulation. There is no such thing as the beginning of time in real
  // hardware, so this construct is _not_ synthesizable. If you would
  // like to model real hardware doing something on reset then you need
  // to explicitly use a reset signal. Initial statements can be useful
  // for test harnesses.

  initial begin

    // The display statement prints out the given string. It is a "system
    // task" and is obvoiusly not synthesizable. '\n' inserts a newline.
    // We can use the display statement for debugging, tracing, and
    // experimenting with Verilog constructs.

    $display( "Hello World!" );

  end


endmodule

