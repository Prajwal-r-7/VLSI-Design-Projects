# ⚡ SKITTER: Timing Uncertainty Measurement Circuit

<p align="center">
  <img src="https://img.shields.io/badge/Xilinx_Vivado-E01F27?style=for-the-badge&logo=xilinx&logoColor=white" alt="Vivado"/>
  <img src="https://img.shields.io/badge/NGSpice-FF7F00?style=for-the-badge&logo=spice&logoColor=white" alt="NGSpice"/>
  <img src="https://img.shields.io/badge/Verilog-2E8BC0?style=for-the-badge&logo=v&logoColor=white" alt="Verilog"/>
</p>

## 🎯 Overview

**SKITTER** (Skew + Jitter) is a specialized measurement circuit designed to quantify timing uncertainty in digital systems. It measures how many logic stages a signal can traverse in a single clock cycle, providing insights into power supply noise and propagation delay variations.

## 🚀 Key Features

- **Buffer-based Delay Line** - Uses inverter pairs instead of single inverters for enhanced noise sensitivity
- **Real-time Sampling** - Flip-flops capture signal propagation at each stage
- **Smart Encoding** - Converts flip-flop patterns (e.g., `111111100000`) to binary stage count
- **Statistical Analysis** - Histogram module tracks frequency distribution for noise characterization

## 🏗️ Circuit Architecture

```
Input Signal → [Buffer Chain] → [Sampling FFs] → [Encoder] → [Histogram] → Output
                     ↓              ↓              ↓           ↓
                 Delay Line    State Capture   Binary Code  Statistics
```

### Core Modules

| Module | Function |
|--------|----------|
| **Delay Line** | Chain of buffer stages sensitive to supply voltage variations |
| **Sampling FFs** | Simultaneously clocked flip-flops capturing signal edge position |
| **Encoder** | Converts FF pattern to binary-encoded stage count |
| **Histogram** | Statistical analysis of delay measurements across multiple cycles |

## 🔬 Methodology

1. **Analog Characterization** (NGSpice)
   - Measure buffer delay vs. supply voltage relationship
   - Extract delay parameters for different operating conditions

2. **Digital Implementation** (Vivado)
   - Apply measured delays as transport delays in Verilog
   - Implement complete SKITTER architecture
   - Verify functionality through simulation

## 🛠️ Tools Used

- **Xilinx Vivado** - Digital design and functional verification
- **NGSpice** - Analog simulation for delay characterization
- **Verilog HDL** - Circuit description and testbench development

## 📊 Applications

- **Power Supply Noise Analysis** - Quantify voltage fluctuation impact on timing
- **PLL Jitter Measurement** - Characterize clock generation stability  
- **Process Variation Study** - Analyze manufacturing tolerance effects
- **System Reliability Assessment** - Ensure timing margin adequacy

## 🎯 Project Outcomes

✅ Successfully designed and verified SKITTER circuit functionality  
✅ Characterized buffer delay-voltage relationship using NGSpice  
✅ Implemented statistical analysis for noise quantification  
✅ Validated design through comprehensive simulation testing  

## 📁 Repository Structure

```
📦 SKITTER-Circuit/
├── 📁 ngspice-simulations/     # Analog delay characterization
├── 📁 verilog-modules/         # Digital circuit implementation  
├── 📁 testbenches/            # Verification and validation
├── 📁 results/                # Simulation outputs and analysis
└── 📄 README.md              # This file
```

## 🔍 Key Insights

- Buffer-based approach provides better noise sensitivity than single inverters
- Histogram analysis enables statistical characterization of timing variations
- Combined analog-digital methodology ensures accurate delay modeling

---

<p align="center">
  <i>Developed by Prajwal | CoachED VLSI Training Program</i>
</p>