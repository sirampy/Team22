# RISC-V RV32I Pipelined Processor with Cache

## Overview

This branch of the Team22 repository implements a direct-mapped cache integrated into a RISC-V RV32I pipelined processor. Additionally, a two-way set-associative cache module is provided separately for educational purposes and future implementations.

## Direct-Mapped Cache Implementation

The direct-mapped cache is implemented in the `rtl/data_memory_cache` file. This module is designed to be simple yet effective, providing a straightforward mapping of memory addresses to cache lines.

### Key Features

- **Simplicity and Efficiency**: The direct-mapped cache is straightforward to understand and implement, making it an excellent choice for educational purposes and initial cache implementations.
- **Integration with RISC-V Processor**: This cache is fully integrated with the RV32I pipelined processor, ensuring seamless operation and improved performance.

## Two-Way Set-Associative Cache Module

Located in `rtl/two_way.sv`, this module is a separate implementation of a two-way set-associative cache. It is not integrated into the processor but is provided for educational purposes and can be used for future enhancements. 

### Educational Value

- **Understanding Cache Associativity**: This module serves as a practical example to understand the concepts of cache associativity and its impact on cache performance.
- **Basis for Future Implementation**: The module can be used to integrate a more complex cache system into the processor.