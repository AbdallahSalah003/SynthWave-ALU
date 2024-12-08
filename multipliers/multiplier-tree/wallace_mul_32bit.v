
module wallace_mul_32bit (
    input [31:0] A,
    input [31:0] B,
    output [63:0] Product
);

wire [31:0]a1;
wire [31:0]b1;
wire [63:0]res;

wire [15:0] m [15:0] ;

wire [63:0] r [15:0] ;

wire [63:0] s [4:0];
wire [63:0] c [4:0];

wire [63:0] s2 [2:0];
wire [63:0] c2 [2:0];
 
wire [63:0] s3 [1:0];
wire [63:0] c3 [1:0];

 
wire [63:0] s4 [1:0];
wire [63:0] c4 [1:0];

 
wire [63:0] s5 ;
wire [63:0] c5 ;

wire [63:0] s6 ;
wire [63:0] c6 ;

wire [63:0] c7 ;


assign a1 = (A[31]) ? ~A+1 : A;
assign b1 = (B[31]) ? ~B+1 : B;

wallace_mul_8bit M1 (a1[7:0],b1[7:0],m[0]);                              
wallace_mul_8bit M2 (a1[7:0],b1[15:8],m[1]);                  
wallace_mul_8bit M3 (a1[7:0],b1[23:16],m[2]);                 
wallace_mul_8bit M4 (a1[7:0],b1[31:24],m[3]);                 
wallace_mul_8bit M5 (a1[15:8],b1[7:0],m[4]);                  
wallace_mul_8bit M6 (a1[15:8],b1[15:8],m[5]);                  
wallace_mul_8bit M7 (a1[15:8],b1[23:16],m[6]);                 
wallace_mul_8bit M8 (a1[15:8],b1[31:24],m[7]);                 
wallace_mul_8bit M9 (a1[23:16],b1[7:0],m[8]);                
wallace_mul_8bit MA (a1[23:16],b1[15:8],m[9]);              
wallace_mul_8bit MB (a1[23:16],b1[23:16],m[10]);              
wallace_mul_8bit MC (a1[23:16],b1[31:24],m[11]);                  
wallace_mul_8bit MD (a1[31:24],b1[7:0],m[12]);                    
wallace_mul_8bit ME (a1[31:24],b1[15:8],m[13]);                 
wallace_mul_8bit MF (a1[31:24],b1[23:16],m[14]);             
wallace_mul_8bit MG (a1[31:24],b1[31:24],m[15]);              

assign r[0]    = {48'b0,m[0]};
assign r[1]    = {40'b0,m[1],8'b0};
assign r[2]    = {40'b0,m[4],8'b0};
assign r[3]    = {32'b0,m[2],16'b0};
assign r[4]    = {32'b0,m[5],16'b0};
assign r[5]    = {32'b0,m[8],16'b0};
assign r[6]    = {24'b0,m[3],24'b0};
assign r[7]    = {24'b0,m[6],24'b0};
assign r[8]    = {24'b0,m[9],24'b0};
assign r[9]    = {24'b0,m[12],24'b0};
assign r[10]   = {16'b0,m[7],32'b0};
assign r[11]   = {16'b0,m[10],32'b0};
assign r[12]   = {16'b0,m[13],32'b0};
assign r[13]   = {8'b0,m[11],40'b0};
assign r[14]   = {8'b0,m[14],40'b0};
assign r[15]   = {m[15],48'b0};


adder64 ad1(r[0],r[1],r[2],s[0],c[0]);
adder64 ad2(r[3],r[4],r[5],s[1],c[1]);
adder64 ad3(r[6],r[7],r[8],s[2],c[2]);
adder64 ad4(r[9],r[10],r[11],s[3],c[3]);
adder64 ad5(r[12],r[13],r[14],s[4],c[4]);


adder64 t2(s[0],s[1],s[2],s2[0],c2[0]);
adder64 t3(s[3],s[4],c[0],s2[1],c2[1]);
adder64 t4(c[1],c[2],c[3],s2[2],c2[2]);


adder64 t5(s2[0],s2[1],s2[2],s3[0],c3[0]);
adder64 t6(c2[0],c2[1],c2[2],s3[1],c3[1]);

adder64 t7(s3[0],s3[1],c3[0],s4[0],c4[0]);
adder64 t8(c3[1],c[4],r[15],s4[1],c4[1]);





adder64 t9(s4[0],s4[1],c4[0],s5,c5);
adder64 ta(c4[1],s5,c5,s6,c6);


ha to(s6[0],c6[0],res[0],c7[0]);

genvar i;
generate
    for (i =1;i<64;i=i+1) begin : adderb
        fa tc(.in1(s6[i]),.in2(c6[i]),.in3(c7[i-1]),.s(res[i]),.c(c7[i]));
    end
endgenerate


assign Product = ((A[31]&B[31])|((~A[31]))&(~B[31]))?res: ~ res + 1;

endmodule 