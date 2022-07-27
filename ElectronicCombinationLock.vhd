----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    04:37:30 02/11/2010 
-- Design Name: 
-- Module Name:    ElectronicCombinationLock - Behavioral 
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
library IEEE;
use work.all;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ElectronicCombinationLock is
    Port (clk : in std_logic;
			 btns : in  STD_LOGIC_VECTOR (3 downto 0);
          leds : out  STD_LOGIC_VECTOR (3 downto 0));
end ElectronicCombinationLock;

architecture Behavioral of ElectronicCombinationLock is
	constant clk_frequency : positive := 50000000;
   constant divisor : positive := 10;
   signal reset : std_logic := '1';
	signal switch_in : STD_LOGIC_VECTOR(3 downto 0);
	signal switch_out : STD_LOGIC_VECTOR(3 downto 0);
   --signal sync_in : STD_LOGIC_VECTOR(3 downto 0);
   signal sync_out : STD_LOGIC_VECTOR(3 downto 0);
	signal leds_out : STD_LOGIC_VECTOR(3 downto 0);
   signal Q : std_logic := '0';
	
begin
	switch_in <= btns;
	reset <= '0' after 10 ns;
	SD_Btn3 : ENTITY work.SwitchDebouncer(Structural) 
      Generic Map(CLK_FREQ => clk_frequency)
      Port Map(clk => clk,
					reset => reset, 
					switchin => switch_in(3), 
					switchout => switch_out(3));
					
   SD_Btn2 : ENTITY work.SwitchDebouncer(Structural) 
      Generic Map(CLK_FREQ => clk_frequency)
      Port Map(clk => clk, 
					reset => reset, 
					switchin => switch_in(2), 
					switchout => switch_out(2));
					
	SD_Btn1 : ENTITY work.SwitchDebouncer(Structural) 
      Generic Map(CLK_FREQ => clk_frequency)
      Port Map(clk => clk, 
					reset => reset, 
					switchin => switch_in(1), 
					switchout => switch_out(1));
					
	SD_Btn0 : ENTITY work.SwitchDebouncer(Structural) 
      Generic Map(CLK_FREQ => clk_frequency)
      Port Map(clk => clk, 
					reset => reset, 
					switchin => switch_in(0), 
					switchout => switch_out(0));
					
		
   U1 : ENTITY work.clock_divider(behavior)
      Generic Map(divisor => divisor)
      Port Map(clk => clk, 
					rst => reset, 
					Q => Q);


   sync_3 : ENTITY work.synchronizer(behavior)
      Port Map(clk => Q, 
					reset => reset, 
					sync_in => switch_out(3),
					sync_out => sync_out(3));
					
	sync_2 : ENTITY work.synchronizer(behavior)
      Port Map(clk => Q, 
					reset => reset, 
					sync_in => switch_out(2), 
					sync_out => sync_out(2));
					
	sync_1 : ENTITY work.synchronizer(behavior)
      Port Map(clk => Q, 
					reset => reset, 
					sync_in => switch_out(1), 
					sync_out => sync_out(1));
					
   sync_0 : ENTITY work.synchronizer(behavior)
      Port Map(clk => Q, 
					reset => reset, 
					sync_in => switch_out(0), 
					sync_out => sync_out(0)); 

	U2 : entity work.CombinationLockFSM(Behavioral)
		Port Map(clk, reset, sync_out, leds_out);
	leds <= leds_out;
end Behavioral;

