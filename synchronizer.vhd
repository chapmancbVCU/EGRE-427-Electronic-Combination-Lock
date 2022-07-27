library IEEE;
USE work.ALL;
use IEEE.std_logic_1164.all;

ENTITY synchronizer is
  PORT(clk      : IN  std_logic;
       reset    : IN  std_logic;
       sync_in  : IN std_logic;
       sync_out : OUT std_logic);
END synchronizer;

ARCHITECTURE behavior OF synchronizer IS

  SIGNAL demet : std_logic;

  BEGIN

   demet_ff : PROCESS(clk,reset)
      BEGIN
        IF(reset = '1') THEN
          demet <= '0';
        ELSIF(rising_edge(clk)) THEN
          demet <= sync_in;
        END IF;
    END PROCESS demet_ff;

    sync_ff : PROCESS(clk,reset)
      BEGIN
        IF(reset = '1') THEN
          sync_out <= '0';
        ELSIF(rising_edge(clk)) THEN
          sync_out <= demet;
        END IF;
    END PROCESS sync_ff;

END behavior;