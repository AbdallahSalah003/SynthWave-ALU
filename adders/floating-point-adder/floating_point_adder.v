module floating_point_adder (
    input [31:0] A,
    input [31:0] B,
    output [31:0] Sum,
    output Cout,
    output Overflow

);
        reg [7:0] diff, tempExp;
        reg [24:0] mantissaA, mantissaB, mantissas_sum;
        reg mantissas_sign;
        reg [31:0] mantissas_padded;
        wire [4:0] shiftAmount;
        wire [24:0] adderResult;
        wire adderCout, adderOverflow;
        reg [4:0] realShiftAmount;
        reg mantissas_overflow;
        reg mantissas_cin;
        msb msb0(mantissas_padded, shiftAmount);
        carry_bypass_32bit fpadder(mantissaA, mantissaB, mantissas_cin, adderResult, adderCout, adderOverflow );

        always @(*) begin
            mantissaA = {2'b01, A[22:0]};
            mantissaB = {2'b01, B[22:0]};
            mantissas_padded = 1'd0;
            mantissas_cin = 1'b0;
            mantissas_overflow = 1'b0;
            realShiftAmount = 1'd0;

                if (A == 1'd0 | B == 1'd0) begin 
                    if (A == 1'd0) begin
                        mantissas_sum = mantissaB;
                        tempExp = B[30:23];
                        mantissas_sign = B[31];
                    end
                    else begin
                        mantissas_sum = mantissaA;
                        tempExp = A[30:23];
                        mantissas_sign = A[31];
                    end

                    if (mantissas_sum == 25'h0800000 & tempExp == 1'd0) begin
                        mantissas_sign = 1'b0;
                    end

                end
                else begin
                    diff = A[30:23] - B[30:23];
                    if(diff[7] == 1'b0) begin
                        mantissaB = mantissaB >> diff; // shift B to make B exponent greater
                        tempExp = A[30:23];
                        mantissas_sign = A[31];

                    end 
                    else begin
                        diff = (~diff) + 1;
                        mantissaA = mantissaA >> diff; // shift A to make A exponent greater
                        tempExp = B[30:23];
                        mantissas_sign = B[31];
                    end

                    if ((A[31]^B[31]) == 1'b1) begin 
                        mantissas_cin = 1'b1;
                        if (A[31] == 1'b1) begin
                            mantissaA = ~mantissaA;
                        end
                        else begin 
                            mantissaB = ~mantissaB;                    
                        end

                        mantissas_sum = adderResult;

                        if (diff == 1'd0) begin
                            mantissas_sign = mantissas_sum[24];
                        end

                        if (mantissas_sign == 1'b1) begin
                            mantissas_sum = ~mantissas_sum +1;
                        end

                        if (mantissas_sum[23] == 1'b0) begin
                            mantissas_padded = {mantissas_sum[23:0], 8'b00000000};
                            realShiftAmount = ~(shiftAmount);
                            tempExp = tempExp - realShiftAmount;
                            mantissas_sum = mantissas_sum << realShiftAmount;
                        end
                    end
                    else begin
                        mantissas_sum = adderResult;
                        mantissas_sign = A[31];
                        if (mantissas_sum[24] == 1'b1) begin
                            tempExp = tempExp + 1'b1;
                            mantissas_sum = mantissas_sum >> 1; 
                        end
                    end
                    if (mantissas_sum == 25'h0ffffff & tempExp == 8'hfe) begin
                    mantissas_overflow = 1'b1;
                    end
                end
            end

        assign Cout = mantissas_sum[24];
        assign Sum[31] = mantissas_sign;
        assign Sum[22:0] = mantissas_sum[22:0];
        assign Sum[30:23] = tempExp;
        assign Overflow = mantissas_overflow;
endmodule