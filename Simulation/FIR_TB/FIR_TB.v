`timescale 1ns/1ns

module FIR_TB;

reg clk;
reg rst_n;
reg clk_en;
reg [15:0]	filter_in;
wire [15:0]	filter_out;

reg [15:0] data_mem [0:1023];

initial begin
	$readmemh("signal.txt",data_mem);
end


FIR u_FIR(
		.clk(clk),
		.rst_n(rst_n),
		
		.clk_en(clk_en),
		
		.filter_in(filter_in),
		.filter_out(filter_out)
);

initial begin
	clk = 0;
	forever #10 clk=~clk;
end

task task_rst;
begin
	rst_n = 0;
	repeat(2)@(negedge clk);
	rst_n = 1;
end
endtask

task task_sysinit;
begin
	clk_en <= 1;
end
endtask

integer i;

	always@(posedge clk) begin
	
		if(!rst_n) begin
			filter_in <= 0;
			i <= 0;
		end
		
		else begin
			filter_in <=  data_mem[i];
			i <= i+1;
		end
	end


initial
begin
	task_sysinit;
	task_rst;
	#10;
	
	
	
end

/*

integer w_file;

initial w_file = $fopen("d_out.txt");

always@(i) begin

	$fdisplay(w_file,"%h",filter_out);
	if(i==10'd1023)
		$stop;

end

*/
endmodule

