library IEEE;
USE work.ALL;
use IEEE.std_logic_1164.all;

ENTITY clock_divider is
  GENERIC(DIVISOR : positive := 10);
  PORT(clk : IN  std_logic;
       rst : IN  std_logic;
       q   : INOUT std_logic);
END clock_divider;

ARCHITECTURE behavior OF clock_divider IS

  BEGIN

    toggle : PROCESS(clk,rst)
    
      VARIABLE count : integer RANGE 0 to DIVISOR/2 := 0;

      BEGIN
        IF(rst = '1') THEN
          q <= '0';
          count := 0;
        ELSIF(rising_edge(clk)) THEN
          IF(count = (DIVISOR/2)-1) THEN
            q <= not q;
            count := 0;
          ELSE
            count := count + 1;
          END IF;
        END IF;
    END PROCESS toggle;

END behavior;
