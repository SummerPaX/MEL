# MEL Counter Project - Implementation Guide

## Project Overview

This document provides a complete implementation of the MEL Counter Project for the Digilent Basys3 FPGA development board. The design implements a 4-digit octal counter with 1 Hz counting frequency as specified by matriculation numbers 52303789 and 52303796.

## Individual Specifications

- **Students**: Summer Paulus, Matthias Brinskelle
- **Matriculation Numbers**: 52303789, 52303796
- **Lowest Last Two Digits**: 89
- **Counter Mode**: Octal (digits 0-7)
- **Counting Frequency**: 1 Hz for the least significant digit
- **End Value**: 7777 (wraparound)

## Design Architecture

```
cntr_top (Top-level)
├── io_ctrl (I/O Control Unit)
│   ├── Switch debouncing (1 kHz sampling)
│   ├── 7-segment display multiplexer (1 kHz refresh)
│   └── LED control
└── cntr (Counter Unit)
    ├── Clock divider (100 MHz → 1 Hz)
    ├── 4-digit octal counter
    └── Priority control logic
```

## File Structure

```
counter_project/
├── vhdl/               # Design files
│   ├── io_ctrl_.vhd           # IO control entity
│   ├── io_ctrl_rtl.vhd        # IO control implementation
│   ├── io_ctrl_rtl_cfg.vhd    # IO control configuration
│   ├── cntr_.vhd              # Counter entity
│   ├── cntr_rtl.vhd           # Counter implementation
│   ├── cntr_rtl_cfg.vhd       # Counter configuration
│   ├── cntr_top_.vhd          # Top-level entity
│   ├── cntr_top_struc.vhd     # Top-level structure
│   └── cntr_top_struc_cfg.vhd # Top-level configuration
├── tb/                 # Testbenches
│   ├── tb_io_ctrl_.vhd        # IO control testbench entity
│   ├── tb_io_ctrl_sim.vhd     # IO control testbench implementation
│   ├── tb_io_ctrl_sim_cfg.vhd # IO control testbench configuration
│   ├── tb_cntr_.vhd           # Counter testbench entity
│   ├── tb_cntr_sim.vhd        # Counter testbench implementation
│   ├── tb_cntr_sim_cfg.vhd    # Counter testbench configuration
│   ├── tb_cntr_top_.vhd       # Top-level testbench entity
│   ├── tb_cntr_top_sim.vhd    # Top-level testbench implementation
│   └── tb_cntr_top_sim_cfg.vhd# Top-level testbench configuration
├── msim/               # ModelSim scripts
│   ├── compile.do             # Compilation script
│   ├── sim.do                 # Master simulation script
│   ├── sim_io_ctrl.do         # IO control simulation
│   ├── sim_cntr.do            # Counter simulation
│   └── sim_cntr_top.do        # Top-level simulation
└── impl/               # Vivado project
    └── cntr_top_basys3.xdc    # Constraints file
```

## Key Design Features

### IO Control Unit

- **Debouncing**: 1 kHz sampling for reliable switch/button operation
- **7-segment multiplexing**: 1 kHz refresh rate for flicker-free display
- **Octal decoder**: ROM-based segment patterns for digits 0-7
- **LED indicators**: Show active switch states

### Counter Unit

- **Frequency division**: 100 MHz system clock divided to 1 Hz counting
- **Octal counting**: 4 digits, each 3-bit wide (0-7)
- **Wraparound**: 7777 → 0000 (up), 0000 → 7777 (down)
- **Priority control**: Clear > Up/Down > Hold

### Control Logic Truth Table

| Clear | Run/Stop | Up  | Down | Function      |
| :---: | :------: | :-: | :--: | :------------ |
|   1   |    X     |  X  |  X   | Clear to 0000 |
|   0   |    1     |  1  |  X   | Count Up      |
|   0   |    1     |  0  |  1   | Count Down    |
|   0   |  others  |     |      | Hold Value    |

## Switch Assignments

- **SW(0)**: Clear
- **SW(1)**: Down
- **SW(2)**: Up
- **SW(3)**: Run/Stop

## Usage Instructions

### ModelSim Simulation

1. Navigate to `msim/` directory
2. Run compilation: `do compile.do`
3. Run specific simulation:
   - `do sim_io_ctrl.do` - IO control unit
   - `do sim_cntr.do` - Counter unit
   - `do sim_cntr_top.do` - Complete system

### Vivado Implementation

1. Create new Vivado project
2. Set target device: xc7a35tcpg236-1 (Basys3)
3. Add design files from `vhdl/` (exclude testbenches)
4. Add constraints file: `impl/cntr_top_basys3.xdc`
5. Set top-level: `cntr_top`
6. Run synthesis and implementation
7. Generate bitstream and program FPGA

## Expected Operation

1. **Power-up**: Counter starts at 0000
2. **Clear (SW0)**: Immediately resets to 0000
3. **Count Up (SW3+SW2)**: Increments every 1 second: 0000→0001→...→7777→0000
4. **Count Down (SW3+SW1)**: Decrements every 1 second: 0000→7777→...→0001→0000
5. **Hold (SW3=0)**: Maintains current value
6. **LED indicators**: Lower 4 LEDs show active switches

## Testing Strategy

### Unit Testing

- **IO Control**: Debouncing, display multiplexing, LED control
- **Counter**: Counting logic, priority control, wraparound
- **Integration**: Complete system functionality

### Verification Points

- Switch debouncing effectiveness
- 7-segment display correctness for all octal digits
- Counter timing (1 Hz frequency)
- Priority control implementation
- Wraparound behavior at boundaries
- Reset functionality

## Design Considerations

### Timing

- **System clock**: 100 MHz (10 ns period)
- **Debounce rate**: 1 kHz (1 ms period)
- **Display refresh**: 1 kHz (1 ms period)
- **Count rate**: 1 Hz (1 second period)

### Resource Usage

- **Logic cells**: Minimal (simple combinatorial and sequential logic)
- **Memory**: ROM for 7-segment decoder patterns
- **I/O**: 4 switches, 4 LEDs, 8+4 7-segment pins

### Power Consumption

- Low power design using clock gating where possible
- Efficient multiplexing reduces active display elements

## Troubleshooting

### Common Issues

1. **Counter not counting**: Check switch connections and debouncing
2. **Display flickering**: Verify 1 kHz refresh rate
3. **Wrong segments**: Check 7-segment decoder ROM
4. **No response**: Verify clock and reset signals

### Debug Signals

- Monitor `clk_1khz` for refresh timing
- Monitor `count_enable` for counting timing
- Check `swsync_o` for debounced switch states

## Compliance

This implementation fully complies with the MEL Counter Project specification:

- ✅ Octal counter mode (digits 0-7)
- ✅ 1 Hz counting frequency
- ✅ 4-digit display with 7-segment output
- ✅ Priority control scheme
- ✅ Wraparound behavior (7777↔0000)
- ✅ Switch debouncing
- ✅ Proper VHDL coding style
- ✅ Comprehensive testbenches
- ✅ Basys3 FPGA compatibility

## Authors

- Summer Paulus (52303789)
- Matthias Brinskelle (52303796)
- Date: June 18, 2025
- Course: Microelectronics Laboratory (MEL)
- Institution: FH Technikum Wien
