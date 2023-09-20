module ALU1 (
  input [7:0] a,b,
  input clk,en,
  input [3:0]s,
  output reg [15:0] y,
  output reg carry, zero
); 
  reg [7:0] a_in , b_in ; //in
  reg [1:0] flags; //flags
  reg [15:0] out_y ; // o.p
  initial begin
    y=0;
    carry=0;
    zero=0;
  end

always @(posedge clk ,posedge en) begin
  if (en) begin
    a_in<=0;b_in<=0;y<=0;
    carry<=0; zero<=0;
  end
  else begin
    a_in <= a; 
	 b_in <= b;
	 y <= out_y;
carry <= flags [0]; 
zero <= flags [1];
  end
end

always @(a_in,b_in,s) begin
  flags =2'd0;
  case (s)
  4'd0:begin
 out_y ={8'd0,(a_in+b_in)};
  flags[0] = out_y[8];//get carry if any
 end

   4'd1:begin
 out_y ={8'd0,(a_in - b_in)};
  flags[0] = out_y[8];//get difference if any
 end

 
 4'd2: begin
  out_y ={8'd0,(a_in + 1'b1)};
  flags[0] = out_y[8]; //get carry if any
 end

  4'd3:begin
  out_y ={8'd0,(a_in - 1'b1)};
  flags[0] = out_y[8]; //get difference if any
 end

 
  4'd4:out_y = {8'd0,(a_in * b_in)}; 
 
  4'd5:out_y = {8'd0,(a_in / b_in)}; 
  
  4'd6:out_y = {8'd0,(a_in & b_in)}; 
 
  4'd7:out_y = {8'd0,(a_in | b_in)}; 
   
  4'd8:out_y = {8'd0,(a_in ^ b_in)}; 
  
  4'd9:out_y = {8'd0,~(a_in & b_in)}; 
  
  4'd10:out_y = {8'd0,~(a_in | b_in)}; 
  
  4'd11:out_y = {8'd0,~(a_in ^ b_in)};// concatinate to produce 16 bits o.p
  
  4'd12:begin
     flags[0] = a_in[7]; 
        out_y = {8'd0 , (a_in<<1)};
  end

    4'd13: begin
        flags[0] = a_in[0] ; // Update carry flag
        out_y = {8'd0, (a_in>>1)}; // Shift Right
    end
    4'd14: out_y = {8'd0, a_in [0], a_in [7:1]}; // right rotate
    4'd15: out_y = {8'd0, a_in [6:0], a_in[7]}; // left rotate


  default: out_y=16'd0;
  endcase
  if(!out_y) flags[1]=2'd0;//if y = 0 then set flag[1] ie zero as high
  
end
endmodule