OutRomData: process(Clock) is

    constant	addr_incr_constant_1000			    : std_logic_vector (12 DOWNTO 0) := "0001111101000";
    
    variable	addr_count							: integer range 0 to 1000;
    

begin
    if rising_edge(Clock) then
        if Reset = '0' then
            -- Reset values
            State_t           <= Init_Adder;

            rom_address     <= std_logic_vector(to_unsigned(addr_count, rom_address'length));
            --rom_out_data    <= ( others=>'0' );

            Result_Valid <= '0';

            addr_count := 0;
            
            adder_Valid_RE <= '0';
        else

            case State_t is

                -- out number
                when Init_Adder =>
                    State_t   <= Adder_P1;

                -- next number
                when Adder_P1 =>
                    
                    if adder_Valid_RE = '1' then
                        rom_address     <= rom_address + addr_incr_constant_1000;
                        pluse_number <= pluse_number + 1;
                        State_t   <= Adder_P2;
                    end if ;

                -- 
                when Adder_P2 =>
                    if pluse_number > 8 then    -- next point
                        addr_count := addr_count + 1;
                        State_t   <= Adder_P3;
                    else
                        State_t   <= Init_Adder;
                    end if ;
                    
                -- 
                when Adder_P3 =>
                    if addr_count < 1000 then
                        rom_address     <= std_logic_vector(to_unsigned(addr_count, rom_address'length));
                        State_t   <= Init_Adder;
                    else
                        Result_Valid <= '1';
                    end if ;
            end case;

        end if;
    end if;
end process;



adderAll: process(Clock) is

    begin
        if rising_edge(Clock) then
            if Reset = '0' then
                -- Reset values
                State_c           <= Init_Adder;

                adder_reset     <= '1';
                adder_Data_In1  <= ( others=>'0' );
                adder_Data_In2  <= ( others=>'0' );
                adder_Sum_Out   <= ( others=>'0' );
                adder_Valid     <= '0';	
                
            else

                case State_c is

                    -- 
                    when Init_Adder =>

                        adder_Data_In1  <= rom_out_data;
                        adder_Data_In2  <= adder_Sum_Out;
                        adder_reset     <= '0';
                        State_c   <= Adder_P1;

                    -- 
                    when Adder_P1 =>
                        
                        if adder_Valid = '1' then
                            adder_reset     <= '1';
                            State_c   <= Adder_P2;
                        end if ;
 
                    -- 
                    when Adder_P2 =>
                        
                        if pluse_number > 8 then    -- next point
                            acc_result <= ( others=>'0' );
                        else
                            State_c   <= Init_Adder;
                        end if ;
                end case;

            end if;
        end if;
    end process;


-- process(Clock) is

--     constant	addr_incr_constant_1000			    : std_logic_vector (12 DOWNTO 0) := "0001111101000";
    
--     variable	addr_count							: integer range 0 to 1000;
--     variable    pluse_number                        : integer range 0 to 10;

--     begin
--         if rising_edge(Clock) then
--             if Reset = '0' then
--                 -- Reset values
--                 State           <= Init_Adder;

--                 rom_address     <= std_logic_vector(to_unsigned(addr_count, rom_address'length));
--                 rom_out_data    <= ( others=>'0' );
--                 rom_out_data_RE <= ( others=>'0' );

--                 adder_reset     <= '1';
--                 adder_Data_In1  <= ( others=>'0' );
--                 adder_Data_In2  <= ( others=>'0' );
--                 adder_Sum_Out   <= ( others=>'0' );
--                 adder_Valid     <= '0';	
                
--                 adder_Sum_Out_RE <= ( others=>'0' );

--                 Result_Valid <= '0';

--                 addr_count := 0;

--             else

--                 case State is

--                     -- 
--                     when Init_Adder =>
--                         adder_Data_In1  <= adder_Sum_Out_RE;
--                         adder_Data_In2  <= rom_out_data_RE;
--                         adder_reset     <= '0';
--                         State   <= Adder_P1;

--                     -- 
--                     when Adder_P1 =>
                        
--                         if adder_Valid = '1' then
--                             rom_address     <= rom_address + addr_incr_constant_1000;
--                             adder_reset     <= '1';
--                             adder_Sum_Out_RE <= adder_Sum_Out;
--                             pluse_number := pluse_number + 1;
--                             State   <= Adder_P2;
--                         end if ;

--                     -- 
--                     when Adder_P2 =>
--                         if pluse_number > 8 then    -- next point
--                             addr_count := addr_count + 1;
--                             acc_result <= adder_Sum_Out_RE;
--                             State   <= Adder_P3;
--                             rom_out_data_RE <= rom_out_data;
--                         else
--                             State   <= Init_Adder;
--                             rom_out_data_RE <= rom_out_data;
--                         end if ;
                        
--                     -- 
--                     when Adder_P3 =>
--                         if addr_count < 1000 then
--                             rom_address     <= std_logic_vector(to_unsigned(addr_count, rom_address'length));
--                             State   <= Init_Adder;
--                         else
--                             Result_Valid <= '1';
--                         end if ;
                        
--                 end case;

--             end if;
--         end if;
-- end process;



----------------------------------



OutRomData: process(Clock) is

    constant	addr_incr_constant_1000			    : std_logic_vector (12 DOWNTO 0) := "0001111101000";
    
    variable	addr_count							: integer range 0 to 1000;
    

begin
    if rising_edge(Clock) then
        if Reset = '0' then
            -- Reset values
            State_t           <= Init_Adder;

            rom_address     <= std_logic_vector(to_unsigned(addr_count, rom_address'length));
            --rom_out_data    <= ( others=>'0' );

            Result_Valid <= '0';

            addr_count := 0;
            
            -- adder_Valid_RE <= '0';
        else

            case State_t is

                -- out number
                when Init_Adder =>
                    State_t   <= Adder_P1;

                -- next number
                when Adder_P1 =>
                    
                    if adder_Valid_RE = '1' then
                        rom_address     <= rom_address + addr_incr_constant_1000;
                        pluse_number <= pluse_number + 1;
                        State_t   <= Adder_P2;
                    end if ;

                -- 
                when Adder_P2 =>
                    if pluse_number > 8 then    -- next point
                        addr_count := addr_count + 1;
                        State_t   <= Adder_P3;
                    else
                        State_t   <= Init_Adder;
                    end if ;
                    
                -- 
                when Adder_P3 =>
                    if addr_count < 1000 then
                        rom_address     <= std_logic_vector(to_unsigned(addr_count, rom_address'length));
                        State_t   <= Init_Adder;
                    else
                        Result_Valid <= '1';
                    end if ;
            end case;

        end if;
    end if;
end process;



adderAll: process(Clock) is

    variable	sign_flag							: integer range 0 to 8;

    begin
        if rising_edge(Clock) then
            if Reset = '0' then
                -- Reset values
                State_c           <= Init_Adder;

                adder_reset     <= '1';
                adder_Data_In1  <= ( others=>'0' );
                adder_Data_In2  <= ( others=>'0' );
                -- adder_Sum_Out   <= ( others=>'0' );
                -- adder_Valid     <= '0';	
                
                sign_flag := 0;

            else
                
                adder_Valid_RE <= adder_Valid;
                case State_c is

                    -- 
                    when Init_Adder =>
                        
                        if sign_flag = 0 then
                            adder_Data_In1  <= rom_out_data;
                            adder_Data_In2  <= adder_Sum_Out_RE;
                            adder_reset     <= '0';
                            sign_flag := sign_flag + 1;
                            State_c   <= Adder_P1;
                        end if;
                    -- 
                    when Adder_P1 =>
                        
                        if adder_Valid = '1' then
                            adder_Sum_Out_RE <= adder_Sum_Out;
                            State_c   <= Adder_P2;
                        end if ;
    
                    -- 
                    when Adder_P2 =>
                        adder_reset     <= '1';
                        if pluse_number > 8 then    -- next point
                            acc_result <= ( others=>'0' );
                        else
                            sign_flag := 0;
                            State_c   <= Init_Adder;
                        end if ;
                end case;

            end if;
        end if;
    end process;


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
