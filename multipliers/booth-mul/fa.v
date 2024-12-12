module fa (
    input  in1,
    input  in2,
    input  in3,
    output s,
    output c
);

    // assign {c, s} = in1 + in2 + in3;
    assign s = in1 ^ in2 ^ in3;  
    assign c = (in1 & in2) | (in2 & in3) | (in1 & in3); 

endmodule  