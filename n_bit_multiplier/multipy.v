module seq_multi( clk,reset,multiplier,multiplicand,start,
	product,ready);

		parameter dp_width=5;//size of reg
		parameter BC_size=3;//size of counter
		output [dp_width*2-1:0] product;
		output ready;
		input [dp_width-1:0] multiplicand,multiplier;
		input start, reset, clk;
 
		parameter [2:0] IDEAL= 3'b001, MUL0=3'b010, MUL1=3'b100;
		reg [2:0] state,next_state; //state,next_state
		reg [dp_width-1:0] A,B,Q; // A,B,Q
		reg  C;
		reg [BC_size-1:0] P; //counter
		reg load_regs, decr_p, add_regs, shift_regs;
		wire zero;

		assign product={A,Q};
		assign zero=(P==0);
		wire ready=(state==IDEAL);
		
		always@(posedge clk , negedge reset)begin
			if (~reset) begin state= IDEAL; end
			else begin state=next_state;
			end
		end

		always@(*)begin
			load_regs=0; decr_p=0; add_regs=0; shift_regs=0;
			case(state)
				IDEAL: begin 
					if (start) begin next_state= MUL0; load_regs=1 ; end
					else next_state=IDEAL;
					end
				MUL0:begin
					next_state=MUL1;
					decr_p=1;
					if (Q[0]) add_regs=1;
				end
				MUL1: begin
					shift_regs=1;
					if(zero) next_state=IDEAL;
					else next_state=MUL0;
				end
				default: next_state=IDEAL;
			endcase
		end
		// datapath
		always@(posedge clk )begin
    			if(load_regs) begin
				P<=dp_width;
				A<=0;
				C<=0;
				B<=multiplicand;
				Q<=multiplier;
			end
			if (add_regs) {C,A}<= A+B;
			if (shift_regs) {C,A,Q} <= {C,A,Q} >>1;
			if (decr_p) P<=P-1;
		end
endmodule
	