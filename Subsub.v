`timescale 1ns / 1ps

module four_bit_subtractor_tb;

    // Inputs
    reg a3, a2, a1, a0;
    reg b3, b2, b1, b0;
    reg bin;

    // Outputs
    wire diff3, diff2, diff1, diff0;
    wire bout;

    // Instantiate the Unit Under Test (UUT)
    four_bit_subtractor uut (
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
                
                expected_diff = ({1'b0, a3, a2, a1, a0} - {1'b0, b3, b2, b1, b0} - bin);
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
                
                expected_diff = ({1'b0, a3, a2, a1, a0} - {1'b0, b3, b2, b1, b0} - bin);
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


module four_bit_subtractor(
    input a3, a2, a1, a0,
    input b3, b2, b1, b0,
    input bin,
    output diff3, diff2, diff1, diff0,
    output bout
);

    wire [3:0] B_complement;
    wire borrow1, borrow2, borrow3;
    wire end_around_carry;

    // Calculate 1's complement of B
    assign B_complement = {b3, b2, b1, b0} ^ 4'b1111;  // Bitwise negation

    // Perform subtraction using 1's complement approach
    full_subtractor fs0(
        .a(a0),
        .b(B_complement[0]),
        .bin(bin),
        .diff(diff0),
        .bout(borrow1)
    );

    full_subtractor fs1(
        .a(a1),
        .b(B_complement[1]),
        .bin(borrow1),
        .diff(diff1),
        .bout(borrow2)
    );

    full_subtractor fs2(
        .a(a2),
        .b(B_complement[2]),
        .bin(borrow2),
        .diff(diff2),
        .bout(borrow3)
    );

    full_subtractor fs3(
        .a(a3),
        .b(B_complement[3]),
        .bin(borrow3),
        .diff(diff3),
        .bout(bout)
    );

    // End-around carry adjustment
    assign end_around_carry = bout;
    assign {diff3, diff2, diff1, diff0} = {diff3, diff2, diff1, diff0} + end_around_carry;

endmodule

// Full Subtractor module
module full_subtractor(
    input a,
    input b,
    input bin,
    output diff,
    output bout
);

    assign diff = a ^ b ^ bin;
    assign bout = (~a & b) | (bin & (~a | b));

endmodule