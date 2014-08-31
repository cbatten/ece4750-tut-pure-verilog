module top;

  logic [7:0] A;
  logic [7:0] B;
  logic [7:0] C;

  initial begin

    // Basic arithmetic with no overflow or underflow

    A = 8'd28;
    B = 8'd15;

    C = A + B;  $display( "8'd28 + 8'd15 = %d", C );
    C = A - B;  $display( "8'd28 + 8'd15 = %d", C );

    // Basic arithmetic with overflow and underflow

    A = 8'd250;
    B = 8'd15;

    C = A + B;  $display( "8'd250 + 8'd15  = %d", C );
    C = B - A;  $display( "8'd15  - 8'd250 = %d", C );

  end

endmodule
