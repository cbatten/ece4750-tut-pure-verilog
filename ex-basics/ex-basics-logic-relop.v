module top;

  // Declare multi-bit logic variables

  logic        a; // 1-bit logic variable
  logic [ 3:0] A; // 4-bit logic variable
  logic [ 3:0] B; // 4-bit logic variable

  initial begin

    // Relational operators

    A = 4'd15; B = 4'd09;

    a = ( A == B );   $display( "(15 == 9) = %x", a );
    a = ( A != B );   $display( "(15 != 9) = %x", a );
    a = ( A >  B );   $display( "(15 >  9) = %x", a );
    a = ( A >= B );   $display( "(15 >= 9) = %x", a );
    a = ( A <  B );   $display( "(15 <  9) = %x", a );
    a = ( A <= B );   $display( "(15 <= 9) = %x", a );

    // Relational operators when some bits are X

    A = 4'b1100; B = 4'b10xx;

    a = ( A == B );   $display( "(4'b1100 == 4'b10xx) = %x", a );
    a = ( A != B );   $display( "(4'b1100 != 4'b10xx) = %x", a );
    a = ( A >  B );   $display( "(4'b1100 >  4'b10xx) = %x", a );
    a = ( A <  B );   $display( "(4'b1100 <  4'b10xx) = %x", a );

    // Signed relational operators

    A = 4'b1111; // -1 in twos complement
    B = 4'd0001; //  1 in twos complement

    a = (         A  >         B  ); $display( "(-1 > 1) = %x", a );
    a = (         A  <         B  ); $display( "(-1 < 1) = %x", a );
    a = ( $signed(A) > $signed(B) ); $display( "(-1 > 1) = %x", a );
    a = ( $signed(A) < $signed(B) ); $display( "(-1 < 1) = %x", a );

  end

endmodule
