# 8-bit-PWM-Controller
A configurable Pulse Width Modulation (PWM) controller implemented in Verilog, featuring 8-bit resolution and glitch-free operation.

## 🚀 Features

- **8-bit resolution** (256 duty cycle steps)
- **Glitch-free operation** with synchronous duty cycle updates
- **Configurable parameters** for easy customization
- **Enable/disable control** for power management
- **Fully synchronous design** with clean reset

## 📁 Project Structure
pwm-controller-verilog/
├── src/ # Source Verilog files
├── testbench/ # Testbench files


## ⚡ Quick Start

### Simulation with Vivado

1. **Add source files** to your Vivado project:
   - `src/pwm_controller.v`
   - `testbench/pwm_controller_tb.v`

2. **Set tb_pwm_controller.v as top module** for simulation

3. **Run simulation** using the "Run All" command in Vivado

   > 💡 **Tip**: Use the "Run All" command in Vivado to automatically compile and run the simulation with proper settings.

4. **View waveforms** to verify PWM operation

### Key Parameters

- **Clock Frequency**: 50 MHz (default)
- **PWM Frequency**: ~195.3 kHz (with 8-bit resolution)
- **Duty Cycle Resolution**: 8-bit (0-255, 0.4% steps)

## 🧪 Testbenches

- `pwm_controller_tb.v` - Basic functionality tests

## 📊 Specifications

| Parameter | Value | Description |
|-----------|-------|-------------|
| Resolution | 8-bit | 256 duty cycle steps |
| Max Duty | 255/256 | ~99.6% |
| Frequency | ~195 kHz | With 50MHz clock |
| Interface | Synchronous | All signals clocked |

## 🔧 Usage Example

```verilog
pwm_controller pwm_inst (
    .clk(clk_50mhz),      // 50 MHz clock
    .reset(rst),          // Active-high reset
    .duty(8
