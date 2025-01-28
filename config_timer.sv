module config_timer #(
    parameter CLOCK_TIME = 30
)
(
input logic clk, rst_n, input_trigger, emergency,
output logic signal_change
);
logic [$clog2(CLOCK_TIME):0] counter;
logic input_trigger_pulse, inp_trig_reg;

always_ff@(posedge clk) begin
    if(~rst_n)
        inp_trig_reg <= 1'b0;
    else 
        inp_trig_reg <= input_trigger;
end

assign input_trigger_pulse = input_trigger & ~inp_trig_reg;



always_ff @(posedge clk) begin
    if(~rst_n) begin
        counter <= '0;
    end
    else if (counter == CLOCK_TIME-1 | emergency) begin
        counter <= '0;
    end
    else begin
        counter <= (input_trigger_pulse || (counter > 0)) ? (counter + 1) : counter;
    end
end

assign signal_change = counter == (CLOCK_TIME-1);
endmodule