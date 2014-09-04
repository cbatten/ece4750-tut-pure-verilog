// Declare struct type

typedef struct packed {  // Packed format:
  logic [3:0] x;         //   11 8 7  4 3  0
  logic [3:0] y;         //  +----+----+----+
  logic [3:0] z;         //  | x  | y  | z  |
} point_t;               //  +----+----+----+

module top;

  // Declare variables

  point_t point_a;
  point_t point_b;

  // Declare other variables using $bits()

  logic [$bits(point_t)-1:0] point_bits;

  initial begin

    // Reading and writing fields

    point_a.x = 4'h3;
    point_a.y = 4'h4;
    point_a.z = 4'h5;

    $display( "point_a.x = %x", point_a.x );
    $display( "point_a.y = %x", point_a.y );
    $display( "point_a.z = %x", point_a.z );

    // Assign structs

    point_b = point_a;

    $display( "point_b.x = %x", point_b.x );
    $display( "point_b.y = %x", point_b.y );
    $display( "point_b.z = %x", point_b.z );

    // Assign structs to bit vector

    point_bits = point_a;

    $display( "point_bits = %x", point_bits );

    // Assign bit vector to struct

    point_bits = { 4'd13, 4'd9, 4'd3 };
    point_a = point_bits;

    $display( "point_a.x = %x", point_a.x );
    $display( "point_a.y = %x", point_a.y );
    $display( "point_a.z = %x", point_a.z );

  end

endmodule
