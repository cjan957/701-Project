-- computer_system_f2h_mem_window_ff600000.vhd

-- Generated using ACDS version 16.1 196

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity computer_system_f2h_mem_window_ff600000 is
	generic (
		DATA_WIDTH           : integer                       := 32;
		BYTEENABLE_WIDTH     : integer                       := 4;
		MASTER_ADDRESS_WIDTH : integer                       := 32;
		SLAVE_ADDRESS_WIDTH  : integer                       := 19;
		SLAVE_ADDRESS_SHIFT  : integer                       := 2;
		BURSTCOUNT_WIDTH     : integer                       := 1;
		CNTL_ADDRESS_WIDTH   : integer                       := 1;
		SUB_WINDOW_COUNT     : integer                       := 1;
		MASTER_ADDRESS_DEF   : std_logic_vector(63 downto 0) := "0000000000000000000000000000000011111111011000000000000000000000"
	);
	port (
		clk                  : in  std_logic                     := '0';             --           clock.clk
		reset                : in  std_logic                     := '0';             --           reset.reset
		avs_s0_address       : in  std_logic_vector(18 downto 0) := (others => '0'); --  windowed_slave.address
		avs_s0_read          : in  std_logic                     := '0';             --                .read
		avs_s0_readdata      : out std_logic_vector(31 downto 0);                    --                .readdata
		avs_s0_write         : in  std_logic                     := '0';             --                .write
		avs_s0_writedata     : in  std_logic_vector(31 downto 0) := (others => '0'); --                .writedata
		avs_s0_readdatavalid : out std_logic;                                        --                .readdatavalid
		avs_s0_waitrequest   : out std_logic;                                        --                .waitrequest
		avs_s0_byteenable    : in  std_logic_vector(3 downto 0)  := (others => '0'); --                .byteenable
		avs_s0_burstcount    : in  std_logic_vector(0 downto 0)  := (others => '0'); --                .burstcount
		avm_m0_address       : out std_logic_vector(31 downto 0);                    -- expanded_master.address
		avm_m0_read          : out std_logic;                                        --                .read
		avm_m0_waitrequest   : in  std_logic                     := '0';             --                .waitrequest
		avm_m0_readdata      : in  std_logic_vector(31 downto 0) := (others => '0'); --                .readdata
		avm_m0_write         : out std_logic;                                        --                .write
		avm_m0_writedata     : out std_logic_vector(31 downto 0);                    --                .writedata
		avm_m0_readdatavalid : in  std_logic                     := '0';             --                .readdatavalid
		avm_m0_byteenable    : out std_logic_vector(3 downto 0);                     --                .byteenable
		avm_m0_burstcount    : out std_logic_vector(0 downto 0);                     --                .burstcount
		avs_cntl_address     : in  std_logic_vector(0 downto 0)  := (others => '0');
		avs_cntl_byteenable  : in  std_logic_vector(7 downto 0)  := (others => '0');
		avs_cntl_read        : in  std_logic                     := '0';
		avs_cntl_readdata    : out std_logic_vector(63 downto 0);
		avs_cntl_write       : in  std_logic                     := '0';
		avs_cntl_writedata   : in  std_logic_vector(63 downto 0) := (others => '0')
	);
end entity computer_system_f2h_mem_window_ff600000;

architecture rtl of computer_system_f2h_mem_window_ff600000 is
	component altera_address_span_extender is
		generic (
			DATA_WIDTH           : integer                       := 32;
			BYTEENABLE_WIDTH     : integer                       := 4;
			MASTER_ADDRESS_WIDTH : integer                       := 32;
			SLAVE_ADDRESS_WIDTH  : integer                       := 16;
			SLAVE_ADDRESS_SHIFT  : integer                       := 2;
			BURSTCOUNT_WIDTH     : integer                       := 1;
			CNTL_ADDRESS_WIDTH   : integer                       := 1;
			SUB_WINDOW_COUNT     : integer                       := 1;
			MASTER_ADDRESS_DEF   : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000"
		);
		port (
			clk                  : in  std_logic                     := 'X';             -- clk
			reset                : in  std_logic                     := 'X';             -- reset
			avs_s0_address       : in  std_logic_vector(18 downto 0) := (others => 'X'); -- address
			avs_s0_read          : in  std_logic                     := 'X';             -- read
			avs_s0_readdata      : out std_logic_vector(31 downto 0);                    -- readdata
			avs_s0_write         : in  std_logic                     := 'X';             -- write
			avs_s0_writedata     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			avs_s0_readdatavalid : out std_logic;                                        -- readdatavalid
			avs_s0_waitrequest   : out std_logic;                                        -- waitrequest
			avs_s0_byteenable    : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			avs_s0_burstcount    : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- burstcount
			avm_m0_address       : out std_logic_vector(31 downto 0);                    -- address
			avm_m0_read          : out std_logic;                                        -- read
			avm_m0_waitrequest   : in  std_logic                     := 'X';             -- waitrequest
			avm_m0_readdata      : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			avm_m0_write         : out std_logic;                                        -- write
			avm_m0_writedata     : out std_logic_vector(31 downto 0);                    -- writedata
			avm_m0_readdatavalid : in  std_logic                     := 'X';             -- readdatavalid
			avm_m0_byteenable    : out std_logic_vector(3 downto 0);                     -- byteenable
			avm_m0_burstcount    : out std_logic_vector(0 downto 0);                     -- burstcount
			avs_cntl_address     : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- address
			avs_cntl_read        : in  std_logic                     := 'X';             -- read
			avs_cntl_readdata    : out std_logic_vector(63 downto 0);                    -- readdata
			avs_cntl_write       : in  std_logic                     := 'X';             -- write
			avs_cntl_writedata   : in  std_logic_vector(63 downto 0) := (others => 'X'); -- writedata
			avs_cntl_byteenable  : in  std_logic_vector(7 downto 0)  := (others => 'X')  -- byteenable
		);
	end component altera_address_span_extender;

begin

	data_width_check : if DATA_WIDTH /= 32 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	byteenable_width_check : if BYTEENABLE_WIDTH /= 4 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	master_address_width_check : if MASTER_ADDRESS_WIDTH /= 32 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	slave_address_width_check : if SLAVE_ADDRESS_WIDTH /= 19 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	slave_address_shift_check : if SLAVE_ADDRESS_SHIFT /= 2 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	burstcount_width_check : if BURSTCOUNT_WIDTH /= 1 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	cntl_address_width_check : if CNTL_ADDRESS_WIDTH /= 1 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	sub_window_count_check : if SUB_WINDOW_COUNT /= 1 generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	master_address_def_check : if MASTER_ADDRESS_DEF /= "0000000000000000000000000000000011111111011000000000000000000000" generate
		assert false report "Supplied generics do not match expected generics" severity Failure;
	end generate;

	f2h_mem_window_ff600000 : component altera_address_span_extender
		generic map (
			DATA_WIDTH           => 32,
			BYTEENABLE_WIDTH     => 4,
			MASTER_ADDRESS_WIDTH => 32,
			SLAVE_ADDRESS_WIDTH  => 19,
			SLAVE_ADDRESS_SHIFT  => 2,
			BURSTCOUNT_WIDTH     => 1,
			CNTL_ADDRESS_WIDTH   => 1,
			SUB_WINDOW_COUNT     => 1,
			MASTER_ADDRESS_DEF   => "0000000000000000000000000000000011111111011000000000000000000000"
		)
		port map (
			clk                  => clk,                                                                --           clock.clk
			reset                => reset,                                                              --           reset.reset
			avs_s0_address       => avs_s0_address,                                                     --  windowed_slave.address
			avs_s0_read          => avs_s0_read,                                                        --                .read
			avs_s0_readdata      => avs_s0_readdata,                                                    --                .readdata
			avs_s0_write         => avs_s0_write,                                                       --                .write
			avs_s0_writedata     => avs_s0_writedata,                                                   --                .writedata
			avs_s0_readdatavalid => avs_s0_readdatavalid,                                               --                .readdatavalid
			avs_s0_waitrequest   => avs_s0_waitrequest,                                                 --                .waitrequest
			avs_s0_byteenable    => avs_s0_byteenable,                                                  --                .byteenable
			avs_s0_burstcount    => avs_s0_burstcount,                                                  --                .burstcount
			avm_m0_address       => avm_m0_address,                                                     -- expanded_master.address
			avm_m0_read          => avm_m0_read,                                                        --                .read
			avm_m0_waitrequest   => avm_m0_waitrequest,                                                 --                .waitrequest
			avm_m0_readdata      => avm_m0_readdata,                                                    --                .readdata
			avm_m0_write         => avm_m0_write,                                                       --                .write
			avm_m0_writedata     => avm_m0_writedata,                                                   --                .writedata
			avm_m0_readdatavalid => avm_m0_readdatavalid,                                               --                .readdatavalid
			avm_m0_byteenable    => avm_m0_byteenable,                                                  --                .byteenable
			avm_m0_burstcount    => avm_m0_burstcount,                                                  --                .burstcount
			avs_cntl_address     => "0",                                                                --     (terminated)
			avs_cntl_read        => '0',                                                                --     (terminated)
			avs_cntl_readdata    => open,                                                               --     (terminated)
			avs_cntl_write       => '0',                                                                --     (terminated)
			avs_cntl_writedata   => "0000000000000000000000000000000000000000000000000000000000000000", --     (terminated)
			avs_cntl_byteenable  => "00000000"                                                          --     (terminated)
		);

end architecture rtl; -- of computer_system_f2h_mem_window_ff600000
