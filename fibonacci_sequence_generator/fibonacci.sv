module fibonacci (
  input   logic        clk,
  input   logic        reset,

  output  logic [31:0] seq_o
);

  // Write your logic here...
  logic [31:0]  d1_in, d0_in;
  logic [31:0]  d1_out, d0_out;

assign d1_in = d1_out + d0_out;
assign d0_in = d1_out;

  always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
      seq_o  <= '0;
      d0_out <= 32'd0;
      d1_out <= 32'd1;
    end
    else begin
      d0_out <= d0_in;
      d1_out <= d1_in;
      seq_o  <= d0_out;
    end
    
  end
  
endmodule