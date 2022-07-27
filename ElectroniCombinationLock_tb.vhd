--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   06:43:12 02/11/2010
-- Design Name:   
-- Module Name:   D:/Users/Chad/Documents/VCU/Spring 2010/EGRE 427/Lab and 
--                Homework/Homework 2/CombinationLock/Combination_Lock/
--                ElectroniCombinationLock_tb.vhd
-- Project Name:  Combination_Lock
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ElectronicCombinationLock
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
use work.all;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY ElectroniCombinationLock_tb IS
END ElectroniCombinationLock_tb;
 
ARCHITECTURE tb OF ElectroniCombinationLock_tb IS 
 
   --Inputs
   signal btns : std_logic_vector(3 downto 0) := (others => '0');
	signal clock : std_logic := '0';
	signal Q : std_logic := '0';
	signal reset : std_logic := '1';
 	--Outputs
   signal leds : std_logic_vector(3 downto 0);

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ENTITY work.ElectronicCombinationLock(Behavioral) PORT MAP (
          clk => clock,
			 Q => Q,
			 reset => reset,
			 btns => btns,
          leds => leds
        );
 
   

	btns(3) <= '1' after 5 ns, '0' after 10 ns;
	btns(2) <= '1' after 15 ns, '0' after 20 ns;
	btns(1) <= '1' after 25 ns, '0' after 30 ns;
	btns(0) <= '1' after 35 ns, '0' after 40 ns;
END;
