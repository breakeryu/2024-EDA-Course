library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;
    use ieee.std_logic_unsigned.all;
    use ieee.std_logic_arith.all;
    use std.textio.all;

entity acc_method is
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
            
        ) ;
end entity ; 

architecture arch of acc_method is

-- signal 

    -- signal of rom
    signal rom_address      :       STD_LOGIC_VECTOR (12 DOWNTO 0);
    signal rom_out_data     :       STD_LOGIC_VECTOR (63 DOWNTO 0);

    -- signal of double adder
    signal adder_reset          :       STD_LOGIC   :=  '1'; 
    signal adder_Data_In1       :       STD_LOGIC_VECTOR (63 DOWNTO 0);
    signal adder_Data_In2       :       STD_LOGIC_VECTOR (63 DOWNTO 0);
    signal adder_Sum_Out        :       STD_LOGIC_VECTOR (63 DOWNTO 0);
    signal adder_Valid          :       STD_LOGIC   :=  '0';
    signal adder_Sum_Out_RE     :       STD_LOGIC_VECTOR (63 DOWNTO 0);

    signal    pluse_number      : integer range 0 to 10;

    -- output 8 pluse average
    signal 			acc_result_e				        		: std_logic_vector( 10 downto 0 );
    signal 			acc_result_f						        : std_logic_vector( 51 downto 0 );
    signal 			acc_result_s		            			: std_logic;

    -- Enumerated type declaration and state signal declaration
    type t_State is (Init_Adder, Adder_P1, Adder_P2, Adder_P3, Adder_P4);
    signal State : t_State;

    type c_State is (Init_Adder, Adder_P1, Adder_P2);
    signal State_c : c_State;

-- component
    
    -- Source Data Rom component
    component Rom_Src_Data
        port(
                address		: in    std_logic_vector (12 DOWNTO 0);
                clock		: in    std_logic  := '1';
                q		    : out   std_logic_vector (63 DOWNTO 0)
        );
    end component;

    -- IEEE 754 Double Adder component
    component Double_Adder
        port(
                Reset									: in 		std_logic;			
                Clock									: in 		std_logic;
                Data_In1								: in 		std_logic_vector( 63 downto 0 );
                Data_In2								: in 		std_logic_vector( 63 downto 0 );
                Sum_Out									: out 	    std_logic_vector( 63 downto 0 );
                Valid									: buffer    std_logic
        );
    end component;

--begin acc_method architecture
begin

    --Instantiate the compomemt :   Rom_Src_Data
    m_Rom_Src_Data: Rom_Src_Data
        port map(
                    address => rom_address,
                    clock   => Clock,
                    q		=> rom_out_data
        );

    --Instantiate the compomemt :   Double_Adder
    m_Double_Adder: Double_Adder
        port map(
                Reset		    => adder_reset,			
                Clock		    => Clock,
                Data_In1        => adder_Data_In1,
                Data_In2	    => adder_Data_In2,
                Sum_Out		    => adder_Sum_Out,
                Valid		    => adder_Valid			
        );

   
    process(Reset, Clock, adder_Valid) is

        constant	addr_incr_constant_1000			    : std_logic_vector (12 DOWNTO 0) := "0001111101000";
        
        variable	addr_count							: integer range 0 to 1000;
        variable    pluse_number                        : integer range 0 to 10;
        variable    rom_wait_clk                        : integer range 0 to 10;
        variable    clk_count                           : integer range 0 to 20;

        begin
            if rising_edge(Clock) then
                if Reset = '0' then
                    -- Reset values
                    State           <= Init_Adder;

                    rom_address     <= std_logic_vector(to_unsigned(addr_count, rom_address'length));

                    -- rom_out_data_RE <= ( others=>'0' );

                    adder_reset     <= '1';
                    adder_Data_In1  <= ( others=>'0' );
                    adder_Data_In2  <= ( others=>'0' );

                    adder_Sum_Out_RE <= ( others=>'0' );

                    Result_Valid <= '0';

                    addr_count := 0;
                    clk_count := 0;
                    rom_wait_clk := 0;
                else
                    
                    debug_rom_address <= rom_address;
                    debug_rom_out_data <= rom_out_data;
                    sclk_count <= std_logic_vector(to_unsigned(clk_count, sclk_count'length));
                    case State is
                        -- 
                        when Init_Adder =>
                            rom_wait_clk := rom_wait_clk + 1;
                            Result_Valid <= '0';
                            if adder_Valid = '0' and rom_wait_clk > 1 then
                                adder_Data_In1  <= adder_Sum_Out_RE;
                                adder_Data_In2  <= rom_out_data;
                                debug_d1 <= adder_Sum_Out_RE;
                                debug_d2 <= rom_out_data;
                                adder_reset     <= '0';
                                State   <= Adder_P1;
                                clk_count := clk_count + 1;
                                rom_wait_clk := 0;
                            end if;
                        -- 
                        when Adder_P1 =>
                            
                            if adder_Valid = '1' then
                                if clk_count < 8 then
                                    rom_address <= rom_address + addr_incr_constant_1000;
                                end if ;
                                adder_Sum_Out_RE <= adder_Sum_Out;
                                acc_result_tm <= adder_Sum_Out;
                                pluse_number := pluse_number + 1;
                                State   <= Adder_P2;
                            end if ;

                        -- 
                        when Adder_P2 =>
                            
                            if pluse_number >= 8 then    -- next point
                                addr_count := addr_count + 1;
                                pluse_number := 0;

                                acc_result_e <= adder_Sum_Out_RE( 62 downto 52 );
                                acc_result_f <= adder_Sum_Out_RE( 51 downto 0 );
                                acc_result_s <= adder_Sum_Out_RE( 63 );

                                State   <= Adder_P3;
                                -- rom_out_data_RE <= rom_out_data;
                            else
                                State   <= Init_Adder;
                                -- rom_out_data_RE <= rom_out_data;
                            end if ;
                            adder_reset     <= '1';
                        -- 
                        when Adder_P3 =>
                            if addr_count < 1000 then
                                rom_address     <= std_logic_vector(to_unsigned(addr_count, rom_address'length));
                            end if;

                            adder_Sum_Out_RE <= ( others=>'0' );
                            acc_result_e <= acc_result_e - 3;
                            clk_count := 0;
                            State   <= Adder_P4;

                        when Adder_P4 =>
                            acc_result <= acc_result_s & acc_result_e( 10 downto 0 ) & acc_result_f( 51 downto 0 );
                            Result_Valid <= '1';
                            if addr_count <= 999 then
                                State   <= Init_Adder;
                            elsif addr_count >= 1000 then
                                clk_count := 0;
                            end if;

                    end case;
                
                end if;
            end if;
    end process;
    
end architecture ;--end acc_method architecture




