//------------------------------------------------------------------------------
//
//Module Name:					FIR.v
//Department:					Xidian University
//Function Description:	   FIR低通滤波器
//
//------------------------------------------------------------------------------
//
//Version 	Design		Coding		Simulata	  Review		Rel data
//V1.0		Verdvana		Verdvana		Verdvana		        	2019-11-6
//
//-----------------------------------------------------------------------------------

`timescale 1ns/1ns

module FIR(
	/******* 时钟和复位 *******/
		input				clk,			//输入时钟
		input				rst_n,		//复位
	/******** 控制信号 ********/	
		input				clk_en,		//时钟使能
	/****** 数据输入输出 ******/		
		input  [15:0]	filter_in,	//待滤波数字信号输入
		output [15:0]	filter_out	//滤波数字信号输出
);



/******* 滤波器参数设置 ********/

parameter  [7:0]	coeff0 = 8'd7;
parameter  [7:0]	coeff1 = 8'd5;
parameter  [7:0]	coeff2 = 8'd51;
parameter  [7:0]	coeff3 = 8'd135;
parameter  [7:0]	coeff4 = 8'd179;
parameter  [7:0]	coeff5 = 8'd135;
parameter  [7:0]	coeff6 = 8'd51;
parameter  [7:0]	coeff7 = 8'd5;
parameter  [7:0]	coeff8 = 8'd7;


/******** 寄存器设置 ********/
reg [15:0]	delay_pipeline [0:8];	//输入信号延迟寄存器
reg [23:0]	product 			[0:8];	//抽头与系数相乘结果
reg [26:0]	sum;							//相乘结果之和


//--------------------------------------------------
//第一级流水线：输入信号延迟
	
always@(posedge clk or negedge rst_n) begin

	if(!rst_n) begin
	
		delay_pipeline[0] <= 0;
		delay_pipeline[1] <= 0;
		delay_pipeline[2] <= 0;
		delay_pipeline[3] <= 0;
		delay_pipeline[4] <= 0;
		delay_pipeline[5] <= 0;
		delay_pipeline[6] <= 0;
		delay_pipeline[7] <= 0;
		delay_pipeline[8] <= 0;
	
	end
		
		
	else if(clk_en) begin
		
		delay_pipeline[0] <= filter_in;
		delay_pipeline[1] <= delay_pipeline[0];
		delay_pipeline[2] <= delay_pipeline[1];
		delay_pipeline[3] <= delay_pipeline[2];
	   delay_pipeline[4] <= delay_pipeline[3];
		delay_pipeline[5] <= delay_pipeline[4];
		delay_pipeline[6] <= delay_pipeline[5];
		delay_pipeline[7] <= delay_pipeline[6];
	   delay_pipeline[8] <= delay_pipeline[7];
	
	end
end


//--------------------------------------------------
//第二级流水线：抽头与系数相乘
always@(posedge clk or negedge rst_n) begin

	if(!rst_n) begin
		product[0] <= 0; 
		product[1] <= 0; 
		product[2] <= 0; 
		product[3] <= 0; 
	   product[4] <= 0; 
	   product[5] <= 0; 
	   product[6] <= 0; 
	   product[7] <= 0; 
	   product[8] <= 0; 
	end
	
	else if(clk_en) begin
		product[0] <= delay_pipeline[0]*coeff0;
		product[1] <= delay_pipeline[1]*coeff1;
		product[2] <= delay_pipeline[2]*coeff2;
		product[3] <= delay_pipeline[3]*coeff3;
		product[4] <= delay_pipeline[4]*coeff4;
		product[5] <= delay_pipeline[5]*coeff5;
		product[6] <= delay_pipeline[6]*coeff6;
		product[7] <= delay_pipeline[7]*coeff7;
		product[8] <= delay_pipeline[8]*coeff8;
	end

end
	

//--------------------------------------------------	
//第三季流水线：相乘结果再相加
always@(posedge clk or negedge rst_n) begin

	if(!rst_n)
		sum <= 0;
	
	else if(clk_en)
		sum <= (product[8]+product[7]+product[6]+product[5]+product[4]+product[3]+product[2]+product[1]+product[0]);
	
end	
	
	
//--------------------------------------------------
//输出
assign filter_out = sum[26:11];

endmodule
