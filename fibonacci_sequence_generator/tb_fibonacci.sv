module tb_fibonacci ();

  logic clk;
  logic reset;
  logic [31:0] seq_o;

  // Instantiate the Fibonacci module
  fibonacci uut (
    .clk(clk),
    .reset(reset),
    .seq_o(seq_o)
  );
  
  initial begin
    $dumpfile("fibonacci.vcd"); // Specify the VCD file for waveform output
    $dumpvars(0, tb_fibonacci); // Dump all variables in the testbench
  end


  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // Toggle clock every 5 time units
  end

  // Testbench stimulus
  initial begin
    reset = 1; // Assert reset
    #15;
    reset = 0; // Deassert reset

    // Wait for a few clock cycles to observe the output
    #600;

    $finish; // End simulation
  end

  endmodule