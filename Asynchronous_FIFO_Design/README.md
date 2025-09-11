# 🔄 Asynchronous FIFO Design

## 📋 Project Overview

This project implements an **Asynchronous FIFO (First-In-First-Out)** buffer using Verilog HDL. The FIFO operates across different clock domains with independent read and write clocks, featuring Gray code pointers and proper clock domain crossing techniques for reliable data transfer.


## 🛠️ Tools Used
- **Xilinx Vivado** - Synthesis and implementation
- **Verilog HDL** - Hardware description language

## 🏗️ Asynchronous FIFO Architecture

### Core Components:

#### **FIFO Memory**
```verilog
reg [DATA_WIDTH-1:0] fifo_mem [DEPTH-1:0];
```
- Dual-port memory array for data storage
- Accessed by independent read/write clock domains

#### **Write Operation**
```verilog
fifo_mem[w_ptr[PTR_WIDTH-1:0]] <= w_data;
```
- Data written using write clock domain
- Write pointer increments in Gray code

#### **Read Operation**
```verilog
r_data <= fifo_mem[r_ptr[PTR_WIDTH-1:0]];
```
- Data read using read clock domain
- Read pointer increments in Gray code

---

## 🔗 Clock Domain Crossing Techniques

### **Gray Code Implementation**
- **Purpose**: Prevents metastability during pointer comparison across clock domains
- **Advantage**: Only one bit changes at a time during pointer increment
- **Usage**: Both read and write pointers operate in Gray code format

### **Additional Pointer Bits**
- **Extra MSB Bit**: Added to distinguish between full and empty conditions
- **Pointer Width**: `PTR_WIDTH = log2(DEPTH) + 1`
- **Wrap-Around Detection**: MSB helps identify pointer wrap-around scenarios

### **Two-Flop Synchronizers**
- **Write to Read Domain**: Write pointer synchronized to read clock
- **Read to Write Domain**: Read pointer synchronized to write clock
- **Metastability Protection**: Two flip-flop stages prevent timing violations
  
---

## 🏁 Status Flag Generation

#### **Full Flag Logic**
```verilog
assign full = ({~w_ptr[PTR_WIDTH], w_ptr[PTR_WIDTH-1:0]} == r_gray2bin);
```
- **Comparison**: Normal binary write pointer vs converted Gray-to-Binary read pointer
- **Synchronization**: Read pointer passed through two-flop synchronizer
- **Detection**: Full when write pointer catches up to synchronized read pointer

#### **Empty Flag Logic**
```verilog
assign empty = (w_gray2bin == r_ptr);
```
- **Comparison**: Converted Gray-to-Binary write pointer vs normal binary read pointer
- **Synchronization**: Write pointer passed through two-flop synchronizer
- **Detection**: Empty when read pointer catches up to synchronized write pointer

## ✨ Key Features

- **Independent Clock Domains**: Separate read and write clocks
- **Gray Code Pointers**: Eliminates multi-bit transition issues
- **Clock Domain Crossing**: Safe pointer synchronization
- **Metastability Protection**: Two-flop synchronizers
- **Reliable Flag Generation**: Proper full/empty detection across domains
- **Parameterizable Design**: Configurable data width and FIFO depth

---

## 📁 Repository Structure

```
📦 Asynchronous_FIFO_Design/
│   ├── block_diagram.png    # Asynchronous FIFO architecture diagram
│   ├── block_diagram.png    # Asynchronous FIFO architecture diagram 
│   ├── asynchronous.v       # Main asynchronous FIFO module
│   ├── tb_asynchronous.v    # Testbench with independent clocks
│   ├── waveform.png         # Simulation waveforms showing cross-domain operation
│   └── README.md            # Project documentation (this file)

```

---

## 🔍 Design Parameters

- `DATA_WIDTH` - Width of data bus
- `DEPTH` - FIFO memory depth (must be power of 2)
- `PTR_WIDTH` - Pointer width (log2(DEPTH) + 1)  // 1 additional bit for full logic calculation

## 🚀 How to Use

1. **Clock Requirements**: Provide independent `w_clk` and `r_clk`
2. **Reset**: Apply appropriate resets to both clock domains
3. **Write Operation**: Assert `w_en` when `full` is low
4. **Read Operation**: Assert `r_en` when `empty` is low


---

<p align="center">
  <i>Part of CoachED VLSI Training Projects | Designed by Prajwal</i>

</p>


