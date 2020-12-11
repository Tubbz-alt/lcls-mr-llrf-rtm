-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      ClkEn_Gen.vhd - 
--
--      Copyright(c) SLAC National Accelerator Laboratory 2000
--
--      Author: JEFF OLSEN
--      Created on: 6/8/2011 1:29:35 PM
--      Last change: JO 5/23/2017 1:14:48 PM
--
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:01:44 11/18/2010 
-- Design Name: 
-- Module Name:    ClkEn_Gen - Behavioral 
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ClkEn_Gen is

  port (
    Clock      : in  std_logic;
    Reset      : in  std_logic;
    Clk10KhzEn : out std_logic;
    Clk1KhzEn  : out std_logic;
    Clk200hzEn : out std_logic;
    Clk120hzEn : out std_logic;
    Clk10hzEn  : out std_logic
    );
end ClkEn_Gen;

architecture Behavioral of ClkEn_Gen is

  signal Clk10khzCntr : std_logic_vector(15 downto 0);
  signal iClk10KhzEn  : std_logic;

  signal Clk1khzCntr : std_logic_vector(3 downto 0);
  signal iClk1KhzEn  : std_logic;

  signal Clk200hzCntr : std_logic_vector(3 downto 0);
  signal iClk200hzEn  : std_logic;

   signal Clk120hzCntr : std_logic_vector(7 downto 0);
  signal iClk120hzEn  : std_logic;

  
  signal Clk10hzCntr : std_logic_vector(7 downto 0);
  signal iClk10hzEn  : std_logic;

begin

  Clk10KHzEn <= iClk10KHzEn;
  Clk1KHzEn  <= iClk1KHzEn;
  Clk200hzEn <= iClk200hzEn;
  Clk10hzEn  <= iClk10hzEn;
  Clk120hzEn <= iClk120HzEn;

  ClkGen : process(Clock, Reset)
  begin
    if (Reset = '1') then
      clk10khzCntr <= (others => '0');
      iClk10khzEn  <= '0';
      clk1khzCntr  <= (others => '0');
      iClk1khzEn   <= '0';
      clk10hzCntr  <= (others => '0');
      iClk10hzEn   <= '0';
      iClk200hzEn  <= '0';
      Clk200HzCntr <= (others => '0');
		iClk120hzEn  <= '0';
      Clk120HzCntr <= (others => '0');
			
    elsif (Clock'event and Clock = '1') then
      iClk10KhzEn <= '0';
      iClk1KhzEn  <= '0';
      iClk10HzEn  <= '0';
      iClk200HzEn <= '0';
		iClk120hzEn  <= '0';

      if (Clk10KhzCntr = x"30d3") then  
        Clk10KhzCntr <= (others => '0');
        iClk10KhzEn  <= '1';
      else
        Clk10KhzCntr <= clk10khzCntr + 1;
      end if;

      if (iClk10KhzEn = '1') then
        if (Clk1KhzCntr = x"9") then
          Clk1KhzCntr <= (others => '0');
          iClk1KhzEn  <= '1';
        else
          Clk1KhzCntr <= Clk1KhzCntr + 1;
        end if;
      end if;


		if (iClk10KhzEn = '1') then
			if (Clk120hzCntr = x"53") then
				Clk120hzCntr <= (others => '0');
				iClk120hzEn	<= '1';
			else
				Clk120hzCntr <= Clk120hzCntr + 1;
			end if;
		end if;

      if (iClk1KhzEn = '1') then
        if (Clk10HzCntr = x"63") then
          Clk10HzCntr <= (others => '0');
          iClk10HzEn  <= '1';
        else
          Clk10HzCntr <= Clk10HzCntr + 1;
        end if;
      end if;

      if (iClk1KhzEn = '1') then
        if (Clk200HzCntr = x"4") then
          Clk200HzCntr <= (others => '0');
          iClk200HzEn  <= '1';
        else
          Clk200HzCntr <= Clk200HzCntr + 1;
        end if;
      end if;

    end if;
  end process;

end Behavioral;

