module top;

  logic [7:0] A;
  logic [7:0] B;
  logic [7:0] C;

  initial begin

    // Fixed shift amount for logical shifts

    A = 8'b1110_0101;

    C = A << 1;            $display( "8'b1110_0101 << 1 = %b", C );
    C = A << 2;            $display( "8'b1110_0101 << 2 = %b", C );
    C = A << 3;            $display( "8'b1110_0101 << 3 = %b", C );

    C = A >> 1;            $display( "8'b1110_0101 >> 1 = %b", C );
    C = A >> 2;            $display( "8'b1110_0101 >> 2 = %b", C );
    C = A >> 3;            $display( "8'b1110_0101 >> 3 = %b", C );

    // Fixed shift amount for arithmetic shifts

    A = 8'b0110_0100;

    C = $signed(A) >>> 1;  $display( "8'b0110_0100 >>> 1 = %b", C );
    C = $signed(A) >>> 2;  $display( "8'b0110_0100 >>> 2 = %b", C );
    C = $signed(A) >>> 3;  $display( "8'b0110_0100 >>> 3 = %b", C );

    A = 8'b1110_0101;

    C = $signed(A) >>> 1;  $display( "8'b1110_0101 >>> 1 = %b", C );
    C = $signed(A) >>> 2;  $display( "8'b1110_0101 >>> 2 = %b", C );
    C = $signed(A) >>> 3;  $display( "8'b1110_0101 >>> 3 = %b", C );

    // Variable shift amount for logical shifts

    A = 8'b1110_0101;
    B = 8'd2;

    C = A << B;            $display( "8'b1110_0101 << 2 = %b", C );
    C = A >> B;            $display( "8'b1110_0101 >> 2 = %b", C );

  end

endmodule
