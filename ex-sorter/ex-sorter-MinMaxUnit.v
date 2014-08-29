//========================================================================
// MinMaxUnit
//========================================================================
// This module takes two inputs, compares them, and outputs the larger
// via the "max" output port and the smaller via the "min" output port.

`ifndef EX_SORTER_MIN_MAX_UNIT_V
`define EX_SORTER_MIN_MAX_UNIT_V

module ex_sorter_MinMaxUnit
#(
  parameter p_nbits = 1
)(
  input  logic [p_nbits-1:0] in0,
  input  logic [p_nbits-1:0] in1,
  output logic [p_nbits-1:0] out_min,
  output logic [p_nbits-1:0] out_max
);

  // We simply directly connect the inputs to the outputs as a place
  // holder. You will need to implement the real min/max functionality
  // instead. Ensure that your design handles the case where the
  // inputs contain X's.

  assign out_min = in0;
  assign out_max = in1;

endmodule

`endif /* EX_SORTER_MIN_MAX_UNIT_V */

