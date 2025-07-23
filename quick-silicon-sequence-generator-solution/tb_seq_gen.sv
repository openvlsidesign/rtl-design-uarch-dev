module tb_seq_gen ();

  logic clk;
  logic reset;
  logic [31:0] seq_o;

  // Instantiate the Fibonacci module
  seq_generator uut (
    .clk(clk),
    .reset(reset),
    .seq_o(seq_o)
  );
  
  initial begin
    $dumpfile("qs_seq_gen.vcd"); // Specify the VCD file for waveform output
    $dumpvars(0, tb_seq_gen); // Dump all variables in the testbench
  end


  // Clock generation
  initial begin
    clk = 1;
    forever #5 clk = ~clk; // Toggle clock every 5 time units
  end

  // Testbench stimulus
  initial begin
    reset = 0; // Assert reset
    #20;
    reset = 1;
    #10;
    reset = 0; // Deassert reset

    // Wait for a few clock cycles to observe the output
    #600;

    $finish; // End simulation
  end

  endmodule