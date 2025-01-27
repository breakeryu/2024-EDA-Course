
--Library Declaration

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


--entity

entity Double_Adder is
    port(
			Reset									: in 		std_logic;			
			Clock									: in 		std_logic;
			Data_In1								: in 		std_logic_vector( 63 downto 0 );
			Data_In2								: in 		std_logic_vector( 63 downto 0 );
			Sum_Out									: out 	    std_logic_vector( 63 downto 0 );
			Valid									: buffer    std_logic;
			debug_A_e								: out		std_logic_vector( 10 downto 0 );
			debug_B_e								: out		std_logic_vector( 10 downto 0 );

			debug_A_f2								: out		std_logic_vector( 52 downto 0 );
			debug_B_f2								: out		std_logic_vector( 52 downto 0 );
			debug_Y_f								: out		std_logic_vector( 53 downto 0 );
			debug_count								: out		std_logic_vector( 3 downto 0 )
    );
    
end entity;


--architecture

architecture behavioral of Double_Adder is 

    signal 			A_e,B_e,Y_e				        				: std_logic_vector( 10 downto 0 );
    signal 			Y												: std_logic_vector( 63 downto 0 );
    signal 			A_f,B_f,Y_fn									: std_logic_vector( 51 downto 0 );
    signal 			A_f2,B_f2,B_f1						        	: std_logic_vector( 52 downto 0 );
    signal 			Y_f											    : std_logic_vector( 53 downto 0 );
    signal 			A_s,B_s,Y_s		            					: std_logic;

begin

    process(Reset,Clock)	

        variable	clock_count							: integer range 0 to 10;
        variable	N,symbol							: integer;
    
    begin

        if(Reset='1') then

			clock_count := 0;

			A_e <= ( others=>'0' );	
			B_e <= ( others=>'0' );	
			A_f <= ( others=>'0' );	
			B_f <= ( others=>'0' );	
			A_s <= '0';
			B_s <= '0';
				
			A_f2 <= ( others=>'0' );			
			B_f1 <= ( others=>'0' );		
			B_f2 <= ( others=>'0' );		

			Y_fn <= ( others=>'0' );
				
			Y_e <= ( others=>'0' );	
			Y_f <= ( others=>'0' );
			Y_s <= '0';

			N := 0; 	
			symbol := 0;				
			Y <= ( others=>'0' );
			Sum_Out <= ( others=>'0' );
			Valid <= '0';			
			
			debug_A_e <= ( others=>'0' );
			debug_B_e <= ( others=>'0' );
			
			debug_A_f2 <= ( others=>'0' );
			debug_B_f2 <= ( others=>'0' );
			debug_Y_f  <= ( others=>'0' );
			debug_count <= ( others=>'0' );

		elsif(rising_edge(Clock) and Valid = '0') then
            clock_count := clock_count + 1;
			debug_count <= conv_std_logic_vector(clock_count,4);

			case clock_count is
                
                -- CLock 1 : Make that A is always bigger than B
				when 1 =>
					if Data_In1( 62 downto 52 ) > Data_In2( 62 downto 52 ) then
						A_e <= Data_In1( 62 downto 52 );
						B_e <= Data_In2( 62 downto 52 );
						A_f <= Data_In1( 51 downto 0 );
						B_f <= Data_In2( 51 downto 0 );
						A_s <= Data_In1( 63 );
						B_s <= Data_In2( 63 );
					else
						A_e <= Data_In2( 62 downto 52 );
						B_e <= Data_In1( 62 downto 52 );
						A_f <= Data_In2( 51 downto 0 );
						B_f <= Data_In1( 51 downto 0 );
						A_s <= Data_In2( 63 );
						B_s <= Data_In1( 63 );
					end if;

                -- Clock 2: Makt that Exp_diff is recognized
				--			Get Y_s
				--			Calculate a_f' and b_f'
				when 2 =>	
					debug_A_e <= A_e;
					debug_B_e <= B_e;

					if A_s = B_s then
						Y_s <= A_s;
						Y_e <= A_e;
						A_f2 <= "1" & A_f;
						if  unsigned( A_e ) = unsigned( B_e ) then
							N := 0;
						else
							N := conv_integer( A_e - B_e );	
						end if;
					else
						clock_count := 0;
					end if;
					

                -- without regard to overfolws
                
                -- Clock 3: Add b_f' and a_f'
				when 3 =>
					B_f2 <= to_stdlogicvector( to_bitvector( "1" & B_f ) SRL N );
					
				when 4 =>
					debug_A_f2 <= A_f2;
					debug_B_f2 <= B_f2;
					Y_f <= "0" & A_f2 + B_f2;
				
				-- Clock 5: Get Y_fn
				when 5 =>
					debug_Y_f <= Y_f;
					if (Y_f( 53 downto 0 )="000000000000000000000000000000000000000000000000000000") then
						Y <= ( others=>'0' );
					else
						if Y_f(53) = '1' then
							Y_e <= Y_e + 1;
							Y_fn <= Y_f( 52 downto 1 );
							symbol := 1;
						else
							Y_fn <= Y_f( 51 downto 0 );
							symbol := 0;
						end if;
					end if;

				-- Clock 6: round Y_fn and output Y
				when 6 =>
					if symbol > 0  then
						if Y_f(0) = '1' then
							Y_fn <= Y_fn + 1;
						end if ;
					end if ;

					-- Y( 51 downto 0 ) <= Y_fn;
					-- Y( 62 downto 52 ) <= Y_e;
					-- Y( 63 ) <= Y_s;
					Y <= Y_s & Y_e( 10 downto 0 ) & Y_fn( 51 downto 0 );

				when 7 =>
					Sum_Out <= Y;
					

				when others => 
					clock_count := 0;
					Valid <= '1';

			end case;				

		end if;		
    end process;


end behavioral;
