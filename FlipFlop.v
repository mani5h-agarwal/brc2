module sr_flipflop(
    input wire s,        // Set input
    input wire r,        // Reset input
    input wire clk,      // Clock input
    output reg q,        // Output
    output reg q_bar     // Complement of output
);
    
    always @(posedge clk) begin
        if (s == 1 && r == 0) begin
            q <= 1;
            q_bar <= 0;
        end
        else if (s == 0 && r == 1) begin
            q <= 0;
            q_bar <= 1;
        end
        else if (s == 0 && r == 0) begin
            q <= q;       // Hold state
            q_bar <= q_bar;
        end
        else if (s == 1 && r == 1) begin
            q <= 1'bx;    // Invalid state
            q_bar <= 1'bx;
        end
    end
endmodule


module jk_flipflop(
    input wire j,        // J input
    input wire k,        // K input
    input wire clk,      // Clock input
    output reg q,        // Output
    output reg q_bar     // Complement of output
);
    
    always @(posedge clk) begin
        if (j == 0 && k == 0) begin
            q <= q;        // Hold state
            q_bar <= q_bar;
        end
        else if (j == 0 && k == 1) begin
            q <= 0;
            q_bar <= 1;
        end
        else if (j == 1 && k == 0) begin
            q <= 1;
            q_bar <= 0;
        end
        else if (j == 1 && k == 1) begin
            q <= ~q;       // Toggle state
            q_bar <= ~q_bar;
        end
    end
endmodule



module tb_sr_flipflop;

    reg s;
    reg r;
    reg clk;
    wire q;
    wire q_bar;

    // Instantiate the SR flip-flop
    sr_flipflop uut (
        .s(s),
        .r(r),
        .clk(clk),
        .q(q),
        .q_bar(q_bar)
    );

    // Generate clock signal
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period of 10 time units
    end

    // Apply test cases
    initial begin
        // Initialize inputs
        s = 0; r = 0;
        
        // Test Case 1: Set = 0, Reset = 0 (Hold state)
        #10 s = 0; r = 0;
        
        // Test Case 2: Set = 1, Reset = 0 (Set Q = 1)
        #10 s = 1; r = 0;
        
        // Test Case 3: Set = 0, Reset = 1 (Reset Q = 0)
        #10 s = 0; r = 1;

        // Test Case 4: Set = 1, Reset = 1 (Invalid state)
        #10 s = 1; r = 1;
        
        // Test Case 5: Set = 0, Reset = 0 (Hold state)
        #10 s = 0; r = 0;
        
        // Finish simulation after 60 time units
        #20 $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("At time %t: s = %b, r = %b, q = %b, q_bar = %b", $time, s, r, q, q_bar);
    end
endmodule



module tb_jk_flipflop;

    reg j;
    reg k;
    reg clk;
    wire q;
    wire q_bar;

    // Instantiate the JK flip-flop
    jk_flipflop uut (
        .j(j),
        .k(k),
        .clk(clk),
        .q(q),
        .q_bar(q_bar)
    );

    // Generate clock signal
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period of 10 time units
    end

    // Apply test cases
    initial begin
        // Initialize inputs
        j = 0; k = 0;
        
        // Test Case 1: J = 0, K = 0 (Hold state)
        #10 j = 0; k = 0;
        
        // Test Case 2: J = 1, K = 0 (Set Q = 1)
        #10 j = 1; k = 0;
        
        // Test Case 3: J = 0, K = 1 (Reset Q = 0)
        #10 j = 0; k = 1;

        // Test Case 4: J = 1, K = 1 (Toggle state)
        #10 j = 1; k = 1;

        // Test Case 5: J = 0, K = 0 (Hold state)
        #10 j = 0; k = 0;
        
        // Finish simulation after 60 time units
        #20 $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("At time %t: j = %b, k = %b, q = %b, q_bar = %b", $time, j, k, q, q_bar);
    end
endmodule


module mealy_sr_flipflop(
    input wire s,        // Set input
    input wire r,        // Reset input
    input wire clk,      // Clock input
    output reg q,        // Output
    output reg q_bar     // Complement of output
);

    always @(posedge clk) begin
        if (s == 1 && r == 0) begin
            q <= 1;
            q_bar <= 0;
        end
        else if (s == 0 && r == 1) begin
            q <= 0;
            q_bar <= 1;
        end
        else if (s == 0 && r == 0) begin
            // Hold state (output depends on current state)
            q <= q;
            q_bar <= q_bar;
        end
        else if (s == 1 && r == 1) begin
            // Invalid state (Mealy output)
            q <= 1'bx;    // Undefined state
            q_bar <= 1'bx;
        end
    end
endmodule


module mealy_jk_flipflop(
    input wire j,        // J input
    input wire k,        // K input
    input wire clk,      // Clock input
    output reg q,        // Output
    output reg q_bar     // Complement of output
);

    always @(posedge clk) begin
        if (j == 0 && k == 0) begin
            // Hold state (output depends on current state)
            q <= q;
            q_bar <= q_bar;
        end
        else if (j == 0 && k == 1) begin
            q <= 0;       // Reset state
            q_bar <= 1;
        end
        else if (j == 1 && k == 0) begin
            q <= 1;       // Set state
            q_bar <= 0;
        end
        else if (j == 1 && k == 1) begin
            q <= ~q;      // Toggle state
            q_bar <= ~q_bar;
        end
    end
endmodule



module tb_mealy_sr_flipflop;

    reg s;
    reg r;
    reg clk;
    wire q;
    wire q_bar;

    // Instantiate the SR flip-flop (Mealy Model)
    mealy_sr_flipflop uut (
        .s(s),
        .r(r),
        .clk(clk),
        .q(q),
        .q_bar(q_bar)
    );

    // Generate clock signal
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period of 10 time units
    end

    // Apply test cases
    initial begin
        // Initialize inputs
        s = 0; r = 0;
        
        // Test Case 1: Set = 0, Reset = 0 (Hold state)
        #10 s = 0; r = 0;
        
        // Test Case 2: Set = 1, Reset = 0 (Set Q = 1)
        #10 s = 1; r = 0;
        
        // Test Case 3: Set = 0, Reset = 1 (Reset Q = 0)
        #10 s = 0; r = 1;

        // Test Case 4: Set = 1, Reset = 1 (Invalid state)
        #10 s = 1; r = 1;
        
        // Test Case 5: Set = 0, Reset = 0 (Hold state)
        #10 s = 0; r = 0;
        
        // Finish simulation after 60 time units
        #20 $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("At time %t: s = %b, r = %b, q = %b, q_bar = %b", $time, s, r, q, q_bar);
    end
endmodule
module tb_mealy_jk_flipflop;

    reg j;
    reg k;
    reg clk;
    wire q;
    wire q_bar;

    // Instantiate the JK flip-flop (Mealy Model)
    mealy_jk_flipflop uut (
        .j(j),
        .k(k),
        .clk(clk),
        .q(q),
        .q_bar(q_bar)
    );

    // Generate clock signal
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period of 10 time units
    end

    // Apply test cases
    initial begin
        // Initialize inputs
        j = 0; k = 0;
        
        // Test Case 1: J = 0, K = 0 (Hold state)
        #10 j = 0; k = 0;
        
        // Test Case 2: J = 1, K = 0 (Set Q = 1)
        #10 j = 1; k = 0;
        
        // Test Case 3: J = 0, K = 1 (Reset Q = 0)
        #10 j = 0; k = 1;

        // Test Case 4: J = 1, K = 1 (Toggle state)
        #10 j = 1; k = 1;

        // Test Case 5: J = 0, K = 0 (Hold state)
        #10 j = 0; k = 0;
        
        // Finish simulation after 60 time units
        #20 $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("At time %t: j = %b, k = %b, q = %b, q_bar = %b", $time, j, k, q, q_bar);
    end
endmodule



module moore_sr_flipflop(
    input wire s,        // Set input
    input wire r,        // Reset input
    input wire clk,      // Clock input
    output reg q,        // Output
    output reg q_bar     // Complement of output
);

    reg state;          // Internal state

    always @(posedge clk) begin
        case ({s, r})
            2'b01: state <= 0;  // Reset state
            2'b10: state <= 1;  // Set state
            2'b00: state <= state; // Hold state
            2'b11: state <= 1'bx;  // Invalid state
        endcase
    end

    // Output is only dependent on state (Moore model)
    always @(*) begin
        q = state;
        q_bar = ~state;
    end
endmodule

module moore_jk_flipflop(
    input wire j,        // J input
    input wire k,        // K input
    input wire clk,      // Clock input
    output reg q,        // Output
    output reg q_bar     // Complement of output
);

    reg state;          // Internal state

    always @(posedge clk) begin
        case ({j, k})
            2'b01: state <= 0;    // Reset state
            2'b10: state <= 1;    // Set state
            2'b11: state <= ~state; // Toggle state
            2'b00: state <= state;  // Hold state
        endcase
    end

    // Output is only dependent on state (Moore model)
    always @(*) begin
        q = state;
        q_bar = ~state;
    end
endmodule

module tb_moore_sr_flipflop;

    reg s;
    reg r;
    reg clk;
    wire q;
    wire q_bar;

    // Instantiate the SR flip-flop (Moore Model)
    moore_sr_flipflop uut (
        .s(s),
        .r(r),
        .clk(clk),
        .q(q),
        .q_bar(q_bar)
    );

    // Generate clock signal
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period of 10 time units
    end

    // Apply test cases
    initial begin
        // Initialize inputs
        s = 0; r = 0;
        
        // Test Case 1: Set = 0, Reset = 0 (Hold state)
        #10 s = 0; r = 0;
        
        // Test Case 2: Set = 1, Reset = 0 (Set Q = 1)
        #10 s = 1; r = 0;
        
        // Test Case 3: Set = 0, Reset = 1 (Reset Q = 0)
        #10 s = 0; r = 1;

        // Test Case 4: Set = 1, Reset = 1 (Invalid state)
        #10 s = 1; r = 1;
        
        // Test Case 5: Set = 0, Reset = 0 (Hold state)
        #10 s = 0; r = 0;
        
        // Finish simulation after 60 time units
        #20 $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("At time %t: s = %b, r = %b, q = %b, q_bar = %b", $time, s, r, q, q_bar);
    end
endmodule

module tb_moore_jk_flipflop;

    reg j;
    reg k;
    reg clk;
    wire q;
    wire q_bar;

    // Instantiate the JK flip-flop (Moore Model)
    moore_jk_flipflop uut (
        .j(j),
        .k(k),
        .clk(clk),
        .q(q),
        .q_bar(q_bar)
    );

    // Generate clock signal
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period of 10 time units
    end

    // Apply test cases
    initial begin
        // Initialize inputs
        j = 0; k = 0;
        
        // Test Case 1: J = 0, K = 0 (Hold state)
        #10 j = 0; k = 0;
        
        // Test Case 2: J = 1, K = 0 (Set Q = 1)
        #10 j = 1; k = 0;
        
        // Test Case 3: J = 0, K = 1 (Reset Q = 0)
        #10 j = 0; k = 1;

        // Test Case 4: J = 1, K = 1 (Toggle state)
        #10 j = 1; k = 1;

        // Test Case 5: J = 0, K = 0 (Hold state)
        #10 j = 0; k = 0;
        
        // Finish simulation after 60 time units
        #20 $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("At time %t: j = %b, k = %b, q = %b, q_bar = %b", $time, j, k, q, q_bar);
    end
endmodule



module sr_counter(
    input wire clk,   // Clock input
    input wire reset, // Reset input
    output reg [3:0] q // 4-bit output for the counter
);

    // Internal state for each flip-flop
    reg [3:0] state;

    // Counter implementation using SR flip-flops
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset the counter to 0
            state <= 4'b0000;
        end
        else begin
            // Increment the state (binary counting)
            state <= state + 1;
        end
    end

    // Output is just the state in Moore model
    always @(*) begin
        q = state;
    end
endmodule

module jk_counter(
    input wire clk,    // Clock input
    input wire reset,  // Reset input
    output reg [3:0] q // 4-bit output for the counter
);

    // Internal state for each flip-flop
    reg [3:0] state;

    // Counter implementation using JK flip-flops
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset the counter to 0
            state <= 4'b0000;
        end
        else begin
            // Increment the state (binary counting)
            state <= state + 1;
        end
    end

    // Output is just the state in Moore model
    always @(*) begin
        q = state;
    end
endmodule

module tb_sr_counter;

    reg clk;
    reg reset;
    wire [3:0] q;

    // Instantiate the counter
    sr_counter uut (
        .clk(clk),
        .reset(reset),
        .q(q)
    );

    // Generate clock signal
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period of 10 time units
    end

    // Apply test cases
    initial begin
        // Initialize reset
        reset = 1;
        #10 reset = 0;

        // Run the simulation for 100 time units
        #100 $finish;
    end

    // Monitor output
    initial begin
        $monitor("At time %t: q = %b", $time, q);
    end
endmodule


module tb_jk_counter;

    reg clk;
    reg reset;
    wire [3:0] q;

    // Instantiate the counter
    jk_counter uut (
        .clk(clk),
        .reset(reset),
        .q(q)
    );

    // Generate clock signal
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period of 10 time units
    end

    // Apply test cases
    initial begin
        // Initialize reset
        reset = 1;
        #10 reset = 0;

        // Run the simulation for 100 time units
        #100 $finish;
    end

    // Monitor output
    initial begin
        $monitor("At time %t: q = %b", $time, q);
    end
endmodule