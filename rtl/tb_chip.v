`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:24:36 04/11/2020
// Design Name:   chip
// Module Name:   D:/work/CPU/RISCV/picorv32-Xilinx-ISE/xilinx/tb_chip.v
// Project Name:  chip
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: chip
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
`define tb_chip
module testbench;

	// Inputs
	reg clk = 1;
	reg reset_async = 0;
	reg rs232_dce_rxd = 0;
	reg [1:0] buttons_i = 0;

	// Outputs
	wire [3:0] led;
	wire rs232_dce_txd;

   wire FCLKIN_P;
   wire FCLKIN_N;
   wire [3:0] F_LED;

   reg [31:0] test;

   OBUFDS #(
       .IOSTANDARD("DEFAULT"), // Specify the output I/O standard
       .SLEW("SLOW")           // Specify the output slew rate
   ) OBUFDS_inst(
       .O(FCLKIN_P),     // Diff_p output (connect directly to top-level port)
       .OB(FCLKIN_N),   // Diff_n output (connect directly to top-level port)
       .I(clk)      // Buffer input
   );

	// Instantiate the Unit Under Test (UUT)
   chip uut
      (
         .test           (test),
         .FCLKIN_P       (FCLKIN_P),
         .FCLKIN_N       (FCLKIN_N),
         .FPGA_RESET     (reset_async),
         .PHY_RESET      (PHY_RESET),
         .PHY_TXC_GTXCLK (PHY_TXC_GTXCLK),
         .PHY_TXCLK      (PHY_TXCLK),
         .PHY_TXD        (PHY_TXD),
         .PHY_TXCTL_TXEN (PHY_TXCTL_TXEN),
         .PHY_TXER       (PHY_TXER),
         .PHY_RXD        (PHY_RXD),
         .PHY_RXCTL_RXDV (PHY_RXCTL_RXDV),
         .PHY_RXER       (PHY_RXER),
         .PHY_RXCLK      (PHY_RXCLK)
      );

   glbl glbl();

	always #4 clk = ~clk;
	
   initial begin
      $dumpfile("./rtl/testbench.vcd");
      $dumpvars(0, testbench);
      test = 32'd0;
      repeat (2) @(posedge clk);
      reset_async = 1;

      repeat (100000) @(posedge clk);

      $finish;
   end

   wire ser_rx = 0;
   wire ser_tx = F_LED[3];

   localparam ser_half_period = 25;
   event ser_sample;
   reg [7:0] buffer;

   always begin
      @(negedge ser_tx);

      repeat (ser_half_period) @(posedge clk);
      -> ser_sample; // start bit

      repeat (8) begin
         repeat (ser_half_period) @(posedge clk);
         repeat (ser_half_period) @(posedge clk);
         buffer = {ser_tx, buffer[7:1]};
         -> ser_sample; // data bit
      end

      repeat (ser_half_period) @(posedge clk);
      repeat (ser_half_period) @(posedge clk);
      -> ser_sample; // stop bit

      if (buffer < 32 || buffer >= 127)
         if (buffer == 10)
            $display(" ");
         else begin
            $display("Serial data: %d", buffer);
         end
      else
         $write("%c", buffer);
   end

   initial begin
      $readmemh("firmware/firmwareram00.hex", uut._top._text_RAM._ram_4k_32_0._bram0.mem);
      $readmemh("firmware/firmwareram01.hex", uut._top._text_RAM._ram_4k_32_0._bram1.mem);
      $readmemh("firmware/firmwareram02.hex", uut._top._text_RAM._ram_4k_32_0._bram2.mem);
      $readmemh("firmware/firmwareram03.hex", uut._top._text_RAM._ram_4k_32_0._bram3.mem);
      $readmemh("firmware/firmwareram04.hex", uut._top._text_RAM._ram_4k_32_1._bram0.mem);
      $readmemh("firmware/firmwareram05.hex", uut._top._text_RAM._ram_4k_32_1._bram1.mem);
      $readmemh("firmware/firmwareram06.hex", uut._top._text_RAM._ram_4k_32_1._bram2.mem);
      $readmemh("firmware/firmwareram07.hex", uut._top._text_RAM._ram_4k_32_1._bram3.mem);
      $readmemh("firmware/firmwareram08.hex", uut._top._text_RAM._ram_4k_32_2._bram0.mem);
      $readmemh("firmware/firmwareram09.hex", uut._top._text_RAM._ram_4k_32_2._bram1.mem);
      $readmemh("firmware/firmwareram10.hex", uut._top._text_RAM._ram_4k_32_2._bram2.mem);
      $readmemh("firmware/firmwareram11.hex", uut._top._text_RAM._ram_4k_32_2._bram3.mem);
      $readmemh("firmware/firmwareram12.hex", uut._top._text_RAM._ram_4k_32_3._bram0.mem);
      $readmemh("firmware/firmwareram13.hex", uut._top._text_RAM._ram_4k_32_3._bram1.mem);
      $readmemh("firmware/firmwareram14.hex", uut._top._text_RAM._ram_4k_32_3._bram2.mem);
      $readmemh("firmware/firmwareram15.hex", uut._top._text_RAM._ram_4k_32_3._bram3.mem);
      $readmemh("firmware/firmwarezero.hex", uut._top._heap_RAM._ram_4k_32_0._bram0.mem);
      $readmemh("firmware/firmwarezero.hex", uut._top._heap_RAM._ram_4k_32_0._bram1.mem);
      $readmemh("firmware/firmwarezero.hex", uut._top._heap_RAM._ram_4k_32_0._bram2.mem);
      $readmemh("firmware/firmwarezero.hex", uut._top._heap_RAM._ram_4k_32_0._bram3.mem);
      $readmemh("firmware/firmwarezero.hex", uut._top._heap_RAM._ram_4k_32_1._bram0.mem);
      $readmemh("firmware/firmwarezero.hex", uut._top._heap_RAM._ram_4k_32_1._bram1.mem);
      $readmemh("firmware/firmwarezero.hex", uut._top._heap_RAM._ram_4k_32_1._bram2.mem);
      $readmemh("firmware/firmwarezero.hex", uut._top._heap_RAM._ram_4k_32_1._bram3.mem);
      $readmemh("firmware/firmwarezero.hex", uut._top._heap_RAM._ram_4k_32_2._bram0.mem);
      $readmemh("firmware/firmwarezero.hex", uut._top._heap_RAM._ram_4k_32_2._bram1.mem);
      $readmemh("firmware/firmwarezero.hex", uut._top._heap_RAM._ram_4k_32_2._bram2.mem);
      $readmemh("firmware/firmwarezero.hex", uut._top._heap_RAM._ram_4k_32_2._bram3.mem);
      $readmemh("firmware/firmwarezero.hex", uut._top._heap_RAM._ram_4k_32_3._bram0.mem);
      $readmemh("firmware/firmwarezero.hex", uut._top._heap_RAM._ram_4k_32_3._bram1.mem);
      $readmemh("firmware/firmwarezero.hex", uut._top._heap_RAM._ram_4k_32_3._bram2.mem);
      $readmemh("firmware/firmwarezero.hex", uut._top._heap_RAM._ram_4k_32_3._bram3.mem);
   end	


   
endmodule