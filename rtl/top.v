`define dbg_hex
module top(
  input clk,
  input resetn,
  output [3:0] led,
  output [7:0] SEG_o,
  output [1:0] COM_o,
  input [1:0] buttons_i,
  input rxd,
  output txd
);

  wire trap;
  wire mem_valid;
  wire mem_instr;
  reg mem_ready;
  wire [31:0] mem_addr;
  wire [31:0] mem_wdata;
  wire [3:0] mem_wstrb;
  wire [31:0] mem_rdata;
  reg [31:0] irq;
  
  picorv32 #(
    .ENABLE_REGS_DUALPORT(1),
    .STACKADDR(32'h 0000_3fff)) 
  _picorv32(
    .clk(clk),
    .resetn(resetn),
    .trap(trap),
    .mem_valid(mem_valid),
    .mem_instr(mem_instr),
    .mem_ready(mem_ready),
    .mem_addr(mem_addr),
    .mem_wdata(mem_wdata),
    .mem_wstrb(mem_wstrb),
    .mem_rdata(mem_rdata),
	 .irq(irq)
  );
  
	always @(posedge clk) begin
		irq <= 0;
		irq[4] <= 0;//buttons_i[0];
		irq[5] <= 0;//buttons_i[1];
	end
	
  wire [31:0] ram_rdata_0;
  wire [31:0] ram_rdata_1;
  wire [31:0] ram_rdata_2;
  wire [31:0] ram_rdata_3;
  wire [31:0] ram_rdata_4;
  wire [31:0] ram_rdata_5;
  wire [31:0] ram_rdata_6;
  wire [31:0] ram_rdata_7;
  wire [31:0] io_rdata;
  reg [31:0] mem_addr1;

  always @(posedge clk) begin
    mem_ready <= mem_valid  && !mem_ready;
    mem_addr1 <= mem_addr;
  end

  wire io_valid = mem_valid && (mem_addr[31]);
  wire reset = ~resetn;

  ram_4k_32 _ram_4k_32_0(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_0, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b000)) ? mem_wstrb : 4'b0,
    mem_valid && !mem_addr[31]);
  ram_4k_32 _ram_4k_32_1(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_1, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b001)) ? mem_wstrb : 4'b0,
    mem_valid && !mem_addr[31]);
  ram_4k_32 _ram_4k_32_2(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_2, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b010)) ? mem_wstrb : 4'b0,
    mem_valid && !mem_addr[31]);
  ram_4k_32 _ram_4k_32_3(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_3, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b011)) ? mem_wstrb : 4'b0,
    mem_valid && !mem_addr[31]);

  ram_4k_32 _ram_4k_32_4(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_4, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b100)) ? mem_wstrb : 4'b0,
    mem_valid && !mem_addr[31]);
  ram_4k_32 _ram_4k_32_5(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_5, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b101)) ? mem_wstrb : 4'b0,
    mem_valid && !mem_addr[31]);
  ram_4k_32 _ram_4k_32_6(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_6, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b110)) ? mem_wstrb : 4'b0,
    mem_valid && !mem_addr[31]);
  ram_4k_32 _ram_4k_32_7(clk, mem_addr[13:2],
    mem_wdata, ram_rdata_7, 
    (mem_valid && !mem_ready && (mem_addr[16:14] == 3'b111)) ? mem_wstrb : 4'b0,
    mem_valid && !mem_addr[31]);

   initial begin
   $readmemh("../sw/firmwareram00.hex", _ram_4k_32_0._bram0.mem);
   $readmemh("../sw/firmwareram01.hex", _ram_4k_32_0._bram1.mem);
   $readmemh("../sw/firmwareram02.hex", _ram_4k_32_0._bram2.mem);
   $readmemh("../sw/firmwareram03.hex", _ram_4k_32_0._bram3.mem);
   $readmemh("../sw/firmwareram04.hex", _ram_4k_32_1._bram0.mem);
   $readmemh("../sw/firmwareram05.hex", _ram_4k_32_1._bram1.mem);
   $readmemh("../sw/firmwareram06.hex", _ram_4k_32_1._bram2.mem);
   $readmemh("../sw/firmwareram07.hex", _ram_4k_32_1._bram3.mem);
   $readmemh("../sw/firmwareram08.hex", _ram_4k_32_2._bram0.mem);
   $readmemh("../sw/firmwareram09.hex", _ram_4k_32_2._bram1.mem);
   $readmemh("../sw/firmwareram10.hex", _ram_4k_32_2._bram2.mem);
   $readmemh("../sw/firmwareram11.hex", _ram_4k_32_2._bram3.mem);
   $readmemh("../sw/firmwareram12.hex", _ram_4k_32_3._bram0.mem);
   $readmemh("../sw/firmwareram13.hex", _ram_4k_32_3._bram1.mem);
   $readmemh("../sw/firmwareram14.hex", _ram_4k_32_3._bram2.mem);
   $readmemh("../sw/firmwareram15.hex", _ram_4k_32_3._bram3.mem);
   $readmemh("../sw/firmwareram16.hex", _ram_4k_32_4._bram0.mem);
   $readmemh("../sw/firmwareram17.hex", _ram_4k_32_4._bram1.mem);
   $readmemh("../sw/firmwareram18.hex", _ram_4k_32_4._bram2.mem);
   $readmemh("../sw/firmwareram19.hex", _ram_4k_32_4._bram3.mem);
   $readmemh("../sw/firmwareram20.hex", _ram_4k_32_5._bram0.mem);
   $readmemh("../sw/firmwareram21.hex", _ram_4k_32_5._bram1.mem);
   $readmemh("../sw/firmwareram22.hex", _ram_4k_32_5._bram2.mem);
   $readmemh("../sw/firmwareram23.hex", _ram_4k_32_5._bram3.mem);
   $readmemh("../sw/firmwareram24.hex", _ram_4k_32_6._bram0.mem);
   $readmemh("../sw/firmwareram25.hex", _ram_4k_32_6._bram1.mem);
   $readmemh("../sw/firmwareram26.hex", _ram_4k_32_6._bram2.mem);
   $readmemh("../sw/firmwareram27.hex", _ram_4k_32_6._bram3.mem);
   $readmemh("../sw/firmwareram28.hex", _ram_4k_32_7._bram0.mem);
   $readmemh("../sw/firmwareram29.hex", _ram_4k_32_7._bram1.mem);
   $readmemh("../sw/firmwareram30.hex", _ram_4k_32_7._bram2.mem);
   $readmemh("../sw/firmwareram31.hex", _ram_4k_32_7._bram3.mem);
   end		
  io _io(clk, reset, io_valid, mem_addr[4:2], mem_wdata, mem_wstrb[0], io_rdata, led[2:0], SEG_o, COM_o, rxd, txd);

  assign mem_rdata = mem_addr1[31] ? io_rdata : 
              (mem_addr1[16:14] == 3'b000) ? ram_rdata_0 : 
              (mem_addr1[16:14] == 3'b001) ? ram_rdata_1 : 
              (mem_addr1[16:14] == 3'b010) ? ram_rdata_2 : 
              (mem_addr1[16:14] == 3'b011) ? ram_rdata_3 : 
              (mem_addr1[16:14] == 3'b100) ? ram_rdata_4 : 
              (mem_addr1[16:14] == 3'b101) ? ram_rdata_5 : 
              (mem_addr1[16:14] == 3'b110) ? ram_rdata_6 : ram_rdata_7;

  assign led[3] = trap;
  
//wire [35:0] CONTROL0;
//ILA ILA (
//    .CONTROL(CONTROL0), // INOUT BUS [35:0]
//    .CLK(clk), // IN
//    .TRIG0(mem_valid), // IN BUS [0:0]
//    .TRIG1(mem_instr), // IN BUS [0:0]
//    .TRIG2(mem_ready), // IN BUS [0:0]
//    .TRIG3(mem_addr), // IN BUS [31:0]
//    .TRIG4(mem_wdata), // IN BUS [31:0]
//    .TRIG5(mem_wstrb), // IN BUS [3:0]
//    .TRIG6(mem_rdata) // IN BUS [31:0]
//);
//
//ICON ICON (
//    .CONTROL0(CONTROL0) // INOUT BUS [35:0]
//);
endmodule

module io(
  input clk,
  input reset,
  input valid,
  input [2:0] addr,
  input [31:0] wdata,
  input wstrb,
  output reg [31:0] rdata,
  output reg [2:0] led,
  
  output reg [7:0] SEG_o,
  output reg [1:0] COM_o,
  
  input rxd,
  output txd
);

// peripheral memory map
//
// 80000000 out, LED [0], write
// 80000004 UART TX, data [7:0], write
// 80000008 UART TX, ready [0], read
// 8000000c UART RX, data [7:0], read
// 80000010 UART RX, ready [0], read

  wire led_write_strobe =        valid && (addr==3'd0) && wstrb;
  wire uart_tx_write_strobe =    valid && (addr==3'd1) && wstrb;
  wire uart_rx_read_strobe =     valid && (addr==3'd3) && !wstrb;

  wire lcd_write_strobe =        valid && (addr==3'd5) && wstrb;
  wire lcd_enable_strobe =        valid && (addr==3'd6) && wstrb;
	
  wire uart_tx_ready;
  wire [7:0] uart_rx_data;
  wire uart_rx_ready;
  
  always @(posedge clk)
    case (addr)
      3'd2: rdata <= {31'd0, uart_tx_ready};
      3'd3: rdata <= {24'd0, uart_rx_data};
      3'd4: rdata <= {31'd0, uart_rx_ready};
      default: rdata <= 32'd0;
    endcase

  wire baudclk16;

  uart_baud_clock_16x _uart_baud_clock_16x(clk, baudclk16);

  uart_tx _uart_tx(clk, reset, baudclk16, txd, wdata[7:0], uart_tx_ready, uart_tx_write_strobe);
  uart_rx _uart_rx(clk, reset, baudclk16, rxd, uart_rx_data, uart_rx_ready, uart_rx_read_strobe);

  always @(posedge clk) begin
    // led[6] <= uart_tx_ready;
    // led[5] <= uart_rx_ready;
    // led[4] <= !txd;
    // led[3] <= !rxd;
    // if (led_write_strobe)
	 if (reset)
      led[2:0] <= 3'b011;//wdata[3:0];
	 else if (led_write_strobe)
		led[2:0] <= wdata[2:0];
  end
(* ram_style = "distributed" *)
reg [7:0] lcd_table[0:15];
reg [3:0] lcd0,lcd1;
reg lcd_enable;
  always @(posedge clk) begin
	 if (reset) begin
		lcd0 <= 0;
		lcd1 <= 0;
		lcd_enable <= 0;
	 end else if (lcd_write_strobe) begin
		lcd0 <= wdata[3:0];
		lcd1 <= wdata[7:4];
	 end else if (lcd_enable_strobe) begin
		lcd_enable <= wdata[0];
	 end
lcd_table[0]<= 8'hFC;
lcd_table[1]<= 8'h60;
lcd_table[2]<= 8'hDA;
lcd_table[3]<= 8'hF2;
lcd_table[4]<= 8'h66;
lcd_table[5]<= 8'hB6;
lcd_table[6]<= 8'hBE;
lcd_table[7]<= 8'hE0;
lcd_table[8]<= 8'hFE;
lcd_table[9]<= 8'hF6;
lcd_table[10]<= 8'h01;
lcd_table[11]<= 8'h01;
lcd_table[12]<= 8'h01;
lcd_table[13]<= 8'h01;
lcd_table[14]<= 8'h01;
lcd_table[15]<= 8'h01;
  end
reg [16:0] lcd_state;
  always @(posedge clk) begin
	 if (reset) begin
      lcd_state <= 0;
      COM_o <= 2'b00;
		SEG_o <= 8'd0;
	 end else begin
		if (lcd_state[16]) begin
		  SEG_o <= lcd_table[lcd0];
		  COM_o <= lcd_enable ? 2'b10 : 2'b00;
		end else begin
		  SEG_o <= lcd_table[lcd1];
		  COM_o <= lcd_enable ? 2'b01 : 2'b00;
		end
		lcd_state <= lcd_state + 1;
	 end
  end  
endmodule

// module ram_2k_32(
//   input clk,
//   input [10:0] addr,
//   input [31:0] din,
//   output [31:0] dout,
//   input [3:0] we,
//   input en
// );

//   bram_2k_8 _bram0(clk, addr, din[7:0], dout[7:0], we[0], en);
//   bram_2k_8 _bram1(clk, addr, din[15:8], dout[15:8], we[1], en);
//   bram_2k_8 _bram2(clk, addr, din[23:16], dout[23:16], we[2], en);
//   bram_2k_8 _bram3(clk, addr, din[31:24], dout[31:24], we[3], en);

// //`ifdef tb_chip
// //   initial begin
// //     $readmemh("../firmware/firmware_B0.hex", _bram0.mem);
// //     $readmemh("../firmware/firmware_B1.hex", _bram1.mem);
// //     $readmemh("../firmware/firmware_B2.hex", _bram2.mem);
// //     $readmemh("../firmware/firmware_B3.hex", _bram3.mem);
// //   end
// //`endif

// endmodule

// module bram_2k_8(
//   input clk,
//   input [10:0] addr,
//   input [7:0] din,
//   output [7:0] dout,
//   input we,
//   input en
// );

//   reg [7:0] mem[0:2047];
//   reg [10:0] addr1;

//   always @(posedge clk)
//     if (en) begin
//       addr1 <= addr;
//       if (we)
//         mem[addr] <= din;
//     end      

//   assign dout = mem[addr1];

// endmodule

module ram_4k_32(
  input clk,
  input [11:0] addr,
  input [31:0] din,
  output [31:0] dout,
  input [3:0] we,
  input en
);

  bram_4k_8 _bram0(clk, addr, din[7:0], dout[7:0], we[0], en);
  bram_4k_8 _bram1(clk, addr, din[15:8], dout[15:8], we[1], en);
  bram_4k_8 _bram2(clk, addr, din[23:16], dout[23:16], we[2], en);
  bram_4k_8 _bram3(clk, addr, din[31:24], dout[31:24], we[3], en);

//   initial begin
//     $readmemh("../firmware/firmware_B0.hex", _bram0.mem);
//     $readmemh("../firmware/firmware_B1.hex", _bram1.mem);
//     $readmemh("../firmware/firmware_B2.hex", _bram2.mem);
//     $readmemh("../firmware/firmware_B3.hex", _bram3.mem);
//   end

endmodule

module bram_4k_8(
  input clk,
  input [11:0] addr,
  input [7:0] din,
  output [7:0] dout,
  input we,
  input en
);

  reg [7:0] mem[0:4095];
  reg [11:0] addr1;

  always @(posedge clk)
    if (en) begin
      addr1 <= addr;
      if (we)
        mem[addr] <= din;
    end      

  assign dout = mem[addr1];

endmodule
module uart_baud_clock_16x(
  input clk,
  output baudclk16
);

  reg [8:0] c;
  wire m = (c==9'd325);    // 50000000/(16*9600) ~= 326

  always @(posedge clk)
    c <= m ? 0 : c+1;

  assign baudclk16 = m;

endmodule
