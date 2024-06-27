
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Double_Adder_tb is
end Double_Adder_tb;

architecture sim of Double_Adder_tb is

    component Double_Adder is 
        port(
            Reset										: in 		std_logic;			
            Clock										: in 		std_logic;
            Data_In1									: in 		std_logic_vector( 63 downto 0 );
            Data_In2									: in 		std_logic_vector( 63 downto 0 );
            Sum_Out									    : out 	    std_logic_vector( 63 downto 0 );
		    Valid										: buffer    std_logic;
            debug_A_e									: out		std_logic_vector( 10 downto 0 );
            debug_B_e									: out		std_logic_vector( 10 downto 0 );
            debug_A_f2									: out		std_logic_vector( 52 downto 0 );
            debug_B_f2									: out		std_logic_vector( 52 downto 0 );
            debug_Y_f									: out		std_logic_vector( 53 downto 0 );
            debug_count								    : out		std_logic_vector( 3 downto 0 )
        );
    end component;

    constant clk_hz : integer := 100e6;
    constant clk_period : time := 1 sec / clk_hz;

    signal clk : std_logic := '1';
    signal rst : std_logic := '1';

    signal data_A   : std_logic_vector( 63 downto 0 );
    signal data_B   : std_logic_vector( 63 downto 0 );
    signal data_Y   : std_logic_vector( 63 downto 0 );

    signal valid : std_logic;

    signal A_e   : std_logic_vector( 10 downto 0 );
    signal B_e   : std_logic_vector( 10 downto 0 );

    signal A_f2   : std_logic_vector( 52 downto 0 );
    signal B_f2   : std_logic_vector( 52 downto 0 );
    signal Y_f    : std_logic_vector( 53 downto 0 );
    signal count  : std_logic_vector( 3 downto 0 );


begin

    clk <= not clk after clk_period / 2;

    DUT : Double_Adder 
    port map (
        Reset => rst,
        Clock => clk,
        Data_In1 => data_A,
        Data_In2 => data_B,
        Sum_Out => data_Y,
        Valid => valid,
        debug_A_e => A_e,
        debug_B_e => B_e,
        debug_A_f2 => A_f2,
        debug_B_f2 => B_f2,
        debug_Y_f => Y_f,
        debug_count => count

    );

    SEQUENCER_PROC : process
    begin
        --Reset moudle
        rst <= '1';
        wait for clk_period * 10;--100ns
        

        data_A <= "0011111110101110100111110011011001001001100110111111011011010011";
        data_B <= "0011111101111011101101110111000101010101000111111011001111111100"; 
        
        wait for clk_period * 1;--10ns
        rst <= '0';

        wait for clk_period * 50;

        --Reset moudle
        rst <= '1';
        wait for clk_period * 10;--100ns
        

        data_A <= "0011111101111011101101110111000101010101000111111011001111111100";
        data_B <= "0011111110110100011111100111010111100101100011111110000010011101"; 
        
        wait for clk_period * 1;--10ns
        rst <= '0';

        wait for clk_period * 50;

        --Reset moudle
        rst <= '1';
        wait for clk_period * 10;--100ns
        

        data_A <= "0011111110110100011111100111010111100101100011111110000010011101";
        data_B <= "0011111110111110010000000011011001011010011101000001101110001100"; 
        
        wait for clk_period * 1;--10ns
        rst <= '0';

        wait for clk_period * 50;


        --Reset moudle
        rst <= '1';
        wait for clk_period * 10;--100ns
        

        data_A <= "0011111110111110010000000011011001011010011101000001101110001100";
        data_B <= "0011111110011011101011110101011001011100100101010111011101111011"; 
        
        wait for clk_period * 1;--10ns
        rst <= '0';

        wait for clk_period * 50;

        --Reset moudle
        rst <= '1';
        wait for clk_period * 10;--100ns
        

        data_A <= "0011111110011011101011110101011001011100100101010111011101111011";
        data_B <= "0011111101110101100100011011001001010011101010011100001000011110"; 
        
        wait for clk_period * 1;--10ns
        rst <= '0';

        wait for clk_period * 50;

        --Reset moudle
        rst <= '1';
        wait for clk_period * 10;--100ns
        

        data_A <= "0011111101110101100100011011001001010011101010011100001000011110";
        data_B <= "0011111110101010011110001000111101001011111011000101110110001011"; 
        
        wait for clk_period * 1;--10ns
        rst <= '0';

        wait for clk_period * 50;

        wait for clk_period * 10;
        wait;

    end process;

end architecture;

