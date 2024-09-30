`timescale 1ns / 1ps

module four_bit_adder_tb;

    // Inputs
    reg [3:0] a;
    reg [3:0] b;
    reg cin;

    // Outputs
    wire [3:0] sum;
    wire cout;

    // Instantiate the Unit Under Test (UUT)
    four_bit_adder uut (
        .a(a), 
        .b(b), 
        .cin(cin), 
        .sum(sum), 
        .cout(cout)
    );

    integer i, j;
    reg [4:0] expected_sum;

    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;
        cin = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                a = i;
                b = j;
                cin = 0;
                #10; // Wait for 10 ns
                
                expected_sum = a + b + cin;
                if ({cout, sum} !== expected_sum) begin
                    $display("Error: a=%d, b=%d, cin=%d, sum=%d, cout=%d (expected sum=%d)", 
                             a, b, cin, sum, cout, expected_sum);
                end else begin
                    $display("Correct: a=%d, b=%d, cin=%d, sum=%d, cout=%d", 
                             a, b, cin, sum, cout);
                end

                // Test with carry in
                cin = 1;
                #10; // Wait for 10 ns
                
                expected_sum = a + b + cin;
                if ({cout, sum} !== expected_sum) begin
                  $display("Error: a=%b, b=%b, cin=%b, sum=%b, cout=%b (expected sum=%b)", 
                             a, b, cin, sum, cout, expected_sum);
                end else begin
                  $display("Correct: a=%b, b=%b, cin=%b, sum=%b, cout=%b", 
                             a, b, cin, sum, cout);
                end
            end
        end
        
        $finish;
    end
      
endmodule