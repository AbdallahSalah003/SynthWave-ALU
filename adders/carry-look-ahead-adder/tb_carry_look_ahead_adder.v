module tb_carry_look_ahead_adder;
  reg [31:0] a, b;
  reg cin;
  wire [31:0] sum;
  wire cout;

  // Instantiate the carry-look-ahead adder
  cla_adder uut (
    a,
    b,
    cin,
    sum,
    cout
  );

  initial begin
    // Test vector 1
    a = 32'h00000001; b = 32'h00000002; cin = 0;
    #10;
    $display("Test 1: a=%h, b=%h, cin=%b, sum=%h, cout=%b", a, b, cin, sum, cout);

    // Test vector 2
    a = 32'h00000006; b = 32'h00000005; cin = 1;
    #10;
    $display("Test 2: a=%h, b=%h, cin=%b, sum=%h, cout=%b", a, b, cin, sum, cout);

    // Test vector 3
    a = 32'hFFFFFFFF; b = 32'h00000001; cin = 0;
    #10;
    $display("Test 3: a=%h, b=%h, cin=%b, sum=%h, cout=%b", a, b, cin, sum, cout);

    // Test vector 4
    a = 32'h80000000; b = 32'h80000000; cin = 1;
    #10;
    $display("Test 4: a=%h, b=%h, cin=%b, sum=%h, cout=%b", a, b, cin, sum, cout);

    // Test vector 5
    a = 32'h12345678; b = 32'h87654321; cin = 0;
    #10;
    $display("Test 5: a=%h, b=%h, cin=%b, sum=%h, cout=%b", a, b, cin, sum, cout);

    // Test vector 6
    a = 32'hAAAAAAAA; b = 32'h55555555; cin = 1;
    #10;
    $display("Test 6: a=%h, b=%h, cin=%b, sum=%h, cout=%b", a, b, cin, sum, cout);

    // End simulation
    $finish;
  end
endmodule