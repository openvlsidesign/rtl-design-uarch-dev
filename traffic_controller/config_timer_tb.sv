`timescale 1ns/1ns
`include "config_timer.sv"
module config_timer_tb;
reg clk, rst_n;
wire signal_change;
parameter CLK_PERIOD = 10;

config_timer config_timer_inst(.*);

//clock generation
always #((CLK_PERIOD/2))
clk = ~clk;

initial begin
    $dumpfile("config_timer_wf.vcd");
    $dumpvars(0, config_timer_tb);
    clk <= 1;
    rst_n <= 1'b1;
    #10;
    rst_n <= 1'b0; #10;
    rst_n <= 1'b1; #10;
    #270;
    rst_n <= 1'b0;
    #280;
    rst_n <= 1'b1;
    #1200;
    rst_n <= 1'b0;
    #1210;
    rst_n <= 1'b1;
    #2000;
    $finish;     
end
endmodule

