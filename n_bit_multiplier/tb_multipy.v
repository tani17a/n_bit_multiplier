module tb_multipy;
	parameter dp_width=5;
	wire [dp_width*2-1:0] product;
	wire ready;
	reg [dp_width-1:0] multiplier,multiplicand;
	reg reset,clk,start;
	reg mismatched;
	
	seq_multi multi (clk, reset, multiplier, multiplicand, start, product,ready);
	
	initial begin
		clk=0;
		repeat(26) #5 clk=~clk;
	end
	
	initial begin
		start=0;
		reset=0;
		#2 start=1;
		reset=1;
		multiplicand=5'b10111;
		multiplier= 5'b01011;
		#10 start=0;
	end
	initial mismatched=(product!=(multiplicand*multiplier));
endmodule