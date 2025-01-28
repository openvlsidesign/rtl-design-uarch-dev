`timescale 1ns/1ns

module tb_traffic_light_controller_random;

    // Inputs
    logic clk;
    logic rst_n;
    logic pedestrian_request;
    logic emergency;

    // Outputs
    logic traffic_red;
    logic traffic_yellow;
    logic traffic_green;
    logic pedestrian_walk;
    logic pedestrian_dont_walk;

    // Instantiate the Unit Under Test (UUT)
    traffic_controller_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .pedestrian_request(pedestrian_request),
        .emergency(emergency),
        .traffic_red(traffic_red),
        .traffic_yellow(traffic_yellow),
        .traffic_green(traffic_green),
        .pedestrian_walk(pedestrian_walk),
        .pedestrian_dont_walk(pedestrian_dont_walk)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // 10ns clock period
    end

    // Initial block
    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 0;
        pedestrian_request = 0;
        emergency = 0;

        // Dump the waveform to a VCD file
        $dumpfile("traffic_light_controller_random_tb.vcd");
        $dumpvars(0, tb_traffic_light_controller_random);

        // Apply reset
        #10 rst_n = 1;
        $display("Test: Reset Applied");

        // Randomized test sequence
        repeat (10) begin
            // Randomize pedestrian request and emergency signals
            pedestrian_request = $random % 2;
            emergency = $random % 2;

            // Apply the randomized values
            #20;

            // Check if scenario passed or failed
            check_scenario();
        end

        // Finish the simulation
        $stop;
    end

    // Check the scenario based on expected outcomes
    task check_scenario;
        begin
            if (emergency) begin
                // Emergency should force all lights to red
                if (traffic_red !== 1 || traffic_yellow !== 0 || traffic_green !== 0 || pedestrian_walk !== 0 || pedestrian_dont_walk !== 1) begin
                    $display("Emergency Scenario Failed");
                end else begin
                    $display("Emergency Scenario Passed");
                end
            end else if (pedestrian_request) begin
                // Check if pedestrian walk is active when request is high
                if (pedestrian_walk !== 1) begin
                    $display("Pedestrian Request Scenario Failed");
                end else begin
                    $display("Pedestrian Request Scenario Passed");
                end
            end else begin
                // Normal operation when neither pedestrian nor emergency request is active
                if (traffic_green !== 1 || pedestrian_dont_walk !== 1) begin
                    $display("Normal Operation Scenario Failed");
                end else begin
                    $display("Normal Operation Scenario Passed");
                end
            end
        end
    endtask

    // Monitor the outputs for expected behavior
    initial begin
        $monitor("At time %t, traffic_red = %b, traffic_yellow = %b, traffic_green = %b, pedestrian_walk = %b, pedestrian_dont_walk = %b", 
                 $time, traffic_red, traffic_yellow, traffic_green, pedestrian_walk, pedestrian_dont_walk);
    end

endmodule