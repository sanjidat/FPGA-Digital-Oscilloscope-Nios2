import subprocess 
import re
import matplotlib.pyplot as plt

samples = []

terminal_path = r"C:\intelFPGA_lite\16.1\quartus\bin64\nios2-terminal.exe"

process = subprocess.Popen(
    [terminal_path],
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
    text=True
)

plt.ion()

fig, ax = plt.subplots()
line_plot, = ax.plot([], [], marker='o')

ax.set_xlabel("Sample Index")
ax.set_ylabel("12-bit ADC Value")
ax.set_title("FPGA Digital Oscilloscope - Live Waveform")

ax.set_xlim(0, 31)
ax.set_ylim(0, 4095)
ax.grid(True)

for line in process.stdout:
    print(line, end="")

    if line.startswith("Sample"):
        parts = line.split("=")
        value = int(parts[1].strip())
        samples.append(value)

    if line.strip() == "END":
        
        if len(samples) == 32:
            line_plot.set_data(range(32), samples)

            fig.canvas.draw()
            fig.canvas.flush_events()

        samples.clear()
            