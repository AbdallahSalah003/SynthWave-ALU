import sys


def generate_carry_lines(file,bits):
    for i in range(bits):
        if i :
            line = f"\tassign C[{i}] = G[{i}]"
            for pref_len in range(1,i+2):
                p_terms= [f"P[{idx}]" for idx in range(i,i-pref_len,-1)]
                term = "&".join(p_terms)
                term = term + (f"&G[{i-pref_len}]" if pref_len < i+1 else "&Cin")
                line = f"{line} | ({term})"
        else:
            line = "\tassign C[0] = G[0] | (P[0] & Cin)"
        line = f"{line};"
        file.write(line)
        file.write('\n')

def generate_cla_verilog(bits):
    with open('carry_look_ahead_adder.v','w') as file:
        file.write(f"module carry_look_ahead_adder(\n\tinput [{bits-1}:0] A,\n\tinput [{bits-1}:0] B,\n\tinput Cin,\n\toutput [{bits-1}:0] Sum,\n\toutput Cout);\n")
        file.write(f"\twire [{bits-1}:0] G, P,C;\n")
        file.write(f"\tassign G = A & B;\n")
        file.write(f"\tassign P = A ^ B;\n")
        generate_carry_lines(file,bits)
        file.write(f"\tassign Sum = A ^ B ^ {{C[{bits-2}:0], Cin}};\n")
        file.write(f"\tassign Cout = C[{bits-1}];\n")
        file.write("endmodule")
        
        
if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script_adder.py <number_of_bits>")
        sys.exit(1)
    try:
        bits = int(sys.argv[1])
    except ValueError:
        print("Please provide a valid integer for the number of bits.")
        sys.exit(1)
    generate_cla_verilog(bits)