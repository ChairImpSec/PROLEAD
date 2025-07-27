`timescale 1ns / 1ps

module tb_aes;

    // Inputs
    reg clk = 0;
    reg start = 0;
    reg [127:0] plaintext = 128'b0;
    reg [127:0] key = 128'b0;

    // Outputs
    wire [127:0] ciphertext;
    wire done;

    // Clock period definition
    parameter CLK_PERIOD = 10;  // in ns

    // Instantiate the Unit Under Test (UUT)
    aes uut (
        .clk(clk),
        .start(start),
        .plaintext(plaintext),
        .key(key),
        .ciphertext(ciphertext),
        .done(done)
    );

    // Clock generation
    always begin
        # (CLK_PERIOD / 2) clk = ~clk;
    end

    // Stimulus process
    initial begin
        // Wait for 1 clock cycle before starting stimulus
        # CLK_PERIOD;

        // First test case
        start <= 1;
        # CLK_PERIOD;

        plaintext <= 128'h328831E0435A3137F6309807A88DA234;
        key <= 128'h2B28AB097EAEF7CF15D2154F16A6883C;
        start <= 0;
        # CLK_PERIOD;

        plaintext <= 128'b0;
        key <= 128'b0;

        // Wait for done signal
        wait (done == 1'b1);

        // Check ciphertext for the first test case
        if (ciphertext == 128'h3902DC1925DC116A8409850B1DFB9732) begin
            $display("---------- Passed ----------");
        end else begin
            $display("---------- Failed ----------");
        end

        // Wait for a longer time before starting the next case
        # (CLK_PERIOD * 20.5);

        // Second test case
        start <= 1;
        plaintext <= 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        key <= 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        # CLK_PERIOD;

        plaintext <= 128'b0;
        key <= 128'b0;
        start <= 0;
        # CLK_PERIOD;

        plaintext <= 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        key <= 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

        // Wait for done signal
        wait (done == 1'b1);

        // Check ciphertext for the second test case
        if (ciphertext == 128'h66ef88cae98a4c344b2cfa2bd43b592e) begin
            $display("---------- Passed ----------");
        end else begin
            $display("---------- Failed ----------");
        end

        // End of test
        $finish;
    end

endmodule
