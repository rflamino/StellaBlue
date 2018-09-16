-- A2601 Top Level Entity (ROM stored in on-chip RAM)
-- Copyright 2006, 2010 Retromaster
--
--  This file is part of A2601.
--
--  A2601 is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 3 of the License,
--  or any later version.
--
--  A2601 is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with A2601.  If not, see <http://www.gnu.org/licenses/>.
--

-- This top level entity supports a single cartridge ROM stored in FPGA built-in
-- memory (such as Xilinx Spartan BlockRAM). To generate the required cart_rom
-- entity, use bin2vhdl.py found in the util directory.
--
-- For more information, see the A2601 Rev B Board Schematics and project
-- website at <http://retromaster.wordpress.org/a2601>.


  -- 9 pin d-sub joystick pinout:
  -- pin 1: up
  -- pin 2: down
  -- pin 3: left
  -- pin 4: right
  -- pin 6: fire

  -- Atari 2600, 6532 ports:
  -- PA0: right joystick, up
  -- PA1: right joystick, down
  -- PA2: right joystick, left
  -- PA3: right joystick, right
  -- PA4: left joystick, up
  -- PA5: left joystick, down
  -- PA6: left joystick, left
  -- PA7: left joystick, right
  -- PB0: start
  -- PB1: select
  -- PB3: B/W, color
  -- PB6: left difficulty
  -- PB7: right difficulty

  -- Atari 2600, TIA input:
  -- I5: right joystick, fire
  -- I6: left joystick, fire

  
  


library std;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity A2601Master is
   port (vid_clk: in std_logic;
			pa_in: in std_logic_vector(7 downto 0);
			pb_in: in std_logic_vector(7 downto 0);	
			inpt0_in: in std_logic;
			inpt1_in: in std_logic;
			inpt2_in: in std_logic;
			inpt3_in: in std_logic;
			inpt4_in: in std_logic;
			inpt5_in: in std_logic;
			d_in: in std_logic_vector(7 downto 0);
			a_out: out std_logic_vector(12 downto 0);
         cv: out std_logic_vector(7 downto 0);
         vsyn: out std_logic;
         hsyn: out std_logic;
         au: out std_logic_vector(4 downto 0);
			dump_pin:out std_logic;
         res: in std_logic);
end A2601Master;

architecture arch of A2601Master is

    component A2601 is
    port(vid_clk: in std_logic;
         rst: in std_logic;
         d: inout std_logic_vector(7 downto 0);
         a: out std_logic_vector(12 downto 0);
         r: out std_logic;
         pa: inout std_logic_vector(7 downto 0);
         pb: inout std_logic_vector(7 downto 0);
         paddle_0: in std_logic_vector(7 downto 0);
         paddle_1: in std_logic_vector(7 downto 0);
         paddle_2: in std_logic_vector(7 downto 0);
         paddle_3: in std_logic_vector(7 downto 0);
         paddle_ena: in std_logic;
         inpt4: in std_logic;
         inpt5: in std_logic;
         colu: out std_logic_vector(6 downto 0);
         csyn: out std_logic;
         vsyn: out std_logic;
         hsyn: out std_logic;
			rgbx2: out std_logic_vector(23 downto 0);
         cv: out std_logic_vector(7 downto 0);
         au0: out std_logic;
         au1: out std_logic;
         av0: out std_logic_vector(3 downto 0);
         av1: out std_logic_vector(3 downto 0);
         ph0_out: out std_logic;
         ph1_out: out std_logic;
         pal: in std_logic);
    end component; 
	 

  
component debounce is

  GENERIC(
    NDELAY  :  INTEGER := 10000;
	 NBITS :    INTEGER := 20
	 ); 
Port ( 
	reset 	: in  std_logic;
	clk 	: in  std_logic;
	noisy 	: in  std_logic;
	clean 		: out  std_logic
	);
end component;	  

	signal clk 	:   std_logic;
	signal noisy 	:   std_logic;
	signal clean 		:   std_logic;


    signal dbounce_pb: std_logic_vector(1 downto 0) := "00";	 
	 
    --signal vid_clk: std_logic;

    signal cpu_d: std_logic_vector(7 downto 0);
    --signal d: std_logic_vector(7 downto 0);	 
	 signal cpu_a: std_logic_vector(12 downto 0);
    --signal a: std_logic_vector(12 downto 0);
	 signal cpu_r: std_logic;
	 
    signal pa: std_logic_vector(7 downto 0);
    signal pb: std_logic_vector(7 downto 0);
	 
	 
    signal paddle_0: std_logic_vector(7 downto 0);	
    signal paddle_1: std_logic_vector(7 downto 0);	
    signal paddle_2: std_logic_vector(7 downto 0);	
    signal paddle_3: std_logic_vector(7 downto 0);	
	 
    signal inpt4: std_logic;
    signal inpt5: std_logic;
	 
    signal colu: std_logic_vector(6 downto 0);
    signal csyn: std_logic;
    signal au0: std_logic;
    signal au1: std_logic;
    signal av0: std_logic_vector(3 downto 0);
    signal av1: std_logic_vector(3 downto 0);

    signal auv0: unsigned(4 downto 0);
    signal auv1: unsigned(4 downto 0);
	 
	-- signal rst: std_logic;

    signal rst: std_logic := '1';
    signal sys_clk_dvdr: unsigned(4 downto 0) := "00000";
	 
	 

    signal ph0: std_logic;
    signal ph1: std_logic;
	 
	 signal pal: std_logic := '0'; -- NTSC
	 
	 
begin


--	ms_A2601: A2601
--      port map(vid_clk, rst, cpu_d, cpu_a, cpu_r,pa, pb,paddle_0, paddle_1, paddle_2, paddle_3, paddle_ena,inpt4, inpt5, open, open, vsyn, hsyn, rgbx2, cv,au0, au1, av0, av1, ph0, ph1, pal);
	ms_A2601: A2601
		  port map(vid_clk, rst, cpu_d, cpu_a, cpu_r,pa, pb,paddle_0, paddle_1, paddle_2, paddle_3, '0' ,inpt4, inpt5, open, open, vsyn, hsyn, open, cv,au0, au1, av0, av1, ph0, ph1, pal);
		  
	a_out <= cpu_a;	  
	  
    process(cpu_a,d_in)
    begin
		   if (cpu_a(12) = '1') then 
			cpu_d <= d_in; 
			else 
			cpu_d <= "ZZZZZZZZ"; 
			end if;
    end process;	  
	  
	  --dump_pin <= ph0;
	 

--    inpt0 <= inpt0_in;
--    inpt1 <= inpt1_in;
--    inpt2 <= inpt2_in;
--    inpt3 <= inpt3_in;
	 
    inpt4 <= inpt4_in;	 
    --inpt5 <= inpt5_in;
	 inpt5 <= '1';
	 
	 
  -- Atari 2600, 6532 ports:
  -- PA0: right joystick, up
  -- PA1: right joystick, down
  -- PA2: right joystick, left
  -- PA3: right joystick, right
  -- PA4: left joystick, up
  -- PA5: left joystick, down
  -- PA6: left joystick, left
  -- PA7: left joystick, right
  -- PB0: start
  -- PB1: select
  -- PB3: B/W, color
  -- PB6: left difficulty
  -- PB7: right difficulty	 



  
	 pa(7 downto 4) <= pa_in(7 downto 4);	--  left joystick
	 pa(3 downto 0) <= "1111";					--  right joystick

	 pb(7 downto 6) <= pb_in(7 downto 6);  -- PB6: left difficulty ; PB7: right difficulty
	 pb(5 downto 4) <= "00";
	 pb(3) <= pb_in(3);							-- B/W
	 pb(2) <= '0';	 
--	 pb(1) <= pb_in(1);							--	select
--	 pb(0) <= pb_in(0);							--	start 

	 
	 ms_dbounce0: debounce port map( res,vid_clk ,pb_in(0),pb(0));
	 ms_dbounce1: debounce port map( res,vid_clk ,pb_in(1),pb(1));

	 
    auv0 <= ("0" & unsigned(av0)) when (au0 = '1') else "00000";
    auv1 <= ("0" & unsigned(av1)) when (au1 = '1') else "00000";

    au <= std_logic_vector(auv0 + auv1);

	 
	  
    process(vid_clk, sys_clk_dvdr)
    begin
        if (vid_clk'event and vid_clk = '1') then
            sys_clk_dvdr <= sys_clk_dvdr + 1;
            if (sys_clk_dvdr = "11101") then
                rst <= '0';
            end if;
        end if;
    end process;
	 
	 
	 
--    process(vid_clk, sys_clk_dvdr,res)
--    begin
--        if (vid_clk'event and vid_clk = '1' ) then
--		  
--		  if (res = '1') then
--			rst <= '1';
--			else 
--			 sys_clk_dvdr <= sys_clk_dvdr + 1;
--		  end if;
--		  
--           if (sys_clk_dvdr = "100") then
--                rst <= '0';	
--					 sys_clk_dvdr <= "000";
--            end if;
--
--        end if;
--
--		  
--    end process;

end arch;



