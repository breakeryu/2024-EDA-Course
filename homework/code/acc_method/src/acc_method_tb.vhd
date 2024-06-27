
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use std.env.finish;

entity acc_method_tb is
end acc_method_tb;

architecture sim of acc_method_tb is

    constant clk_hz : integer := 100e6;
    constant clk_period : time := 1 sec / clk_hz;

    signal clk : std_logic := '1';
    signal rst : std_logic := '0';
    signal Result_Valid : std_logic;
    signal acc_result : std_logic_vector (63 DOWNTO 0);
    signal acc_result_tm : std_logic_vector (63 DOWNTO 0);
    signal sclk_count : std_logic_vector (5 DOWNTO 0);
    signal debug_rom_address : std_logic_vector (12 DOWNTO 0);
    signal debug_rom_out_data : std_logic_vector (63 DOWNTO 0);
    signal debug_d1 : std_logic_vector (63 DOWNTO 0);
    signal debug_d2 : std_logic_vector (63 DOWNTO 0);


    component acc_method
        port(
                Clock										: in 		std_logic;
                Reset										: in 		std_logic;
                Result_Valid	                            : buffer    std_logic;
                acc_result                                  : out       std_logic_vector (63 DOWNTO 0);
                acc_result_tm                               : out       std_logic_vector (63 DOWNTO 0);
                sclk_count                                  : out       std_logic_vector (5 DOWNTO 0);
                debug_rom_address                           : out       std_logic_vector (12 DOWNTO 0);
                debug_rom_out_data                          : out       std_logic_vector (63 DOWNTO 0);
                debug_d1                                    : out       std_logic_vector (63 DOWNTO 0);
                debug_d2                                    : out       std_logic_vector (63 DOWNTO 0)
        );
    end component;

begin

    clk <= not clk after clk_period / 2;

    DUT : acc_method
        port map (
            Clock => clk,
            Reset => rst,
            Result_Valid => Result_Valid,
            acc_result => acc_result,
            acc_result_tm => acc_result_tm,
            sclk_count => sclk_count,
            debug_rom_address => debug_rom_address,
            debug_rom_out_data => debug_rom_out_data,
            debug_d1 => debug_d1,
            debug_d2 => debug_d2

        );

    SEQUENCER_PROC : process
    begin
        wait for clk_period * 2;

        rst <= '1';


        
        wait;

    end process;

end architecture;




