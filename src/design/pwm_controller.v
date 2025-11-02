`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arkopaul Nandi
// 
// Create Date: 31.10.2025 03:59:14
// Design Name: PWM CONTROLLER
// Module Name: pwm_controller
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


module pwm_controller(
    input wire clk, rst, enable,
    input wire [7:0] duty,
    output reg pwm_out
    );
    
    // Parameters
    parameter count_width = 8;
    parameter max_count = (1 << count_width) - 1;
    
    // Internal Signals
    reg [count_width - 1: 0] counter, duty_reg;
    
    // Counter Logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= {count_width{1'b0}};     // Reset logic
        end else if (enable) begin              // Enable logic
            if (counter == max_count) begin
                counter <= {count_width{1'b0}}; // Wrap around logic
            end else begin
                counter <= counter + 1;         // Increment
            end
        end
    end
    
    // Duty cycle Register
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            duty_reg <= {count_width{1'b0}};
        end else if (enable && (counter == (max_count - 1))) begin
             duty_reg <= duty;
        end
    end
    
    // PWM output generation logic
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            pwm_out <= 1'b0;
        end else if (enable) begin
            if (counter <= duty_reg) begin
                pwm_out <= 1'b1;
            end else begin
                pwm_out <= 1'b0;
            end
        end else begin
            pwm_out <= 1'b0;
        end
    end
    
endmodule
