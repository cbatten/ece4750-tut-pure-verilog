module top;

  // Declare single-bit logic variables.

  logic a;
  logic b;
  logic c;

  initial begin

    // Single-bit literals

    a = 1'b0;    $display( "1'b0   = %x ", a );
    a = 1'b1;    $display( "1'b1   = %x ", a );
    a = 1'bx;    $display( "1'bx   = %x ", a );
    a = 1'bz;    $display( "1'bz   = %x ", a );

    // Bitwise logical operators for doing AND, OR, XOR, and NOT

    a = 1'b0;
    b = 1'b1;

    c = a & b;   $display( "0 & 1  = %x ", c );
    c = a | b;   $display( "0 | 1  = %x ", c );
    c = a ^ b;   $display( "0 ^ 1  = %x ", c );
    c = ~b;      $display( "~1     = %x ", c );

    // Bitwise logical operators for doing AND, OR, XOR, and NOT with X

    a = 1'b0;
    b = 1'bx;

    c = a & b;   $display( "0 & x  = %x ", c );
    c = a | b;   $display( "0 | x  = %x ", c );
    c = a ^ b;   $display( "0 ^ x  = %x ", c );
    c = ~b;      $display( "~x     = %x ", c );

    // Boolean logical operators

    a = 1'b0;
    b = 1'b1;

    c = a && b;  $display( "0 && 1 = %x ", c );
    c = a || b;  $display( "0 || 1 = %x ", c );
    c = !b;      $display( "!1     = %x ", c );

  end

endmodule
