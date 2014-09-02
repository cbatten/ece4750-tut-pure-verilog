module top;

  logic [3:0] a;
  logic [7:0] b;

  initial begin

    // casez statement

    a = 4'b0100;

    casez ( a )

      4'b0000 : b = 8'd0;
      4'b???1 : b = 8'd1;
      4'b??10 : b = 8'd2;
      4'b?100 : b = 8'd3;
      4'b1000 : b = 8'd4;

      default : b = 8'hxx;
    endcase

    $display( "a = 4'b0100, b = %x", b );

    // casez statement w/ Xs

    a = 4'b01xx;

    casez ( a )

      4'b0000 : b = 8'd0;
      4'b???1 : b = 8'd1;
      4'b??10 : b = 8'd2;
      4'b?100 : b = 8'd3;
      4'b1000 : b = 8'd4;

      default : b = 8'hxx;
    endcase

    $display( "a = 4'b01xx, b = %x", b );

  end

endmodule
