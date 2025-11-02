`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.10.2025 04:31:41
// Design Name: 
// Module Name: pwm_controller_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module pwm_controller_tb;

    // Testbench signals
    reg clk;
    reg rst;
    reg enable;
    reg [7:0] duty;
    wire pwm_out;
    
    // Instantiate the PWM controller
    pwm_controller uut (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .duty(duty),
        .pwm_out(pwm_out)
    );
    
    // Clock generation (10ns period = 100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Variables for measurement
    integer high_count;
    integer total_count;
    real measured_duty;
    
    // Task to measure duty cycle over one complete PWM period (256 cycles)
    task measure_duty_cycle;
        input [7:0] expected_duty;
        begin
            high_count = 0;
            total_count = 0;
            
            // Wait for counter to wrap (start of new period)
            @(posedge clk);
            
            // Count HIGH cycles over one complete period (256 clock cycles)
            repeat(256) begin
                @(posedge clk);
                if (pwm_out) high_count = high_count + 1;
                total_count = total_count + 1;
            end
            
            measured_duty = (high_count * 100.0) / total_count;
            
            $display("Expected Duty: %0d/256 (%0.2f%%), Measured: %0d/256 (%0.2f%%)", 
                     expected_duty, (expected_duty * 100.0) / 256, 
                     high_count, measured_duty);
            
            // Check if measurement matches expected (with tolerance)
            if (high_count == expected_duty) begin
                $display("PASS: Duty cycle matches expected value\n");
            end else begin
                $display("FAIL: Expected %0d HIGH cycles, got %0d\n", expected_duty, high_count);
            end
        end
    endtask
    
    // Main test sequence
    initial begin
        // Initialize signals
        rst = 1;
        enable = 0;
        duty = 0;
        
        $display("=== PWM Controller Testbench ===\n");
        
        // Apply reset for a few clock cycles
        repeat(5) @(posedge clk);
        rst = 0;
        $display("Reset released at %0t\n", $time);
        
        // Enable the PWM controller
        repeat(2) @(posedge clk);
        enable = 1;
        $display("PWM Controller enabled at %0t\n", $time);
        
        // Test 1: 0% Duty Cycle
        $display("--- Test 1: 0%% Duty Cycle ---");
        duty = 8'd0;
        repeat(2) @(posedge clk);
        measure_duty_cycle(8'd0);
        
        // Test 2: 25% Duty Cycle (64/256)
        $display("--- Test 2: 25%% Duty Cycle ---");
        duty = 8'd64;
        // Wait for duty register to update (happens at counter = max_count)
        repeat(260) @(posedge clk);
        measure_duty_cycle(8'd64);
        
        // Test 3: 50% Duty Cycle (128/256)
        $display("--- Test 3: 50%% Duty Cycle ---");
        duty = 8'd128;
        repeat(260) @(posedge clk);
        measure_duty_cycle(8'd128);
        
        // Test 4: 100% Duty Cycle (255/256)
        $display("--- Test 4: ~100%% Duty Cycle (255/256) ---");
        duty = 8'd255;
        repeat(260) @(posedge clk);
        measure_duty_cycle(8'd255);
        
        // Test 5: Disable functionality
        $display("--- Test 5: Disable Test ---");
        repeat(10) @(posedge clk);
        enable = 0;
        repeat(10) @(posedge clk);
        if (pwm_out == 0) begin
            $display("PASS: PWM output is LOW when disabled\n");
        end else begin
            $display("FAIL: PWM output should be LOW when disabled\n");
        end
        
        // Test 6: Re-enable
        $display("--- Test 6: Re-enable Test ---");
        enable = 1;
        duty = 8'd128;
        repeat(260) @(posedge clk);
        measure_duty_cycle(8'd128);
        
        $display("=== Testbench Complete ===");
        $finish;
    end
    
    // Timeout watchdog (prevent infinite simulation)
    initial begin
        #1000000; // 1ms timeout
        $display("ERROR: Simulation timeout!");
        $finish;
    end

endmodule