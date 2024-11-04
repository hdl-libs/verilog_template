// ---------------------------------------------------------------------------------------
// Copyright (c) 2024 john_tito All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// ---------------------------------------------------------------------------------------
// +FHEADER-------------------------------------------------------------------------------
// Author        : john_tito
// Module Name   : apb_template_ui
// ---------------------------------------------------------------------------------------
// Revision      : 1.0
// Description   : File Created
// ---------------------------------------------------------------------------------------
// Synthesizable : Yes
// Clock Domains : clk
// Reset Strategy: sync reset
// -FHEADER-------------------------------------------------------------------------------

// verilog_format: off
`resetall
`timescale 1ns / 1ps
`default_nettype none
// verilog_format: on

module apb_template_ui #(
    parameter integer C_APB_DATA_WIDTH = 32,
    parameter integer C_APB_ADDR_WIDTH = 16,
    parameter integer C_S_BASEADDR     = 0,
    parameter integer C_S_HIGHADDR     = 255
) (
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF s_apb , ASSOCIATED_RESET rstn" *)
    input wire clk,  //  (required)

    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rstn RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
    input wire rstn,  //  (required)

    (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 s_apb PADDR" *)
    input  wire [  (C_APB_ADDR_WIDTH-1):0] s_paddr,    // Address (required)
    (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 s_apb PSEL" *)
    input  wire                            s_psel,     // Slave Select (required)
    (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 s_apb PENABLE" *)
    input  wire                            s_penable,  // Enable (required)
    (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 s_apb PWRITE" *)
    input  wire                            s_pwrite,   // Write Control (required)
    (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 s_apb PWDATA" *)
    input  wire [  (C_APB_DATA_WIDTH-1):0] s_pwdata,   // Write Data (required)
    (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 s_apb PSTRB" *)
    input  wire [(C_APB_DATA_WIDTH/8-1):0] s_pstrb,    // Write data strobe (optional)
    (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 s_apb PREADY" *)
    output wire                            s_pready,   // Slave Ready (required)
    (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 s_apb PRDATA" *)
    output wire [  (C_APB_DATA_WIDTH-1):0] s_prdata,   // Read Data (required)
    (* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 s_apb PSLVERR" *)
    output wire                            s_pslverr   // Slave Error Response (required)

);

    //------------------------------------------------------------------------------------

    localparam [31:0] IPIDENTIFICATION = 32'hF7DEC7A5;
    localparam [31:0] REVISION = "V1.0";
    localparam [31:0] BUILDTIME = 32'h20231013;

    reg  [                31:0] test_reg;
    wire                        wr_active;
    wire                        rd_active;

    wire                        user_reg_rreq;
    wire                        user_reg_wreq;
    reg                         user_reg_rack;
    reg                         user_reg_wack;
    wire [C_APB_ADDR_WIDTH-1:0] user_reg_raddr;
    reg  [C_APB_DATA_WIDTH-1:0] user_reg_rdata;
    wire [C_APB_ADDR_WIDTH-1:0] user_reg_waddr;
    wire [C_APB_DATA_WIDTH-1:0] user_reg_wdata;

    assign user_reg_rreq  = ~s_pwrite & s_psel & s_penable;
    assign user_reg_wreq  = s_pwrite & s_psel & s_penable;
    assign s_pready       = user_reg_rack | user_reg_wack;
    assign user_reg_raddr = s_paddr;
    assign user_reg_waddr = s_paddr;
    assign s_prdata       = user_reg_rdata;
    assign user_reg_wdata = s_pwdata;
    assign s_pslverr      = 1'b0;

    assign rd_active      = user_reg_rreq;
    assign wr_active      = user_reg_wreq & user_reg_wack;

    always @(posedge clk) begin
        if (!rstn) begin
            user_reg_rack <= 1'b0;
            user_reg_wack <= 1'b0;
        end else begin
            user_reg_rack <= user_reg_rreq & ~user_reg_rack;
            user_reg_wack <= user_reg_wreq & ~user_reg_wack;
        end
    end

    //------------------------------------------------------------------------------------

    // verilog_format: off
    localparam [7:0] ADDR_ID        = C_S_BASEADDR;
    localparam [7:0] ADDR_REVISION  = ADDR_ID       + 8'h4;
    localparam [7:0] ADDR_BUILDTIME = ADDR_REVISION + 8'h4;
    localparam [7:0] ADDR_TEST      = ADDR_BUILDTIME + 8'h4;
    // verilog_format: on

    //Read Register
    //-------------------------------------------------------------------------------------------------------------------------------------------
    always @(posedge clk) begin
        if (!rstn) begin
            user_reg_rdata <= 32'd0;
        end else begin
            user_reg_rdata <= 32'd0;
            if (rd_active) begin
                case (user_reg_raddr)
                    ADDR_ID:        user_reg_rdata <= IPIDENTIFICATION;
                    ADDR_REVISION:  user_reg_rdata <= REVISION;
                    ADDR_BUILDTIME: user_reg_rdata <= BUILDTIME;
                    ADDR_TEST:      user_reg_rdata <= test_reg;
                    default:        user_reg_rdata <= 32'hdeadbeef;
                endcase
            end else begin
                ;
            end
        end
    end

    //-------------------------------------------------------------------------------------------------------------------------------------------
    //Write Register
    //-------------------------------------------------------------------------------------------------------------------------------------------
    always @(posedge clk) begin
        if (!rstn) begin
            test_reg <= 0;
        end else begin
            test_reg <= test_reg;
            if (wr_active) begin
                case (user_reg_waddr)
                    ADDR_TEST: test_reg <= user_reg_wdata;
                    default:   ;
                endcase
            end else begin
                ;
            end
        end
    end

endmodule

// verilog_format: off
`resetall
// verilog_format: on
