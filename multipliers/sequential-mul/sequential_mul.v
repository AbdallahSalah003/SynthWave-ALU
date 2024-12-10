module sequential_mul(
    input [31:0] A,
    input [31:0] B,
    output [63:0] Product
);

wire [31:0] Ain;
wire [31:0] Bin;
wire [31:0] dump;
wire [63:0] SAdd [32:0];
wire [31:0] sums [31:0];
wire [31:0] carries;
assign Ain = (A[31] == 1) ? (~A + 1) : A;

assign Bin = (B[31] == 1) ? (~B + 1): B;

assign SAdd[0][63:32] = 32'b0;
assign SAdd[0][31:0] = Bin;

genvar i;
reg M;
generate
    for(i=1; i< 33; i=i+1)  begin
        // carry_bypass_32bit(Ain, SAdd[i-1][63:32], 1'b0, SAdd[i][62:31], SAdd[i][63],dump[i-1]);
        carry_bypass_32bit SAbits_(Ain, SAdd[i-1][63:32], 1'b0, sums[i-1],carries[i-1],dump[i-1]);
        assign SAdd[i][63:32] = (SAdd[i-1][0]==0) ? {1'b0,SAdd[i-1][63:33]} : {carries[i-1],sums[i-1][31:1]};
        assign SAdd[i][31:0] = (SAdd[i-1][0]==0) ? SAdd[i-1][32:1]: {sums[i-1][0],SAdd[i-1][31:1]};
    end
endgenerate

assign Product = ((A[31] == 1)^(B[31] == 1))?(~SAdd[32] + 1) : SAdd[32] ;

endmodule
