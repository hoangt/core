------------------------------------------------------------------------------
--  This file is a part of the GRLIB VHDL IP LIBRARY
--  Copyright (C) 2003 - 2008, Gaisler Research
--  Copyright (C) 2008 - 2010, Aeroflex Gaisler
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
-----------------------------------------------------------------------------
-- Entity: 	ahbtbp
-- File:    ahbtbp.vhd
-- Author:  Nils-Johan Wessman - Gaisler Research
-- Description:	AHB Testbench package
------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;

library gaisler;
use gaisler.ahbtbp.all;

package ahbtbp2 is

constant ac_idle : ahbtbm_access_type :=
  (haddr => x"00000000", hdata => x"00000000", htrans => "00", 
   hburst =>"000", hsize => "000", hwrite => '0', 
   ctrl => (delay => x"00", dbgl => 100, reset =>'0'));
constant ctrli_idle : ahbtbm_ctrl_in_type :=(ac => ac_idle);
constant ctrlo_nodrive : ahbtbm_ctrl_out_type :=(rst => 'H', clk => 'H', 
  update => 'H', dvalid => 'H', hrdata => (others => 'H'), 
  status => (err => 'H', ecount => (others => 'H'), eaddr => (others => 'H'),
             edatac => (others => 'H'), edatar => (others => 'H'),
             hresp => (others => 'H')));

impure function ptime return string;
-- pragma translate_off

-----------------------------------------------------------------------------
-- AHB testbench Master 
-----------------------------------------------------------------------------
component ahbtbm is
  generic (
    hindex  : integer := 0;
    hirq    : integer := 0;
    venid   : integer := 0;
    devid   : integer := 0;
    version : integer := 0;
    chprot  : integer := 3;
    incaddr : integer := 0); 
  port (
    rst  : in  std_ulogic;
    clk  : in  std_ulogic;
    ctrli : in  ahbtbm_ctrl_in_type;
    ctrlo : out ahbtbm_ctrl_out_type;
    ahbmi : in  ahb_mst_in_type;
    ahbmo : out ahb_mst_out_type 
    );
end component;

-----------------------------------------------------------------------------
-- AHB testbench Slave 
-----------------------------------------------------------------------------
component ahbtbs is
  generic (
    hindex  : integer := 0;
    haddr   : integer := 0;
    hmask   : integer := 16#fff#;
    tech    : integer := 0;
    kbytes  : integer := 1); 
  port (
    rst     : in  std_ulogic;
    clk     : in  std_ulogic;
    ahbsi   : in  ahb_slv_in_type;
    ahbso   : out ahb_slv_out_type
  );
end component;

-----------------------------------------------------------------------------
-- dprint (Debug print)
-----------------------------------------------------------------------------
procedure dprint(
  constant doprint : in boolean := true;
  constant s       : in string);

procedure dprint(
  constant s       : in string);

-----------------------------------------------------------------------------
-- AMBATB Init
-----------------------------------------------------------------------------
procedure ahbtbminit(
  signal ctrli : out ahbtbm_ctrl_in_type;
  signal ctrlo : in  ahbtbm_ctrl_out_type);
  
-----------------------------------------------------------------------------
-- AMBATB DONE
-----------------------------------------------------------------------------
procedure ahbtbmdone(
  constant stop: in  integer;
  signal ctrli : out ahbtbm_ctrl_in_type;
  signal ctrlo : in  ahbtbm_ctrl_out_type);
  
-----------------------------------------------------------------------------
-- AMBATB Idle
-----------------------------------------------------------------------------
procedure ahbtbmidle(
  constant sync: in  boolean;
  signal ctrli : out ahbtbm_ctrl_in_type;
  signal ctrlo : in  ahbtbm_ctrl_out_type);
  
-----------------------------------------------------------------------------
-- AMBA AHB write access
-----------------------------------------------------------------------------
procedure ahbwrite(
  constant address  : in  std_logic_vector(31 downto 0);
  constant data     : in  std_logic_vector(31 downto 0);
  constant size     : in  std_logic_vector(1 downto 0);
  constant debug    : in  integer;
  constant appidle  : in  boolean;
  signal   ctrli    : out ahbtbm_ctrl_in_type;
  signal   ctrlo    : in  ahbtbm_ctrl_out_type);

-----------------------------------------------------------------------------
-- AMBA AHB write access (htrans)
-----------------------------------------------------------------------------
procedure ahbwrite(
  constant address  : in  std_logic_vector(31 downto 0);
  constant data     : in  std_logic_vector(31 downto 0);
  constant size     : in  std_logic_vector(1 downto 0);
  constant htrans   : in  std_logic_vector(1 downto 0);
  constant hburst   : in  std_logic;  
  constant debug    : in  integer;
  constant appidle  : in  boolean;
  signal   ctrli    : out ahbtbm_ctrl_in_type;
  signal   ctrlo    : in  ahbtbm_ctrl_out_type);

-----------------------------------------------------------------------------
-- AMBA AHB write access (Inc Burst)
-----------------------------------------------------------------------------
procedure ahbwrite(
  constant address  : in  std_logic_vector(31 downto 0);
  constant data     : in  std_logic_vector(31 downto 0);
  constant size     : in  std_logic_vector(1 downto 0);
  constant count    : in  integer;
  constant debug    : in  integer;
  signal   ctrli    : out ahbtbm_ctrl_in_type;
  signal   ctrlo    : in  ahbtbm_ctrl_out_type);

-----------------------------------------------------------------------------
-- AMBA AHB read access 
-----------------------------------------------------------------------------
procedure ahbread(
  constant address  : in  std_logic_vector(31 downto 0); -- Address
  constant data     : in  std_logic_vector(31 downto 0); -- Data
  constant size     : in  std_logic_vector(1 downto 0);  
  constant debug    : in  integer;
  constant appidle  : in  boolean;
  signal   ctrli    : out ahbtbm_ctrl_in_type;
  signal   ctrlo    : in  ahbtbm_ctrl_out_type);

-----------------------------------------------------------------------------
-- AMBA AHB read access (htrans)
-----------------------------------------------------------------------------
procedure ahbread(
  constant address  : in  std_logic_vector(31 downto 0); -- Address
  constant data     : in  std_logic_vector(31 downto 0); -- Data
  constant size     : in  std_logic_vector(1 downto 0);  
  constant htrans   : in  std_logic_vector(1 downto 0);  
  constant hburst   : in  std_logic;  
  constant debug    : in  integer;
  constant appidle  : in  boolean;
  signal   ctrli    : out ahbtbm_ctrl_in_type;
  signal   ctrlo    : in  ahbtbm_ctrl_out_type);

-----------------------------------------------------------------------------
-- AMBA AHB read access (Inc Burst)
-----------------------------------------------------------------------------
procedure ahbread(
  constant address  : in  std_logic_vector(31 downto 0); -- Start address
  constant data     : in  std_logic_vector(31 downto 0); -- Start data
  constant size     : in  std_logic_vector(1 downto 0);
  constant count    : in  integer;
  constant debug    : in  integer;
  signal   ctrli    : out ahbtbm_ctrl_in_type;
  signal   ctrlo    : in  ahbtbm_ctrl_out_type);

end ahbtbp2;

package body ahbtbp2 is

impure function ptime return string is
variable s  : string(1 to 20);
variable length : integer := tost(NOW / 1 ns)'length; 
begin
  s(1 to length + 9) :="Time: " & tost(NOW / 1 ns) & "ns ";
  return s(1 to length + 9);
end function ptime;

-----------------------------------------------------------------------------
-- dprint (Debug print)
-----------------------------------------------------------------------------
procedure dprint(
  constant doprint : in boolean := true;
  constant s       : in string) is
begin
  if doprint = true then
    print(s);
  end if;
end procedure dprint;

procedure dprint(
  constant s       : in string) is
begin
  print(s);
end procedure dprint;

-----------------------------------------------------------------------------
-- AHBTB init
-----------------------------------------------------------------------------
procedure ahbtbminit(
  signal ctrli: out ahbtbm_ctrl_in_type;
  signal ctrlo: in  ahbtbm_ctrl_out_type) is
begin
--   ctrl.o <= ctrlo_nodrive;
  ctrli <= ctrli_idle;
  --ctrli.ac.hburst <= "000"; ctrli.ac.hsize <= "010";
  --ctrli.ac.haddr <= x"00000000"; ctrli.ac.hdata <= x"00000000";
  --ctrli.ac.htrans <= "00"; ctrli.ac.hwrite <= '0';
--   print("**********************************************************");
--   print("                     AHBM INIT FUNCTION");
--   print("**********************************************************");
--   wait until ctrlo.rst = '1';
  print("**********************************************************");
  print("                     AHBTBM Testbench Init");
  print("**********************************************************");
end procedure ahbtbminit;

-----------------------------------------------------------------------------
-- AMBTB DONE
-----------------------------------------------------------------------------
procedure ahbtbmdone(
  constant stop: in  integer;
  signal ctrli : out ahbtbm_ctrl_in_type;
  signal ctrlo : in  ahbtbm_ctrl_out_type) is
begin
  --ctrl.o <= ctrlo_nodrive;
  wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
  ctrli <= ctrli_idle;
  wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
  wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
  wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
  wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
  print("**********************************************************");
  print("             AHBTBM Testbench Done");
  print("**********************************************************");
  wait for 100 ns;
  assert stop = 0
    report "ahbtb testbench done!"
    severity FAILURE;
end procedure ahbtbmdone;

-----------------------------------------------------------------------------
-- AMBTB Idle
-----------------------------------------------------------------------------
procedure ahbtbmidle(
  constant sync: in  boolean;
  signal ctrli : out ahbtbm_ctrl_in_type;
  signal ctrlo : in  ahbtbm_ctrl_out_type) is
begin
  --ctrl.o <= ctrlo_nodrive;
  wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
  ctrli <= ctrli_idle;
  if sync = true then
  wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
  wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
  wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
  end if;
end procedure ahbtbmidle;

-----------------------------------------------------------------------------
-- AMBA AHB write access
-----------------------------------------------------------------------------
procedure ahbwrite(
  constant address  : in  std_logic_vector(31 downto 0);
  constant data     : in  std_logic_vector(31 downto 0);
  constant size     : in  std_logic_vector(1 downto 0);
  constant debug    : in  integer;
  constant appidle  : in  boolean;
  signal   ctrli    : out ahbtbm_ctrl_in_type;
  signal   ctrlo    : in  ahbtbm_ctrl_out_type) is
begin
  --ctrl.o <= ctrlo_nodrive;
  wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
  ctrli.ac.ctrl.dbgl <= debug;
  ctrli.ac.hburst <= "000"; ctrli.ac.hsize <= '0' & size;
  ctrli.ac.haddr <= address; ctrli.ac.hdata <= data;
  ctrli.ac.htrans <= "10"; ctrli.ac.hwrite <= '1'; ctrli.ac.hburst <= "000";
  if appidle = true then
    wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
    ctrli <= ctrli_idle;
  end if;
end procedure ahbwrite;

-----------------------------------------------------------------------------
-- AMBA AHB write access (htrans)
-----------------------------------------------------------------------------
procedure ahbwrite(
  constant address  : in  std_logic_vector(31 downto 0);
  constant data     : in  std_logic_vector(31 downto 0);
  constant size     : in  std_logic_vector(1 downto 0);
  constant htrans   : in  std_logic_vector(1 downto 0);
  constant hburst   : in  std_logic;  
  constant debug    : in  integer;
  constant appidle  : in  boolean;
  signal   ctrli    : out ahbtbm_ctrl_in_type;
  signal   ctrlo    : in  ahbtbm_ctrl_out_type) is
begin
  --ctrl.o <= ctrlo_nodrive;
  wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
  ctrli.ac.ctrl.dbgl <= debug;
  ctrli.ac.hburst <= "000"; ctrli.ac.hsize <= '0' & size;
  ctrli.ac.haddr <= address; ctrli.ac.hdata <= data;
  ctrli.ac.htrans <= htrans; ctrli.ac.hwrite <= '1'; 
  ctrli.ac.hburst <= "00" & hburst;
  if appidle = true then
    wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
    ctrli <= ctrli_idle;
  end if;
end procedure ahbwrite;

-----------------------------------------------------------------------------
-- AMBA AHB write access (Inc Burst)
-----------------------------------------------------------------------------
procedure ahbwrite(
  constant address  : in  std_logic_vector(31 downto 0);
  constant data     : in  std_logic_vector(31 downto 0);
  constant size     : in  std_logic_vector(1 downto 0);
  constant count    : in  integer;
  constant debug    : in  integer;
  signal   ctrli    : out ahbtbm_ctrl_in_type;
  signal   ctrlo    : in  ahbtbm_ctrl_out_type) is

  variable vaddr    : std_logic_vector(31 downto 0);
  variable vdata    : std_logic_vector(31 downto 0);
  variable vhtrans  : std_logic_vector(1 downto 0);
begin
  --ctrl.o <= ctrlo_nodrive;
  vaddr := address; vdata := data; vhtrans := "10";
  wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
  ctrli.ac.ctrl.dbgl <= debug;
  ctrli.ac.hburst <= "000"; ctrli.ac.hsize <= '0' & size;
  ctrli.ac.hwrite <= '1'; ctrli.ac.hburst <= "001";
  for i in 0 to count - 1 loop
    ctrli.ac.haddr <= vaddr; ctrli.ac.hdata <= vdata;
    ctrli.ac.htrans <= vhtrans; 
    wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
    vaddr := vaddr + x"4"; vdata := vdata + 1;
    vhtrans := "11";
  end loop;
  ctrli <= ctrli_idle;
end procedure ahbwrite;

-----------------------------------------------------------------------------
-- AMBA AHB read access
-----------------------------------------------------------------------------
procedure ahbread(
  constant address  : in  std_logic_vector(31 downto 0);
  constant data     : in  std_logic_vector(31 downto 0);
  constant size     : in  std_logic_vector(1 downto 0);
  constant debug    : in  integer;
  constant appidle  : in  boolean;
  signal   ctrli    : out ahbtbm_ctrl_in_type;
  signal   ctrlo    : in  ahbtbm_ctrl_out_type) is
begin
  --ctrl.o <= ctrlo_nodrive;
  wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
  ctrli.ac.ctrl.dbgl <= debug;
  ctrli.ac.hsize <= '0' & size;
  ctrli.ac.haddr <= address; ctrli.ac.hdata <= data;
  ctrli.ac.htrans <= "10"; ctrli.ac.hwrite <= '0'; ctrli.ac.hburst <= "000";
  if appidle = true then
    wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
    ctrli <= ctrli_idle;
  end if;
end procedure ahbread;

-----------------------------------------------------------------------------
-- AMBA AHB read access (htrans)
-----------------------------------------------------------------------------
procedure ahbread(
  constant address  : in  std_logic_vector(31 downto 0);
  constant data     : in  std_logic_vector(31 downto 0);
  constant size     : in  std_logic_vector(1 downto 0);
  constant htrans   : in  std_logic_vector(1 downto 0);
  constant hburst   : in  std_logic;  
  constant debug    : in  integer;
  constant appidle  : in  boolean;
  signal   ctrli    : out ahbtbm_ctrl_in_type;
  signal   ctrlo    : in  ahbtbm_ctrl_out_type) is
begin
  --ctrl.o <= ctrlo_nodrive;
  wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
  ctrli.ac.ctrl.dbgl <= debug;
  ctrli.ac.hsize <= '0' & size;
  ctrli.ac.haddr <= address; ctrli.ac.hdata <= data;
  ctrli.ac.htrans <= htrans; ctrli.ac.hwrite <= '0'; 
  ctrli.ac.hburst <= "00" & hburst;
  if appidle = true then
    wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
    ctrli <= ctrli_idle;
  end if;
end procedure ahbread;

-----------------------------------------------------------------------------
-- AMBA AHB read access (Inc Burst)
-----------------------------------------------------------------------------
procedure ahbread(
  constant address  : in  std_logic_vector(31 downto 0);
  constant data     : in  std_logic_vector(31 downto 0);
  constant size     : in  std_logic_vector(1 downto 0);
  constant count    : in  integer;
  constant debug    : in  integer;
  signal   ctrli    : out ahbtbm_ctrl_in_type;
  signal   ctrlo    : in  ahbtbm_ctrl_out_type) is

  variable vaddr    : std_logic_vector(31 downto 0);
  variable vdata    : std_logic_vector(31 downto 0);
  variable vhtrans  : std_logic_vector(1 downto 0);
begin
  --ctrl.o <= ctrlo_nodrive;
  vaddr := address; vdata := data; vhtrans := "10";
  wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
  ctrli.ac.ctrl.dbgl <= debug;
  ctrli.ac.hburst <= "000"; ctrli.ac.hsize <= '0' & size;
  ctrli.ac.hwrite <= '0'; ctrli.ac.hburst <= "001";
  for i in 0 to count - 1 loop
    ctrli.ac.haddr <= vaddr; ctrli.ac.hdata <= vdata;
    ctrli.ac.htrans <= vhtrans; 
    wait until ctrlo.update = '1' and rising_edge(ctrlo.clk);
    vaddr := vaddr + x"4"; vdata := vdata + 1;
    vhtrans := "11";
  end loop;
  ctrli <= ctrli_idle;
end procedure ahbread;

-- pragma translate_on

end ahbtbp2;
