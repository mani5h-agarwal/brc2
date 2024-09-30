`timescale 1ns / 1ps

// Testbench for 4-bit subtractor using 1's complement and adder
module four_bit_subtractor_tb;

    // Inputs
    reg a3, a2, a1, a0;
    reg b3, b2, b1, b0;
    reg bin;

    // Outputs
    wire diff3, diff2, diff1, diff0;
    wire bout;

    // Instantiate the Unit Under Test (UUT)
    four_bit_subtractor_using_adder uut (
        .a3(a3), .a2(a2), .a1(a1), .a0(a0),
        .b3(b3), .b2(b2), .b1(b1), .b0(b0),
        .bin(bin),
        .diff3(diff3), .diff2(diff2), .diff1(diff1), .diff0(diff0),
        .bout(bout)
    );

    integer i, j;
    reg [4:0] expected_diff;

    initial begin
        // Initialize Inputs
        {a3, a2, a1, a0} = 4'b0000;
        {b3, b2, b1, b0} = 4'b0000;
        bin = 0;

        // Wait 100 ns for global reset to finish
        #100;

        // Add stimulus here
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                {a3, a2, a1, a0} = i[3:0];
                {b3, b2, b1, b0} = j[3:0];
                bin = 0;
                #10; // Wait for 10 ns
                
                expected_diff = {1'b0, a3, a2, a1, a0} - {1'b0, b3, b2, b1, b0} - bin;
                if ({bout, diff3, diff2, diff1, diff0} !== expected_diff[4:0]) begin
                    $display("Error: a=%b, b=%b, bin=%b, diff=%b, bout=%b (expected diff=%b)", 
                             {a3, a2, a1, a0}, {b3, b2, b1, b0}, bin, 
                             {diff3, diff2, diff1, diff0}, bout, expected_diff[3:0]);
                end else begin
                    $display("Correct: a=%b, b=%b, bin=%b, diff=%b, bout=%b", 
                             {a3, a2, a1, a0}, {b3, b2, b1, b0}, bin, 
                             {diff3, diff2, diff1, diff0}, bout);
                end

                // Test with borrow in
                bin = 1;
                #10; // Wait for 10 ns
                
                expected_diff = {1'b0, a3, a2, a1, a0} - {1'b0, b3, b2, b1, b0} - bin;
                if ({bout, diff3, diff2, diff1, diff0} !== expected_diff[4:0]) begin
                    $display("Error: a=%b, b=%b, bin=%b, diff=%b, bout=%b (expected diff=%b)", 
                             {a3, a2, a1, a0}, {b3, b2, b1, b0}, bin, 
                             {diff3, diff2, diff1, diff0}, bout, expected_diff[3:0]);
                end else begin
                    $display("Correct: a=%b, b=%b, bin=%b, diff=%b, bout=%b", 
                             {a3, a2, a1, a0}, {b3, b2, b1, b0}, bin, 
                             {diff3, diff2, diff1, diff0}, bout);
                end
            end
        end
        
        $finish;
    end
      
endmodule


// 4-bit subtractor using an adder and 1's complement logic
module four_bit_subtractor_using_adder(
    input a3, a2, a1, a0,
    input b3, b2, b1, b0,
    input bin,
    output diff3, diff2, diff1, diff0,
    output bout
);

    wire [3:0] B_complement;
    wire [3:0] sum;
    wire carry_out;
    wire end_around_carry;

    // 1's complement of B
    assign B_complement = {b3, b2, b1, b0} ^ 4'b1111;

    // 4-bit adder
    four_bit_adder adder (
        .a({a3, a2, a1, a0}),
        .b(B_complement),
        .cin(bin),
        .sum(sum),
        .cout(carry_out)
    );

    // End-around carry adjustment: if there's a carry-out, add it back to the LSB
    assign {diff3, diff2, diff1, diff0} = sum + carry_out;
    assign bout = carry_out;  // Final borrow out is the carry out from the adder

endmodule


// 4-bit Adder Module
module four_bit_adder(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire c1, c2, c3;

    // Instantiate four 1-bit adders
    full_adder fa0(
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(c1)
    );

    full_adder fa1(
        .a(a[1]),
        .b(b[1]),
        .cin(c1),
        .sum(sum[1]),
        .cout(c2)
    );

    full_adder fa2(
        .a(a[2]),
        .b(b[2]),
        .cin(c2),
        .sum(sum[2]),
        .cout(c3)
    );

    full_adder fa3(
        .a(a[3]),
        .b(b[3]),
        .cin(c3),
        .sum(sum[3]),
        .cout(cout)
    );

endmodule


// Full Adder Module
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (cin & a);

endmodule