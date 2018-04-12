-- ============================================================================
-- Copyright (c) 2013 by Terasic Technologies Inc.
-- ============================================================================
--
-- Permission:
--
--   Terasic grants permission to use and modify this code for use
--   in synthesis for all Terasic Development Boards and Altera Development 
--   Kits made by Terasic.  Other use of this code, including the selling 
--   ,duplication, or modification of any portion is strictly prohibited.
--
-- Disclaimer:
--
--   This VHDL/Verilog or C/C++ source code is intended as a design reference
--   which illustrates how these types of functions can be implemented.
--   It is the user's responsibility to verify their design for
--   consistency and functionality through the use of formal
--   verification methods.  Terasic provides no warranty regarding the use 
--   or functionality of this code.
--
-- ============================================================================
--           
--  Terasic Technologies Inc
--  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
--  
--  
--                     web: http:--www.terasic.com/  
--                     email: support@terasic.com
--
-- ============================================================================
--Date:  Mon Jun 17 20:35:29 2013
-- ============================================================================

LIBRARY ieee;
use ieee.numeric_std.all;
USE ieee.std_logic_1164.all;

ENTITY ghrd_top IS 
	PORT (
		--------- ADC ---------
		ADC_CS_N: INOUT STD_LOGIC;
		ADC_DIN: OUT STD_LOGIC;
		ADC_DOUT: IN STD_LOGIC;
		ADC_SCLK: OUT STD_LOGIC;

		--------- AUD ---------
		AUD_ADCDAT: IN STD_LOGIC;
		AUD_ADCLRCK: INOUT STD_LOGIC;
		AUD_BCLK: INOUT STD_LOGIC;
		AUD_DACDAT: OUT STD_LOGIC;
		AUD_DACLRCK: INOUT STD_LOGIC;
		AUD_XCK: OUT STD_LOGIC;

		--------- CLOCK2 ---------
		CLOCK2_50: IN STD_LOGIC;

		--------- CLOCK3 ---------
		CLOCK3_50: IN STD_LOGIC;

		--------- CLOCK4 ---------
		CLOCK4_50: IN STD_LOGIC;

		--------- CLOCK ---------
		CLOCK_50: IN STD_LOGIC;

		--------- DRAM ---------
		DRAM_ADDR: OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
		DRAM_BA: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		DRAM_CAS_N: OUT STD_LOGIC;
		DRAM_CKE: OUT STD_LOGIC;
		DRAM_CLK: OUT STD_LOGIC;
		DRAM_CS_N: OUT STD_LOGIC;
		DRAM_DQ: INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		DRAM_LDQM: OUT STD_LOGIC;
		DRAM_RAS_N: OUT STD_LOGIC;
		DRAM_UDQM: OUT STD_LOGIC;
		DRAM_WE_N: OUT STD_LOGIC;

		--------- FAN ---------
		FAN_CTRL: OUT STD_LOGIC;

		--------- FPGA ---------
		FPGA_I2C_SCLK: OUT STD_LOGIC;
		FPGA_I2C_SDAT: INOUT STD_LOGIC;

		--------- GPIO ---------
		GPIO_0: INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
		GPIO_1: INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);


		--------- HEX0 ---------
		HEX0: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);

		--------- HE61 ---------
		HEX1: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);

		--------- HE62 ---------
		HEX2: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);

		--------- HE63 ---------
		HEX3: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);

		--------- HE64 ---------
		HEX4: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);

		--------- HE65 ---------
		HEX5: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);

		--------- HPS ---------
		HPS_CONV_USB_N: INOUT STD_LOGIC;
		HPS_DDR3_ADDR: OUT STD_LOGIC_VECTOR(14 DOWNTO 0);
		HPS_DDR3_BA: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		HPS_DDR3_CAS_N: OUT STD_LOGIC;
		HPS_DDR3_CKE: OUT STD_LOGIC;
		HPS_DDR3_CK_N: OUT STD_LOGIC;
		HPS_DDR3_CK_P: OUT STD_LOGIC;
		HPS_DDR3_CS_N: OUT STD_LOGIC;
		HPS_DDR3_DM: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		HPS_DDR3_DQ: INOUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		HPS_DDR3_DQS_N: INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		HPS_DDR3_DQS_P: INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		HPS_DDR3_ODT: OUT STD_LOGIC;
		HPS_DDR3_RAS_N: OUT STD_LOGIC;
		HPS_DDR3_RESET_N: OUT STD_LOGIC;
		HPS_DDR3_RZQ: IN STD_LOGIC;
		HPS_DDR3_WE_N: OUT STD_LOGIC;
		HPS_ENET_GTX_CLK: OUT STD_LOGIC;
		HPS_ENET_INT_N: INOUT STD_LOGIC;
		HPS_ENET_MDC: OUT STD_LOGIC;
		HPS_ENET_MDIO: INOUT STD_LOGIC;
		HPS_ENET_RX_CLK: IN STD_LOGIC;
		HPS_ENET_RX_DATA: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		HPS_ENET_RX_DV: IN STD_LOGIC;
		HPS_ENET_TX_DATA: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		HPS_ENET_TX_EN: OUT STD_LOGIC;
		HPS_FLASH_DATA: INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		HPS_FLASH_DCLK: OUT STD_LOGIC;
		HPS_FLASH_NCSO: OUT STD_LOGIC;
		HPS_GSENSOR_INT: INOUT STD_LOGIC;
		HPS_I2C1_SCLK: INOUT STD_LOGIC;
		HPS_I2C1_SDAT: INOUT STD_LOGIC;
		HPS_I2C2_SCLK: INOUT STD_LOGIC;
		HPS_I2C2_SDAT: INOUT STD_LOGIC;
		HPS_I2C_CONTROL: INOUT STD_LOGIC;
		HPS_KEY: INOUT STD_LOGIC;
		HPS_LED: INOUT STD_LOGIC;
		HPS_LTC_GPIO: INOUT STD_LOGIC;
		HPS_SD_CLK: OUT STD_LOGIC;
		HPS_SD_CMD: INOUT STD_LOGIC;
		HPS_SD_DATA: INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		HPS_SPIM_CLK: OUT STD_LOGIC;
		HPS_SPIM_MISO: IN STD_LOGIC;
		HPS_SPIM_MOSI: OUT STD_LOGIC;
		HPS_SPIM_SS: INOUT STD_LOGIC;
		HPS_UART_RX: IN STD_LOGIC;
		HPS_UART_TX: OUT STD_LOGIC;
		HPS_USB_CLKOUT: IN STD_LOGIC;
		HPS_USB_DATA: INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		HPS_USB_DIR: IN STD_LOGIC;
		HPS_USB_NXT: IN STD_LOGIC;
		HPS_USB_STP: OUT STD_LOGIC;

		--------- IRDA ---------
		IRDA_RXD: IN STD_LOGIC;
		IRDA_TXD: OUT STD_LOGIC;

		--------- KEY ---------
		KEY: IN STD_LOGIC_VECTOR(3 DOWNTO 0);

		--------- LEDR ---------
		LEDR: OUT STD_LOGIC_VECTOR(9 DOWNTO 0);

		--------- PS2 ---------
		PS2_CLK: INOUT STD_LOGIC;
		PS2_CLK2: INOUT STD_LOGIC;
		PS2_DAT: INOUT STD_LOGIC;
		PS2_DAT2: INOUT STD_LOGIC;

		--------- SW ---------
		SW: IN STD_LOGIC_VECTOR(9 DOWNTO 0);

		--------- TD ---------
		TD_CLK27: IN STD_LOGIC;
		TD_DATA: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		TD_HS: IN STD_LOGIC;
		TD_RESET_N: OUT STD_LOGIC;
		TD_VS: IN STD_LOGIC;

		--------- VGA ---------
		VGA_B: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		VGA_BLANK_N: OUT STD_LOGIC;
		VGA_CLK: OUT STD_LOGIC;
		VGA_G: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		VGA_HS: OUT STD_LOGIC;
		VGA_R: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		VGA_SYNC_N: OUT STD_LOGIC;
		VGA_VS: OUT STD_LOGIC
	);
END ENTITY ghrd_top;

ARCHITECTURE arch OF ghrd_top IS
	-- Internal signals
	SIGNAL fpga_debounced_buttons: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL fpga_led_internal: STD_LOGIC_VECTOR(9 DOWNTO 0);
	SIGNAL hps_fpga_reset_n: STD_LOGIC;
	SIGNAL hps_reset_req: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL hps_cold_reset: STD_LOGIC;
	SIGNAL hps_warm_reset: STD_LOGIC;
	SIGNAL hps_debug_reset: STD_LOGIC;
	SIGNAL stm_hw_events: STD_LOGIC_VECTOR(27 DOWNTO 0);
	
	SIGNAL hps_warm_reset_n: STD_LOGIC;
	SIGNAL hps_debug_reset_n: STD_LOGIC;
	SIGNAL hps_cold_reset_n: STD_LOGIC;
	
	
	SIGNAL multiplier_a_in_sig : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL multiplier_b_in_sig : STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL multiplier_out_sig : STD_LOGIC_VECTOR(15 downto 0);
	
--	SIGNAL LEDs : STD_LOGIC_VECTOR(9 downto 0);
	
	-- Component declarations for qip
	component soc_system is
        port (
            clk_clk                               : in    std_logic                     := 'X';             -- clk
            hps_0_f2h_cold_reset_req_reset_n      : in    std_logic                     := 'X';             -- reset_n
            hps_0_f2h_debug_reset_req_reset_n     : in    std_logic                     := 'X';             -- reset_n
            hps_0_f2h_stm_hw_events_stm_hwevents  : in    std_logic_vector(27 downto 0) := (others => 'X'); -- stm_hwevents
            hps_0_f2h_warm_reset_req_reset_n      : in    std_logic                     := 'X';             -- reset_n
            hps_0_h2f_reset_reset_n               : out   std_logic;                                        -- reset_n
            hps_0_hps_io_hps_io_emac1_inst_TX_CLK : out   std_logic;                                        -- hps_io_emac1_inst_TX_CLK
            hps_0_hps_io_hps_io_emac1_inst_TXD0   : out   std_logic;                                        -- hps_io_emac1_inst_TXD0
            hps_0_hps_io_hps_io_emac1_inst_TXD1   : out   std_logic;                                        -- hps_io_emac1_inst_TXD1
            hps_0_hps_io_hps_io_emac1_inst_TXD2   : out   std_logic;                                        -- hps_io_emac1_inst_TXD2
            hps_0_hps_io_hps_io_emac1_inst_TXD3   : out   std_logic;                                        -- hps_io_emac1_inst_TXD3
            hps_0_hps_io_hps_io_emac1_inst_RXD0   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD0
            hps_0_hps_io_hps_io_emac1_inst_MDIO   : inout std_logic                     := 'X';             -- hps_io_emac1_inst_MDIO
            hps_0_hps_io_hps_io_emac1_inst_MDC    : out   std_logic;                                        -- hps_io_emac1_inst_MDC
            hps_0_hps_io_hps_io_emac1_inst_RX_CTL : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CTL
            hps_0_hps_io_hps_io_emac1_inst_TX_CTL : out   std_logic;                                        -- hps_io_emac1_inst_TX_CTL
            hps_0_hps_io_hps_io_emac1_inst_RX_CLK : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RX_CLK
            hps_0_hps_io_hps_io_emac1_inst_RXD1   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD1
            hps_0_hps_io_hps_io_emac1_inst_RXD2   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD2
            hps_0_hps_io_hps_io_emac1_inst_RXD3   : in    std_logic                     := 'X';             -- hps_io_emac1_inst_RXD3
            hps_0_hps_io_hps_io_qspi_inst_IO0     : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO0
            hps_0_hps_io_hps_io_qspi_inst_IO1     : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO1
            hps_0_hps_io_hps_io_qspi_inst_IO2     : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO2
            hps_0_hps_io_hps_io_qspi_inst_IO3     : inout std_logic                     := 'X';             -- hps_io_qspi_inst_IO3
            hps_0_hps_io_hps_io_qspi_inst_SS0     : out   std_logic;                                        -- hps_io_qspi_inst_SS0
            hps_0_hps_io_hps_io_qspi_inst_CLK     : out   std_logic;                                        -- hps_io_qspi_inst_CLK
            hps_0_hps_io_hps_io_sdio_inst_CMD     : inout std_logic                     := 'X';             -- hps_io_sdio_inst_CMD
            hps_0_hps_io_hps_io_sdio_inst_D0      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D0
            hps_0_hps_io_hps_io_sdio_inst_D1      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D1
            hps_0_hps_io_hps_io_sdio_inst_CLK     : out   std_logic;                                        -- hps_io_sdio_inst_CLK
            hps_0_hps_io_hps_io_sdio_inst_D2      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D2
            hps_0_hps_io_hps_io_sdio_inst_D3      : inout std_logic                     := 'X';             -- hps_io_sdio_inst_D3
            hps_0_hps_io_hps_io_usb1_inst_D0      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D0
            hps_0_hps_io_hps_io_usb1_inst_D1      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D1
            hps_0_hps_io_hps_io_usb1_inst_D2      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D2
            hps_0_hps_io_hps_io_usb1_inst_D3      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D3
            hps_0_hps_io_hps_io_usb1_inst_D4      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D4
            hps_0_hps_io_hps_io_usb1_inst_D5      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D5
            hps_0_hps_io_hps_io_usb1_inst_D6      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D6
            hps_0_hps_io_hps_io_usb1_inst_D7      : inout std_logic                     := 'X';             -- hps_io_usb1_inst_D7
            hps_0_hps_io_hps_io_usb1_inst_CLK     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_CLK
            hps_0_hps_io_hps_io_usb1_inst_STP     : out   std_logic;                                        -- hps_io_usb1_inst_STP
            hps_0_hps_io_hps_io_usb1_inst_DIR     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_DIR
            hps_0_hps_io_hps_io_usb1_inst_NXT     : in    std_logic                     := 'X';             -- hps_io_usb1_inst_NXT
            hps_0_hps_io_hps_io_spim1_inst_CLK    : out   std_logic;                                        -- hps_io_spim1_inst_CLK
            hps_0_hps_io_hps_io_spim1_inst_MOSI   : out   std_logic;                                        -- hps_io_spim1_inst_MOSI
            hps_0_hps_io_hps_io_spim1_inst_MISO   : in    std_logic                     := 'X';             -- hps_io_spim1_inst_MISO
            hps_0_hps_io_hps_io_spim1_inst_SS0    : out   std_logic;                                        -- hps_io_spim1_inst_SS0
            hps_0_hps_io_hps_io_uart0_inst_RX     : in    std_logic                     := 'X';             -- hps_io_uart0_inst_RX
            hps_0_hps_io_hps_io_uart0_inst_TX     : out   std_logic;                                        -- hps_io_uart0_inst_TX
            hps_0_hps_io_hps_io_i2c0_inst_SDA     : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SDA
            hps_0_hps_io_hps_io_i2c0_inst_SCL     : inout std_logic                     := 'X';             -- hps_io_i2c0_inst_SCL
            hps_0_hps_io_hps_io_i2c1_inst_SDA     : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SDA
            hps_0_hps_io_hps_io_i2c1_inst_SCL     : inout std_logic                     := 'X';             -- hps_io_i2c1_inst_SCL
            hps_0_hps_io_hps_io_gpio_inst_GPIO09  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO09
            hps_0_hps_io_hps_io_gpio_inst_GPIO35  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO35
            hps_0_hps_io_hps_io_gpio_inst_GPIO40  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO40
            hps_0_hps_io_hps_io_gpio_inst_GPIO48  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO48
            hps_0_hps_io_hps_io_gpio_inst_GPIO53  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO53
            hps_0_hps_io_hps_io_gpio_inst_GPIO54  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO54
            hps_0_hps_io_hps_io_gpio_inst_GPIO61  : inout std_logic                     := 'X';             -- hps_io_gpio_inst_GPIO61
            memory_mem_a                          : out   std_logic_vector(14 downto 0);                    -- mem_a
            memory_mem_ba                         : out   std_logic_vector(2 downto 0);                     -- mem_ba
            memory_mem_ck                         : out   std_logic;                                        -- mem_ck
            memory_mem_ck_n                       : out   std_logic;                                        -- mem_ck_n
            memory_mem_cke                        : out   std_logic;                                        -- mem_cke
            memory_mem_cs_n                       : out   std_logic;                                        -- mem_cs_n
            memory_mem_ras_n                      : out   std_logic;                                        -- mem_ras_n
            memory_mem_cas_n                      : out   std_logic;                                        -- mem_cas_n
            memory_mem_we_n                       : out   std_logic;                                        -- mem_we_n
            memory_mem_reset_n                    : out   std_logic;                                        -- mem_reset_n
            memory_mem_dq                         : inout std_logic_vector(31 downto 0) := (others => 'X'); -- mem_dq
            memory_mem_dqs                        : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs
            memory_mem_dqs_n                      : inout std_logic_vector(3 downto 0)  := (others => 'X'); -- mem_dqs_n
            memory_mem_odt                        : out   std_logic;                                        -- mem_odt
            memory_mem_dm                         : out   std_logic_vector(3 downto 0);                     -- mem_dm
            memory_oct_rzqin                      : in    std_logic                     := 'X';             -- oct_rzqin
            reset_reset_n                         : in    std_logic                     := 'X';              -- reset_n
				led_external_connection_export        : out   std_logic_vector(9 downto 0);
				multiplier_ina_external_connection_export  : out   std_logic_vector(7 downto 0)  := (others => 'X'); -- export
				multiplier_inb_external_connection_export : out  std_logic_vector(7 downto 0)  := (others => 'X');
            multiplier_out_external_connection_export : in   std_logic_vector(15 downto 0)                    
        );
    end component soc_system;
	
	component hps_reset is
		port (
			probe 		: in std_logic	:= 'X';
			source_clk 	: in std_logic	:= 'X';
			source 		: out std_logic_vector(2 downto 0)
		);
	end component hps_reset;
	
	component altera_edge_detector is
		generic (
			PULSE_EXT 				: integer;
			EDGE_TYPE 				: integer;
			IGNORE_RST_WHILE_BUSY 	: integer
		);
		port (
			clk 		: in std_logic	:= 'X';
			rst_n 		: in std_logic	:= 'X';
			signal_in 	: in std_logic	:= 'X';
			pulse_out 	: out std_logic
		);
	end component altera_edge_detector;
	
--	component led_logic is
--		port (
--			clk: in std_logic;
--			led_bus : out std_logic_vector(9 downto 0)
--		);
--	end component led_logic;
	
	component eightBitMultiplier is
		port(input_a, input_b : in STD_LOGIC_VECTOR(7 downto 0);
			output : out STD_LOGIC_VECTOR(15 downto 0)
		);
	end component eightBitMultiplier;

	
		
	
	
BEGIN

	-------------------------------------------------------
	--    You will need to add a new component here      --
    --       in order to control the LEDR string.        --
    -------------------------------------------------------

	-- connection of internal logics
	stm_hw_events(3 downto 0) <= fpga_debounced_buttons;
	stm_hw_events(13 downto 4) <= fpga_led_internal;
	stm_hw_events(23 downto 14) <= sw;
	stm_hw_events(27 downto 24) <= (OTHERS => '0');
	hps_warm_reset_n <= NOT hps_warm_reset;
	hps_debug_reset_n <= NOT hps_debug_reset;
	hps_cold_reset_n <= NOT hps_cold_reset;

    u0 : component soc_system
        port map (
            clk_clk                               => CLOCK_50,              --                       clk.clk
            reset_reset_n                         => hps_fpga_reset_n,      --                     reset.reset_n
            memory_mem_a                          => HPS_DDR3_ADDR,         --                    memory.mem_a
            memory_mem_ba                         => HPS_DDR3_BA,           --                          .mem_ba
            memory_mem_ck                         => HPS_DDR3_CK_P,         --                          .mem_ck
            memory_mem_ck_n                       => HPS_DDR3_CK_N,         --                          .mem_ck_n
            memory_mem_cke                        => HPS_DDR3_CKE,          --                          .mem_cke
            memory_mem_cs_n                       => HPS_DDR3_CS_N,         --                          .mem_cs_n
            memory_mem_ras_n                      => HPS_DDR3_RAS_N,        --                          .mem_ras_n
            memory_mem_cas_n                      => HPS_DDR3_CAS_N,        --                          .mem_cas_n
            memory_mem_we_n                       => HPS_DDR3_WE_N,         --                          .mem_we_n
            memory_mem_reset_n                    => HPS_DDR3_RESET_N,      --                          .mem_reset_n
            memory_mem_dq                         => HPS_DDR3_DQ,           --                          .mem_dq
            memory_mem_dqs                        => HPS_DDR3_DQS_P,        --                          .mem_dqs
            memory_mem_dqs_n                      => HPS_DDR3_DQS_N,        --                          .mem_dqs_n
            memory_mem_odt                        => HPS_DDR3_ODT,          --                          .mem_odt
            memory_mem_dm                         => HPS_DDR3_DM,           --                          .mem_dm
            memory_oct_rzqin                      => HPS_DDR3_RZQ,          --                          .oct_rzqin
			
            hps_0_hps_io_hps_io_emac1_inst_TX_CLK => HPS_ENET_GTX_CLK, 	    --              hps_0_hps_io.hps_io_emac1_inst_TX_CLK
            hps_0_hps_io_hps_io_emac1_inst_TXD0   => HPS_ENET_TX_DATA(0),   --                          .hps_io_emac1_inst_TXD0
            hps_0_hps_io_hps_io_emac1_inst_TXD1   => HPS_ENET_TX_DATA(1),   --                          .hps_io_emac1_inst_TXD1
            hps_0_hps_io_hps_io_emac1_inst_TXD2   => HPS_ENET_TX_DATA(2),   --                          .hps_io_emac1_inst_TXD2
            hps_0_hps_io_hps_io_emac1_inst_TXD3   => HPS_ENET_TX_DATA(3),   --                          .hps_io_emac1_inst_TXD3
            hps_0_hps_io_hps_io_emac1_inst_RXD0   => HPS_ENET_RX_DATA(0),   --                          .hps_io_emac1_inst_RXD0
            hps_0_hps_io_hps_io_emac1_inst_MDIO   => HPS_ENET_MDIO,         --                          .hps_io_emac1_inst_MDIO
            hps_0_hps_io_hps_io_emac1_inst_MDC    => HPS_ENET_MDC,          --                          .hps_io_emac1_inst_MDC
            hps_0_hps_io_hps_io_emac1_inst_RX_CTL => HPS_ENET_RX_DV,        --                          .hps_io_emac1_inst_RX_CTL
            hps_0_hps_io_hps_io_emac1_inst_TX_CTL => HPS_ENET_TX_EN,        --                          .hps_io_emac1_inst_TX_CTL
            hps_0_hps_io_hps_io_emac1_inst_RX_CLK => HPS_ENET_RX_CLK,       --                          .hps_io_emac1_inst_RX_CLK
            hps_0_hps_io_hps_io_emac1_inst_RXD1   => HPS_ENET_RX_DATA(1),   --                          .hps_io_emac1_inst_RXD1
            hps_0_hps_io_hps_io_emac1_inst_RXD2   => HPS_ENET_RX_DATA(2),   --                          .hps_io_emac1_inst_RXD2
            hps_0_hps_io_hps_io_emac1_inst_RXD3   => HPS_ENET_RX_DATA(3),   --                          .hps_io_emac1_inst_RXD3
			
            hps_0_hps_io_hps_io_qspi_inst_IO0     => HPS_FLASH_DATA(0),     --                          .hps_io_qspi_inst_IO0
            hps_0_hps_io_hps_io_qspi_inst_IO1     => HPS_FLASH_DATA(1),     --                          .hps_io_qspi_inst_IO1
            hps_0_hps_io_hps_io_qspi_inst_IO2     => HPS_FLASH_DATA(2),     --                          .hps_io_qspi_inst_IO2
            hps_0_hps_io_hps_io_qspi_inst_IO3     => HPS_FLASH_DATA(3),     --                          .hps_io_qspi_inst_IO3
            hps_0_hps_io_hps_io_qspi_inst_SS0     => HPS_FLASH_NCSO,        --                          .hps_io_qspi_inst_SS0
            hps_0_hps_io_hps_io_qspi_inst_CLK     => HPS_FLASH_DCLK,        --                          .hps_io_qspi_inst_CLK
			
            hps_0_hps_io_hps_io_sdio_inst_CMD     => HPS_SD_CMD,            --                          .hps_io_sdio_inst_CMD
            hps_0_hps_io_hps_io_sdio_inst_D0      => HPS_SD_DATA(0),        --                          .hps_io_sdio_inst_D0
            hps_0_hps_io_hps_io_sdio_inst_D1      => HPS_SD_DATA(1),        --                          .hps_io_sdio_inst_D1
            hps_0_hps_io_hps_io_sdio_inst_CLK     => HPS_SD_CLK,            --                          .hps_io_sdio_inst_CLK
            hps_0_hps_io_hps_io_sdio_inst_D2      => HPS_SD_DATA(2),        --                          .hps_io_sdio_inst_D2
            hps_0_hps_io_hps_io_sdio_inst_D3      => HPS_SD_DATA(3),        --                          .hps_io_sdio_inst_D3
			
            hps_0_hps_io_hps_io_usb1_inst_D0      => HPS_USB_DATA(0),       --                          .hps_io_usb1_inst_D0
            hps_0_hps_io_hps_io_usb1_inst_D1      => HPS_USB_DATA(1),       --                          .hps_io_usb1_inst_D1
            hps_0_hps_io_hps_io_usb1_inst_D2      => HPS_USB_DATA(2),       --                          .hps_io_usb1_inst_D2
            hps_0_hps_io_hps_io_usb1_inst_D3      => HPS_USB_DATA(3),       --                          .hps_io_usb1_inst_D3
            hps_0_hps_io_hps_io_usb1_inst_D4      => HPS_USB_DATA(4),       --                          .hps_io_usb1_inst_D4
            hps_0_hps_io_hps_io_usb1_inst_D5      => HPS_USB_DATA(5),       --                          .hps_io_usb1_inst_D5
            hps_0_hps_io_hps_io_usb1_inst_D6      => HPS_USB_DATA(6),       --                          .hps_io_usb1_inst_D6
            hps_0_hps_io_hps_io_usb1_inst_D7      => HPS_USB_DATA(7),       --                          .hps_io_usb1_inst_D7
            hps_0_hps_io_hps_io_usb1_inst_CLK     => HPS_USB_CLKOUT,        --                          .hps_io_usb1_inst_CLK
            hps_0_hps_io_hps_io_usb1_inst_STP     => HPS_USB_STP,           --                          .hps_io_usb1_inst_STP
            hps_0_hps_io_hps_io_usb1_inst_DIR     => HPS_USB_DIR,           --                          .hps_io_usb1_inst_DIR
            hps_0_hps_io_hps_io_usb1_inst_NXT     => HPS_USB_NXT,           --                          .hps_io_usb1_inst_NXT
			
            hps_0_hps_io_hps_io_spim1_inst_CLK    => HPS_SPIM_CLK,          --                          .hps_io_spim1_inst_CLK
            hps_0_hps_io_hps_io_spim1_inst_MOSI   => HPS_SPIM_MOSI,         --                          .hps_io_spim1_inst_MOSI
            hps_0_hps_io_hps_io_spim1_inst_MISO   => HPS_SPIM_MISO,         --                          .hps_io_spim1_inst_MISO
            hps_0_hps_io_hps_io_spim1_inst_SS0    => HPS_SPIM_SS,           --                          .hps_io_spim1_inst_SS0
			
            hps_0_hps_io_hps_io_uart0_inst_RX     => HPS_UART_RX,           --                          .hps_io_uart0_inst_RX
            hps_0_hps_io_hps_io_uart0_inst_TX     => HPS_UART_TX,           --                          .hps_io_uart0_inst_TX
			
            hps_0_hps_io_hps_io_i2c0_inst_SDA     => HPS_I2C1_SDAT,         --                          .hps_io_i2c0_inst_SDA
            hps_0_hps_io_hps_io_i2c0_inst_SCL     => HPS_I2C1_SCLK,         --                          .hps_io_i2c0_inst_SCL
			
            hps_0_hps_io_hps_io_i2c1_inst_SDA     => HPS_I2C2_SDAT,         --                          .hps_io_i2c1_inst_SDA
            hps_0_hps_io_hps_io_i2c1_inst_SCL     => HPS_I2C2_SCLK,         --                          .hps_io_i2c1_inst_SCL
			
            hps_0_hps_io_hps_io_gpio_inst_GPIO09  => HPS_CONV_USB_N,        --                          .hps_io_gpio_inst_GPIO09
            hps_0_hps_io_hps_io_gpio_inst_GPIO35  => HPS_ENET_INT_N,        --                          .hps_io_gpio_inst_GPIO35
            hps_0_hps_io_hps_io_gpio_inst_GPIO40  => HPS_LTC_GPIO,          --                          .hps_io_gpio_inst_GPIO40
			
            hps_0_hps_io_hps_io_gpio_inst_GPIO48  => HPS_I2C_CONTROL,       --                          .hps_io_gpio_inst_GPIO48
            hps_0_hps_io_hps_io_gpio_inst_GPIO53  => HPS_LED,               --                          .hps_io_gpio_inst_GPIO53
            hps_0_hps_io_hps_io_gpio_inst_GPIO54  => HPS_KEY,               --                          .hps_io_gpio_inst_GPIO54
            hps_0_hps_io_hps_io_gpio_inst_GPIO61  => HPS_GSENSOR_INT,       --                          .hps_io_gpio_inst_GPIO61
			
            hps_0_h2f_reset_reset_n               => hps_fpga_reset_n,      --           hps_0_h2f_reset.reset_n
            hps_0_f2h_stm_hw_events_stm_hwevents  => stm_hw_events,         --   hps_0_f2h_stm_hw_events.stm_hwevents
            hps_0_f2h_warm_reset_req_reset_n      => hps_warm_reset_n,       --  hps_0_f2h_warm_reset_req.reset_n
            hps_0_f2h_debug_reset_req_reset_n     => hps_debug_reset_n,      -- hps_0_f2h_debug_reset_req.reset_n
            hps_0_f2h_cold_reset_req_reset_n      => hps_cold_reset_n,        --  hps_0_f2h_cold_reset_req.reset_n
				led_external_connection_export        => LEDR,
				multiplier_ina_external_connection_export => multiplier_a_in_sig,
				multiplier_inb_external_connection_export => multiplier_b_in_sig,
				multiplier_out_external_connection_export => multiplier_out_sig
        );
		  
	-- OUR COMPONET IS HEREEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
--	led_control : component led_logic
--	port map (
--			clk => CLOCK_50,
--			led_bus => LEDR
--	);


	eightBitMult_inst : COMPONENT eightBitMultiplier
		PORT MAP (
			input_a => multiplier_a_in_sig,
			input_b => multiplier_b_in_sig,
			output => multiplier_out_sig		
		);
--
--component eightBitMultiplier is
--		port(input_a, input_b : in STD_LOGIC_VECTOR(7 downto 0);
--			output : out STD_LOGIC_VECTOR(15 downto 0)
--		);
--	end component eightBitMultiplier;
--	
  
	-- Source/Probe megawizard instance
	hps_reset_inst : COMPONENT hps_reset 
		PORT MAP (
			source_clk 	=> CLOCK_50,
			source		=> hps_reset_req
		);

	pulse_cold_reset : COMPONENT altera_edge_detector 
		GENERIC MAP (
			PULSE_EXT => 6,
			EDGE_TYPE => 1,
			IGNORE_RST_WHILE_BUSY => 1
		)
		PORT MAP (
			clk 		=> CLOCK_50,
			rst_n		=> hps_fpga_reset_n,
			signal_in	=> hps_reset_req(0),
			pulse_out	=> hps_cold_reset
		);

	pulse_warm_reset : COMPONENT altera_edge_detector 
		GENERIC MAP (
			PULSE_EXT => 2,
			EDGE_TYPE => 1,
			IGNORE_RST_WHILE_BUSY => 1
		)
		PORT MAP (
			clk 		=> CLOCK_50,
			rst_n		=> hps_fpga_reset_n,
			signal_in	=> hps_reset_req(1),
			pulse_out	=> hps_warm_reset
		);
	  
	pulse_debug_reset : COMPONENT altera_edge_detector
		GENERIC MAP (
			PULSE_EXT => 32,
			EDGE_TYPE => 1,
			IGNORE_RST_WHILE_BUSY => 1
		)
		PORT MAP (
			clk 		=> CLOCK_50,
			rst_n		=> hps_fpga_reset_n,
			signal_in	=> hps_reset_req(2),
			pulse_out	=> hps_debug_reset
		);
				
END ARCHITECTURE arch;
