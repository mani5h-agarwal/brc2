module x(a, b, c, d, p, q, r, s, cin, cout, s1, s2, s3, s4);

    input a, b, c, d, cin, p, q, r, s;
    output cout, s1, s2, s3, s4;
    wire m1, m2, m3;



    sum1 x1(a, p, cin, s1, m1);
    sum1 x2(b, q, m1, s2, m2);
    sum1 x3(c, r, m2, s3, m3);
    sum1 x4(d, s, m3, s4, cout);


endmodule 

module sum1(a, b, cin, sum, cout);

    input a, b, cin;
    output sum, cout;

    assign sum = a^b^cin;
    assign cout = (a&b) | (b&cin) | (cin&a);

endmodule