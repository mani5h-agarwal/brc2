module testbench;

    reg a, b, c, d, cin, p, q, r, s;
    wire cout, s1, s2, s3, s4;


    x l(a, b, c, d, p, q, r, s, 0, cout, s1, s2, s3, s4);

    initial begin 
        for(integer i = 0; i < 16; i = i + 1) begin
            {a, b, c, d} = i;
            for(integer  j = 0; j < 16; j = j + 1) begin
                {p, q, r, s} = j;
                #10;
            end
        end

    end

    initial begin
        $monitor("%b%b%b%b     %b%b%b%b    %b%b%b%b%b", d, c, b, a, s, r, q, p, cout, s4, s3, s2, s1);
    end


endmodule