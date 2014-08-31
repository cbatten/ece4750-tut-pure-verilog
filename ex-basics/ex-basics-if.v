module top;

  logic [7:0] a;
  logic [7:0] b;
  logic [7:0] c;
  logic [1:0] sel;

  initial begin

    // if statement

    a = 8'd30;
    b = 8'd16;

    if ( a < b )
      $display( "30 < 16 is true" );

    if ( a == b )
      $display( "30 == 16 is true" );

    if ( a > b )
      $display( "30 > 16 is true" );

    // if else statement

    sel = 1'b1;

    if ( sel == 2'd0 )
      c = 8'h0a;
    else if ( sel == 2'd1 )
      c = 8'h0b;
    else
      c = 8'h0c;

    $display( "sel = 1, c = %x ", c );

    // if else statement w/ X

    sel = 1'bx;

    if ( sel == 2'd0 )
      c = 8'h0a;
    else if ( sel == 2'd1 )
      c = 8'h0b;
    else
      c = 8'h0c;

    $display( "sel = x, c = %x ", c );

    // nested if statement

    a = 8'd30;
    b = 8'd16;
    c = 8'd30;

    if ( a > b ) begin
      if ( a == c ) begin
        $display( "30 > 16 and 30 == 30 is true" );
      end
    end

  end

endmodule
