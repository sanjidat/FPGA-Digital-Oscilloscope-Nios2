# FPGA-Digital-Oscilloscope-Nios2
FPGA-based digital oscilloscope with triggered sample capture, on-chip memory, Nios II control, and Python waveform visualization.

# FPGA Digital Oscilloscope with Nios II

An FPGA-based digital oscilloscope/data acquisition system implemented on the **Terasic DE10-Lite** board.

The project combines **VHDL, Nios II Embedded C, Avalon-MM, JTAG UART, and Python** to implement a complete acquisition path from waveform capture on the FPGA to visualization on a PC.

The current implementation uses an internally generated **12-bit sine wave** to test the digital acquisition chain.

## System Overview

```text
Sample Generator
      ↓
Trigger Logic
      ↓
Capture Controller
      ↓
Sample Memory
      ↓
Avalon-MM
      ↓
Nios II
      ↓
JTAG UART
      ↓
Python / Matplotlib
```

The trigger logic detects a rising threshold crossing and starts the capture process. The capture controller then stores **32 samples** in memory.

After the capture is complete, the Nios II processor reads the samples through the custom Avalon-MM interface and transfers them to the PC through JTAG UART. A Python application reads the data and displays the captured waveform.

## FPGA Design

The FPGA side is implemented in VHDL and contains four main blocks:

- **Sample Generator** – generates a 12-bit sine wave using a 32-entry lookup table.
- **Trigger Logic** – detects a rising crossing of the configured trigger level.
- **Capture Controller** – FSM-based controller with `IDLE`, `WAIT_TRIGGER`, `CAPTURE`, and `DONE` states.
- **Sample Memory** – stores 32 captured 12-bit samples.

---

## Repository Structure

```text
FPGA-Digital-Oscilloscope-Nios2/
│
├── rtl/
│   ├── sample_generator/
│   ├── trigger_logic/
│   ├── capture_controller/
│   ├── sample_memory/
│   ├── oscilloscope_core/
│   ├── avalon_mm_interface/
│   └── system_integration/
│
├── simulation/
│   ├── oscilloscope_top_tb.vhd
│   └── results/
│       └── oscilloscope_top_test_results.txt
│
├── platform_designer/
│   └── nio_oscilloscope.qsys
│
├── software/
│   └── oscilloscope_app.c
│
├── python_visualization/
│   └── plot_waveform.py
│
├── images/
│   └── results/
│       ├── nios2_console_output.png
│       └── captured_waveform.png
│
└── README.md
```

---


## Nios II and Avalon-MM

A custom Avalon-MM interface connects the acquisition logic to the Nios II processor.

| Register | Function |
|----------|----------|
| 0 | Capture control |
| 1 | Trigger level |
| 2 | Capture status |
| 3 | Sample read address |
| 4 | Sample data |

The Nios II application configures the trigger level, starts the capture, waits for completion, and reads the stored samples using memory-mapped I/O.

The processor system is configured using **Intel Platform Designer**.

## Python Visualization

Captured samples are transferred from the Nios II processor through **JTAG UART**.

A Python script reads the output using `nios2-terminal` and plots the received samples with **Matplotlib**.

The complete data path is:

```text
FPGA → Avalon-MM → Nios II → JTAG UART → Python
```

## Results

### Nios II Capture

The Nios II application successfully reads the captured samples from FPGA memory.

![Nios II Console Output](images/results/nios2_console_output.png)

### Captured Waveform

The received samples are plotted on the PC using Python.

![Captured Waveform](images/results/captured_waveform.png)

## Simulation and Verification

The integrated FPGA design was tested using a VHDL top-level testbench in **ModelSim Intel FPGA Edition**.

The final simulation result:

```text
PASS = 32
FAIL = 0
OSCILLOSCOPE TEST PASSED
```

The simulation log is included under `simulation/results/`.

## Tools and Technologies

- **FPGA:** Intel MAX 10 / Terasic DE10-Lite
- **RTL:** VHDL
- **FPGA Tools:** Quartus Prime Lite, ModelSim
- **Processor:** Nios II
- **System Integration:** Intel Platform Designer
- **Interface:** Avalon-MM
- **Embedded Software:** C
- **Communication:** JTAG UART
- **Visualization:** Python / Matplotlib

## Repository Structure

```text
├── rtl/                   # VHDL source files
├── simulation/            # Testbench and simulation results
├── platform_designer/     # Nios II Qsys system
├── software/              # Nios II C application
├── python_visualization/  # Python plotting application
├── images/                # Hardware and waveform results
└── README.md
```

## Future Development

The current version uses an internally generated sine wave to validate the digital acquisition path. Future development could replace the sample generator with an **external ADC interface** and add features such as configurable sampling rate, larger capture memory, and pre-trigger sampling.
