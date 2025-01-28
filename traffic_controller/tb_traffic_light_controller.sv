`timescale 1ns/1ns

module tb_traffic_light_controller;

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
        rst_n <= 0;
        pedestrian_request <= 0;
        emergency <= 0;

        // Dump the waveform to a VCD file
        $dumpfile("traffic_light_controller_tb.vcd");
        $dumpvars(0, tb_traffic_light_controller);

        // Apply reset
        #15 rst_n <= 1;
        $display("Test: Reset Applied");

        // Test 1: Normal Operation - Traffic Green
        #10 pedestrian_request <= 1;
        $display("Test 1: Pedestrian Request");
        #10 pedestrian_request <= 0;
        check_state(traffic_red, traffic_yellow, traffic_green, pedestrian_walk, pedestrian_dont_walk, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1);

        // Test 2: Emergency Signal
        emergency <= 1;
        #10 emergency <= 0;
        $display("Test 2: Emergency Signal");
        check_state(traffic_red, traffic_yellow, traffic_green, pedestrian_walk, pedestrian_dont_walk, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1);

        // Test 3: Pedestrian Request during Emergency
        emergency <= 1;
        pedestrian_request <= 1;
        #10 pedestrian_request <= 0;
        emergency <= 0;
        $display("Test 3: Pedestrian Request during Emergency");
        check_state(traffic_red, traffic_yellow, traffic_green, pedestrian_walk, pedestrian_dont_walk, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1);

        // Test 4: Normal Cycle (No Requests)
        #20;
        $display("Test 4: Normal Cycle, No Requests");
        check_state(traffic_red, traffic_yellow, traffic_green, pedestrian_walk, pedestrian_dont_walk, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1);

        // Finish the simulation
        #50;
        $stop;
    end

    // Monitor the outputs for expected behavior
    initial begin
        $monitor("At time %t, traffic_red = %b, traffic_yellow = %b, traffic_green = %b, pedestrian_walk = %b, pedestrian_dont_walk = %b", 
                 $time, traffic_red, traffic_yellow, traffic_green, pedestrian_walk, pedestrian_dont_walk);
    end

    // Function to check if the state matches expected values
    task check_state(
        input logic traffic_red,
        input logic traffic_yellow,
        input logic traffic_green,
        input logic pedestrian_walk,
        input logic pedestrian_dont_walk,
        input logic expected_traffic_red,
        input logic expected_traffic_yellow,
        input logic expected_traffic_green,
        input logic expected_pedestrian_walk,
        input logic expected_pedestrian_dont_walk
    );
        begin
            // Check if the current state matches the expected state
            if (traffic_red == expected_traffic_red &&
                traffic_yellow == expected_traffic_yellow &&
                traffic_green == expected_traffic_green &&
                pedestrian_walk == expected_pedestrian_walk &&
                pedestrian_dont_walk == expected_pedestrian_dont_walk) begin
                $display("Test Passed at time %t", $time);
            end else begin
                $display("Test Failed at time %t", $time);
                $display("Expected: traffic_red=%b, traffic_yellow=%b, traffic_green=%b, pedestrian_walk=%b, pedestrian_dont_walk=%b", 
                         expected_traffic_red, expected_traffic_yellow, expected_traffic_green, expected_pedestrian_walk, expected_pedestrian_dont_walk);
                $display("Actual: traffic_red=%b, traffic_yellow=%b, traffic_green=%b, pedestrian_walk=%b, pedestrian_dont_walk=%b", 
                         traffic_red, traffic_yellow, traffic_green, pedestrian_walk, pedestrian_dont_walk);
            end
        end
    endtask

endmodule