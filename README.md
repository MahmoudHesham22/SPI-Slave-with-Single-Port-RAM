# SPI-Slave-with-Single-Port-RAM

A synthesizable Verilog SPI slave interface connected to a simple single-port RAM, allowing an external SPI master to write to and read from memory over a 4-wire-style SPI link (`MOSI`, `MISO`, `SS_n`, `clk`).

## Overview

The project has two modules:

- **`SPI_slave`** — implements the SPI protocol state machine, shifts serial data in/out on `MOSI`/`MISO`, and exchanges parallel data with the RAM via `rx_data`/`rx_valid` (slave → RAM) and `tx_data`/`tx_valid` (RAM → slave).
- **`RAM`** — a simple byte-addressable memory with a registered (synchronous) read output, driven by the decoded commands coming from `SPI_slave`.

## Protocol

Each SPI transaction begins with `SS_n` going low and consists of a 2-bit command opcode followed by an 8-bit payload (10 bits total), MSB first on `MOSI`:

| Opcode (`din[9:8]`) | Meaning        | Payload (`din[7:0]`)      |
|---------------------|----------------|----------------------------|
| `2'b00`              | Write address  | Address to write to        |
| `2'b01`              | Write data     | Data byte to store          |
| `2'b10`              | Read address   | Address to read from        |
| `2'b11`              | Read data      | (triggers read, returns byte) |

A **READ** transaction is a two-phase exchange:
1. Master shifts in a 10-bit read-address frame on `MOSI`.
2. Once the address is received, the RAM performs a registered lookup; once `tx_valid` is asserted, the slave shifts the resulting byte out on `MISO`, MSB first.

## State Machine (`SPI_slave`)

```
IDLE ──(SS_n low)──▶ CHK_CMD ──(MOSI=0)──▶ WRITE ──(SS_n high)──▶ IDLE
                         │
                         └──(MOSI=1)──▶ READ ──(SS_n high)──▶ IDLE
```

- **IDLE** — waiting for `SS_n` to assert.
- **CHK_CMD** — samples the first bit of `MOSI` to decide WRITE vs READ.
- **WRITE** — shifts in 10 bits (`{opcode, payload}`) into `rx_data`, asserts `rx_valid` for one cycle once complete.
- **READ** — two sub-phases:
  - Shift in the 10-bit read-address frame (same as WRITE), then wait for the RAM's registered `tx_valid` response.
  - Shift `tx_data` out on `MISO`, MSB first, one bit per clock.

## Ports

### `SPI_slave`

| Port        | Dir | Width | Description                                   |
|-------------|-----|-------|------------------------------------------------|
| `clk`       | in  | 1     | System clock                                    |
| `rst_n`     | in  | 1     | Active-low async reset                          |
| `MOSI`      | in  | 1     | Serial data in from master                      |
| `SS_n`      | in  | 1     | Active-low slave select                         |
| `tx_data`   | in  | 8     | Byte to transmit, supplied by RAM                |
| `tx_valid`  | in  | 1     | Asserted by RAM when `tx_data` is valid          |
| `MISO`      | out | 1     | Serial data out to master                        |
| `rx_data`   | out | 10    | Received 10-bit frame `{opcode, payload}`        |
| `rx_valid`  | out | 1     | One-cycle pulse when `rx_data` is valid          |

### `RAM`

| Port        | Dir | Width          | Description                              |
|-------------|-----|----------------|--------------------------------------------|
| `clk`       | in  | 1              | System clock                                |
| `rst_n`     | in  | 1              | Active-low async reset                      |
| `din`       | in  | 10             | `rx_data` from `SPI_slave`                  |
| `rx_valid`  | in  | 1              | Valid strobe for `din`                       |
| `dout`      | out | 8              | Read data, registered                        |
| `tx_valid`  | out | 1              | Asserted for one cycle when `dout` is valid   |

Parameters: `MEM_DEPTH` (default 256), `ADDR_SIZE` (default 8).
