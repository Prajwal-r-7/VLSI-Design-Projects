# 📦 Synchronous FIFO Design

## 📋 Project Overview

This project implements a **Synchronous FIFO (First-In-First-Out)** buffer using Verilog HDL. The FIFO provides reliable data storage and retrieval with configurable depth and data width, featuring proper full/empty flag generation for safe read/write operations.

## 🛠️ Tools Used
- **Xilinx Vivado** - Synthesis and implementation
- **Verilog HDL** - Hardware description language

## 🏗️ FIFO Architecture

### Core Components:

#### **FIFO Memory**
```verilog
reg [DATA_WIDTH-1 : 0] fifo_mem [DEPTH-1 : 0];
```
- Configurable memory array for data storage
- Parameterized data width and depth

#### **Write Operation**
```verilog
fifo_mem[w_ptr[PTR_WIDTH-1:0]] <= w_data;
```
- Data written to location pointed by write pointer
- Increment write pointer after successful write

#### **Read Operation**
```verilog
r_data <= fifo_mem[r_ptr[PTR_WIDTH-1:0]];
```
- Data read from location pointed by read pointer  
- Increment read pointer after successful read

#### **Status Flags**
```verilog
assign empty = (w_ptr == r_ptr);
assign full = ({~w_ptr[PTR_WIDTH], w_ptr[PTR_WIDTH-1:0]} == r_ptr);
```
- **Empty**: Generated when read and write pointers are equal
- **Full**: Generated using Gray code logic to prevent overflow

## ✨ Key Features

- **Synchronous Operation**: Single clock domain for read/write operations
- **Parameterizable Design**: Configurable data width and FIFO depth
- **Safe Flag Generation**: Reliable full/empty detection
- **Gray Code Pointers**: Prevents metastability issues
- **Flow Control**: Built-in overflow and underflow protection

## 📁 Repository Contents

- `block_diagram.png` - FIFO block diagram and architecture
- `synchronous.v` - Main FIFO module implementation
- `tb_synchronous.v` - Testbench for verification
- `waveform.png` - Simulation waveforms showing FIFO operation
- `README.md` - Project documentation (this file)

## 🚀 How to Use

1. **Open Project**: Load files in Xilinx Vivado
2. **Configure Parameters**: Set DATA_WIDTH and DEPTH as required
3. **Run Simulation**: Execute testbench to verify functionality
4. **Synthesize**: Generate hardware implementation

## 🔍 Design Parameters

- `DATA_WIDTH` - Width of data bus (default: configurable)
- `DEPTH` - FIFO memory depth  
- `PTR_WIDTH` - Pointer width (log2(DEPTH) + 1)

## 📈 Verification

The testbench demonstrates:
- **Write Operations**: Data storage at different rates
- **Read Operations**: Data retrieval and verification
- **Flag Testing**: Full and empty condition validation
- **Corner Cases**: Overflow and underflow scenarios


---

<p align="center">
  <i>Part of CoachED VLSI Training Projects | Designed by Prajwal</i>
</p>