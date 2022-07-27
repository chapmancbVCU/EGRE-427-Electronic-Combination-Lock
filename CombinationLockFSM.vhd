----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:34:42 02/12/2010 
-- Design Name: 
-- Module Name:    CombinationLockFSM - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
LiBRARY IEEE;
USE work.ALL;
USE IEEE.std_logic_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CombinationLockFSM is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  buttons : in STD_LOGIC_VECTOR(3 downto 0);
           led_out : out  STD_LOGIC_VECTOR (3 downto 0));
end CombinationLockFSM;

architecture Behavioral of CombinationLockFSM is

	-- Type for Q: Non-empty finite set called states.
	TYPE Q_STATES is (Right1_P, Right2_P, Right3_P, Right4_P, 
							Right1_R, Right2_R, Right3_R, 
							Wrong1_P, Wrong2_P, Wrong3_P, Wrong4_P, 
							Wrong1_R, Wrong2_R, Wrong3_R, 
							LOCKED, UNLOCKED, ERROR, 
							S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, 
							S11, S12, S13, S14, S15, S16, S17, S18,
							S19, DONE);
	ATTRIBUTE enum_encoding : STRING;					
	TYPE STATUS IS (IS_LOCKED, IS_UNLOCKED, INCORRECT);
	SIGNAL PRESENT_STATE, NEXT_STATE : Q_STATES;
	SIGNAL CURRENT, NEW_STATUS : STATUS;
	ATTRIBUTE enum_encoding of STATUS : TYPE IS "00 01 10";
	CONSTANT delay : time := 1000 ms;

begin
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
	process (clk, reset)
	begin
		if(reset = '1') then
			PRESENT_STATE <= LOCKED;
			CURRENT <= IS_LOCKED;
		elsif(clk'event and clk = '1') then
			PRESENT_STATE <= NEXT_STATE;
			CURRENT <= NEW_STATUS;
		end if;
	end process;

----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
	Transition_Function : process(PRESENT_STATE, CURRENT, buttons)
	begin
		CASE PRESENT_STATE is
			-- When we are in the LOCKED state
			when LOCKED =>
				NEW_STATUS <= IS_LOCKED;
				if buttons(3) = '1' then
					NEXT_STATE <= Right1_P;
				elsif (buttons(2) = '1' or buttons(1) = '1' or buttons(0) = '1') then
					NEXT_STATE <= Wrong1_P;
				else 
					NEXT_STATE <= LOCKED;
				end if;
			
			-- When the first button pressed is correct
			when Right1_P =>
				if buttons(3) = '1' then
					NEXT_STATE <= Right1_P;
				elsif buttons(3) = '0' then 
					NEXT_STATE <= Right1_R;
				else 	
					NEXT_STATE <= Right1_P;
				end if;
				
			-- When the first correct button is released
			when Right1_R =>
				if buttons(1) = '0' then
					NEXT_STATE <= Right2_P;
				elsif (buttons(3) = '1' or buttons(2) = '1' or buttons(0) = '1') then
					NEXT_STATE <= Wrong2_P;
				elsif buttons(3) = '0' and buttons(2) = '0' and buttons(1) = '0' and buttons(0) = '0' then 
					NEXT_STATE <= Right1_R;
				else 
					NEXT_STATE <= Right1_R;
				end if;
				
			-- When the second button pressed is correct		
			when Right2_P =>
				if buttons(1) = '1' then
					NEXT_STATE <= Right2_P;
				elsif buttons(1) = '0'  then
					NEXT_STATE <= Right2_R;
				else 
					NEXT_STATE <= Right2_P;
				end if;
				
			-- When the second correct button is released
			when Right2_R =>
				if (buttons(0) = '1') then
					NEXT_STATE <= Right3_P;
				elsif buttons(3) = '1' or buttons(2) = '1' or buttons(1) = '1' then
					NEXT_STATE <= Wrong3_P;
				elsif buttons(3) = '0' and buttons(2) = '0' and buttons(1) = '0' and buttons(0) = '0' then
					NEXT_STATE <= Right2_R;
				else	
					NEXT_STATE <= Right2_R;
				end if;
			
			-- When the third button pressed is correct		
			when Right3_P =>
				if buttons(0) = '1' then
					NEXT_STATE <= Right3_P;
				elsif buttons(0) = '0' then
					NEXT_STATE <= Right3_R;
				else 
					NEXT_STATE <= Right3_P;
				end if;
				
			-- When the third correct button is released
			when Right3_R =>
				if buttons(2) = '1' then
					NEXT_STATE <= Right4_P;
				elsif buttons(3) = '1' or buttons(1) = '1' or buttons(0) = '1' then
					NEXT_STATE <= Wrong4_P;
				elsif buttons(3) = '0' and buttons(2) = '0' and buttons(1) = '0' and buttons(0) = '0' then
					NEXT_STATE <= Right3_R;
				else
					NEXT_STATE <= Right3_R;
				end if;
				
			-- When the fourth button pressed is correct		
			when Right4_P =>
				if buttons(2) = '1'  then
					NEXT_STATE <= Right4_P;
				elsif buttons(2) = '0' then
					NEXT_STATE <= UNLOCKED;
				else
					NEXT_STATE <= Right4_P;
				end if;
				

			when Wrong1_P | Wrong2_P | Wrong3_P | Wrong4_P =>
				if buttons(3) = '1' or buttons(2) = '1' or buttons(1) = '1' or 
						buttons(0) = '1' then
						
					case PRESENT_STATE is
						when Wrong1_P => NEXT_STATE <= Wrong1_R;
						when Wrong2_P => NEXT_STATE <= Wrong2_R;
						when Wrong3_P => NEXT_STATE <= Wrong3_R;
						when Wrong4_P => NEXT_STATE <= ERROR;
						when others => null;
					end case;
				elsif buttons(3) = '0' and buttons(2) = '0' and buttons(1) = '0' and buttons(0) = '0' then
					NEXT_STATE <= PRESENT_STATE;
				else
					NEXT_STATE <= PRESENT_STATE;
				end if;
			when Wrong1_R =>
				if buttons(3) = '1' or buttons(2) = '1' or buttons(1) = '1' or buttons(0) = '1' then
					NEXT_STATE <= Wrong2_P;
				--elsif buttons(3 downto 0) = "0000" then
				--	NEXT_STATE <= PRESENT_STATE;
				else
					NEXT_STATE <= PRESENT_STATE;
				end if;
			when Wrong2_R =>
				if buttons(3) = '1' or buttons(2) = '1' or buttons(1) = '1' or buttons(0) = '1' then
					NEXT_STATE <= Wrong3_P;
				--elsif buttons(3 downto 0) = "0000" then
				--	NEXT_STATE <= PRESENT_STATE;
				else
					NEXT_STATE <= PRESENT_STATE;
				end if;
			when Wrong3_R =>
				if buttons(3) = '1' or buttons(2) = '1' or buttons(1) = '1' or buttons(0) = '1' then
					NEXT_STATE <= Wrong4_P;
				--elsif buttons(3 downto 0) = "0000" then
					--NEXT_STATE <= PRESENT_STATE;
				else
					NEXT_STATE <= PRESENT_STATE;
				end if;
			when UNLOCKED =>
				NEXT_STATE <= S0;
				NEW_STATUS <= IS_UNLOCKED;
				
			when ERROR => 
				NEXT_STATE <= S0;
				NEW_STATUS <= INCORRECT;
				
			when S0 => 
				case CURRENT is
					when IS_UNLOCKED =>
						NEXT_STATE <= S10;
					when INCORRECT =>
						NEXT_STATE <= S1;
					when others => null;
				end case;
				
				
			when S1 =>
				NEXT_STATE <= S2 after delay;
			when S2 =>
				NEXT_STATE <= S3 after delay;
			when S3 =>
				NEXT_STATE <= S4 after delay;
			when S4 =>
				NEXT_STATE <= S5 after delay;
			when S5 =>
				NEXT_STATE <= S6 after delay;
			when S6 =>
				NEXT_STATE <= S7 after delay;
			when S7 =>
				NEXT_STATE <= S8 after delay;
			when S8 =>
				NEXT_STATE <= S9 after delay;
			when S9 =>
				NEXT_STATE <= DONE;
			when S10 =>
				NEXT_STATE <= S11 after delay;
			when S11 =>
				NEXT_STATE <= S12 after delay;
			when S12 =>
				NEXT_STATE <= S13 after delay;
			when S13 =>
				NEXT_STATE <= S14 after delay;
			when S14 =>
				NEXT_STATE <= S15 after delay;
			when S15 =>
				NEXT_STATE <= S16 after delay;
			when S16 =>
				NEXT_STATE <= S17 after delay;
			when S17 =>
				NEXT_STATE <= S18 after delay;
			when S18 =>
				NEXT_STATE <= S19 after delay;
			when S19 =>
				NEXT_STATE <= DONE;
			when DONE => 
				NEXT_STATE <= LOCKED;
				NEW_STATUS <= IS_LOCKED;
			when others => null;
		end case;
	end process Transition_Function;
	
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
	Output_Function : process(PRESENT_STATE)
	begin
		case PRESENT_STATE is 
			when LOCKED | Right1_P | Right2_P | Right3_P | Right4_P | Right1_R 
							| Right2_R | Right3_R | Wrong1_P | Wrong2_P | Wrong3_P 
							| Wrong4_P | Wrong1_R | Wrong2_R | Wrong3_R | ERROR 
							| UNLOCKED =>
					led_out(1) <= '0';
					led_out(0) <= '1';
					--led_out(3 downto 0) <= "0001";
			when S0 =>
				led_out(1) <= '1';
				led_out(0) <= '0';
			when S1 =>
				led_out(3 downto 0) <= "0000";
			when S2 =>
				led_out(1) <= '0';
				led_out(0) <= '1';
				--led_out(3 downto 0) <= "0001";
			when S3 =>
				led_out(3 downto 0) <= "0000";
			when S4 =>
				led_out(1) <= '1';
				led_out(0) <= '0';
			when S5 =>
				led_out(3 downto 0) <= "0000";
			when S6 =>
				led_out(1) <= '0';
				led_out(0) <= '1';
				--led_out(3 downto 0) <= "0001";
			when S7 =>
				led_out(3 downto 0) <= "0000";
			when S8 =>
				led_out(1) <= '1';
				led_out(0) <= '0';
			when S9 =>
				led_out(3 downto 0) <= "0000";
			when S10 | S11 | S12 | S13 | S14 | S15 | S16 | S17 | S18 | S19 =>
				led_out(1) <= '1';
				led_out(0) <= '0';
			when DONE =>
				led_out(1) <= '0';
				led_out(0) <= '1';
			when others => null;
		end case;
	end process Output_Function;
end Behavioral;


