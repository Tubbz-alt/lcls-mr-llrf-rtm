
-----------------------------------------------------------------
--                                                             --
-----------------------------------------------------------------
--
--      DeBouncer.vhd -
--
--      Copyright(c) Stanford Linear Accelerator Center 2000
--
--      Author: Jeff Olsen
--      Created on: 03/01/06
--      Last change: JO 7/14/2016 4:45:31 PM
--
-- 
-- Crated by Jeff Olsen 6/27/16
--
--  Filename: DeBouncer.vhd
--

--  Modifications:

Library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

Entity DeBouncer is
port (
    Clock     	: in std_logic;
    Reset 		: in std_logic;

	 ClkEn		: in std_logic;
	 Input		: in std_logic;
    DbOut 		: out std_logic
    );
End DeBouncer;

  
Architecture Behaviour of DeBouncer is

signal counter 	: std_logic_vector(3 downto 0);
signal iStart		: std_logic;

Begin

db_p: process( clock, reset)
Begin
if (Reset = '1') then
	iStart		<= '0';
	counter		<= (Others => '0');
	DbOut		<= '0';
elsif (Clock'event and Clock = '1') then
	if (ClkEn = '1') then
		iStart <= Input;
		if ((counter /= x"0") and (iStart = '0')) then
			counter <= counter - 1;
		elsif ((counter /= x"f") and (iStart = '1')) then
			counter <= counter + 1;
		else
			counter <= counter;
		end if;
	end if;


	if (counter = x"F") then
		DbOut <= '1';
	elsif (counter = x"0") then
		DbOut <= '0';
	end if;

end if;

end process; -- db_p

end Behaviour;
          
  