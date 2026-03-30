# About

This project contains Verilog implementation of module to communicate with the TM1638 IC. It has three layers:
- tm1638.v for direct communication
- tm1638_interface.v for getting direct access to all buttons and LEDs supported by IC. It runs in a loop and constantly update LEDs states and read buttons
- led_and_key.v for working with "TM1638 LED&KEY module"

Also there is helper file display_decoder.vh that is intended to be included to your design. It provides function to decode 4 bit data to code for 7 segment display

# Example

This project is implemented for Gowin GW2A LV18GBGA256 C8/I7, but due to simple design and parametric frequency it can be ported to almost any other FPGA / CPLD

## Building

Use Gowin IDE to build the project

1. Generate `UART to bus IP`
    1. Open IP core generator in the IDE
    2. Click folder icon
    3. Open IPC file in the repo (`src/uart_to_bus/uart_to_bus.ipc`)
    4. Press OK
2. Run Place & Route in the IDE
3. Use Programmer to flash the bitstream

The project is built for Sipeed Tang Primer 20K, make following connections:

Also make sure that GND is connected and TM1638 is powered from external 5V source

tm_clk <-> T6;
tm_stb <-> P6;
tm_dio <-> T7;

The design uses Gowin uart to bus IP. To use it connect uart converter, make sure it is 3.3v standard

L9 <-> converter RX;
N8 <-> converter TX;

Use following commands to communicate with FPGA over UART, every command should end with newline:

`W X Y` where X is digit from 0 to 7 and Y is hex digit (0-9, A-F) to output digit Y to display with number X
`W X 1Y` same as above, but with dot

Buttons on the LED&KEY module connected to LEDs above the display, you can use T5 switch to invert it

You can use C7 button for reset

# Homework

- Add command `W X 2Y` to display minus sign
- Add command `W X 3Y` to display nothing on the display
