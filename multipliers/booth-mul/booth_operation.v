module booth_operation(
    input [31:0] a, q, m, // accumlator, multiplier, multiplicand
    input q_1, // last bit after shift
    output reg [31:0] nextA, nextQ,
    output reg nextQ_1
);
    reg [31:0] nextATemp;
    wire [31:0] sumAM, subAM;
    wire coutSum, coutSub;
    NBitAdder #(32) sum(a, m, 1'b0, sumAM, coutSum);
    NBitAdder #(32) sub(a, ~m, 1'b1, subAM, coutSub);

    always @(*) begin
        if({q[0], q_1} == 2'b01) begin
            nextATemp = sumAM;
        end
        else if({q[0], q_1} == 2'b10) begin
            nextATemp = subAM; 
        end
        else begin
            nextATemp = a;
        end 
        nextQ_1 = q[0];
        nextQ = q >> 1;
        nextQ[31] = nextATemp[0];
        nextA = nextATemp >> 1;
        nextA[31] = nextATemp[31];
    end

endmodule