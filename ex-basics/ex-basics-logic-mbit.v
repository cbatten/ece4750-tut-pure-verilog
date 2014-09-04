module top;

  // Declare multi-bit logic variables

  logic [ 3:0] A; // 4-bit  logic variable
  logic [ 3:0] B; // 4-bit  logic variable
  logic [ 3:0] C; // 4-bit  logic variable
  logic [11:0] D; // 12-bit logic variable

  initial begin

    // Multi-bit literals

    A = 4'b0101;             $display( "4'b0101            = %x", A );
    D = 12'b1100_1010_0101;  $display( "12'b1100_1010_0101 = %x", D );
    D = 12'hca5;             $display( "12'hca5            = %x", D );
    D = 12'd1058;            $display( "12'd1058           = %x", D );

    // Bitwise logical operators for doing AND, OR, XOR, and NOT

    A = 4'b0101;
    B = 4'b0011;

    C = A & B;    $display( "4'b0101 &  4'b0011 = %b", C );
    C = A | B;    $display( "4'b0101 |  4'b0011 = %b", C );
    C = A ^ B;    $display( "4'b0101 ^  4'b0011 = %b", C );
    C = A ^~ B;   $display( "4'b0101 ^~ 4'b0011 = %b", C );
    C = ~B;       $display( "~4'b0011          = %b", C );

    // Bitwise logical operators when some bits are X

    A = 4'b0101;
    B = 4'b00xx;

    C = A & B;    $display( "4'b0101 &  4'b00xx = %b", C );
    C = A | B;    $display( "4'b0101 |  4'b00xx = %b", C );
    C = A ^ B;    $display( "4'b0101 ^  4'b00xx = %b", C );
    C = A ^~ B;   $display( "4'b0101 ^~ 4'b00xx = %b", C );
    C = ~B;       $display( "~4'b00xx           = %b", C );

    // Reduction operators

    A = 4'b0101;

    C = &A;       $display( " & 4'b0101 = %b", C );
    C = ~&A;      $display( "~& 4'b0101 = %b", C );
    C = |A;       $display( " | 4'b0101 = %b", C );
    C = ~|A;      $display( "~| 4'b0101 = %b", C );
    C = ^A;       $display( "^  4'b0101 = %b", C );
    C = ^~A;      $display( "^~ 4'b0101 = %b", C );

  end

endmodule
