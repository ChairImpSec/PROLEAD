----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:21:07 05/22/2009 
-- Design Name: 
-- Module Name:    Sbox - dfl 
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
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Sbox is
    Port ( sboxIn  : in  STD_LOGIC_VECTOR (3 downto 0);
           sboxOut : out STD_LOGIC_VECTOR (3 downto 0)
           );
end Sbox;

architecture dfl of Sbox is

----------------------------------------------------------
-- data signals
----------------------------------------------------------
signal r0,r1,r2,r3 : STD_LOGIC;
signal r4,r5,r6,r7 : STD_LOGIC;
signal r8,r9,ra,rb : STD_LOGIC;
signal rc,rd,re,rf : STD_LOGIC;
signal rg,rh,ri,rj : STD_LOGIC;


begin
----------------------------------------------------------
-- input mapping
----------------------------------------------------------
r0 <= SboxIn(0);
r1 <= SboxIn(1);
r2 <= SboxIn(2);
r3 <= SboxIn(3);
----------------------------------------------------------
-- output mapping
----------------------------------------------------------

SboxOut <= rg&rh&ri&rj;
----------------------------------------------------------
-- pseudo code
----------------------------------------------------------
-- oai21 = HDOAI21D1 = 1.66 GE * 8 = 13.28
-- aoi21 = HDAOI21D1 = 1.33 GE * 5 = 6.65
-- nand3 = HDNAN3D1 =  1.33 GE * 3 = 3.99
--Summe = 24 GE

r4 <= (r0 OR r2) NAND r1;
r5 <= (r0 OR r3) NAND r2; 
r6 <= (r0 AND r3) NOR r5;
r7 <= (r0 OR r1) NAND r4;

r8 <= NOT(r7 AND r4 AND r3) ;
r9 <= NOT(r7 AND r3 AND r1) ;
ra <= (r2 AND r4) NOR r6;
rb <= (r0 AND r3) NOR r6;

rc <= (r1 OR r3) NAND r9;
rd <= (r3 OR r7) NAND r8;
re <= NOT(ra AND r8 AND r4) ;
rf <= (r0 OR r3) NAND rb;

rg <= (r2 AND r3) NOR rd;
rh <= (r5 OR rc) NAND re;
ri <= (r5 AND rc) NOR r6;
rj <= (rd OR ra) NAND rf;


--   	  r4 = oai21      (r0, r2, r1);   // ecec
--        r5 = oai21      (r0, r3, r2);   // faf0
-- 
--        r6 = aoi21      (r0, r3, r5);   // 050a
--        r7 = oai21      (r0, r1, r4);   // 9b9b
-- 
--        r8 = nand3      (r7, r4, r3);   // ff77
--        r9 = nand3      (r7, r3, r1);   // ffec
--        ra = aoi21      (r2, r4, r6);   // f2f1
--        rb = aoi21      (r0, r3, r6);   // faa0
-- 
--        rc = oai21      (r1, r3, r9);   // cc13
--        rd = oai21      (r3, r7, r8);   // 6488
--        re = nand3      (ra, r8, r4);   // 1f9f
--        rf = oai21      (r0, r3, rb);   // af5f
-- 
--        rg = aoi21      (r2, r3, rd);   // 9b70
--        rh = oai21      (r5, rc, re);   // e16c
--        ri = aoi21      (r5, rc, r6);   // 32e5
--        rj = oai21      (rd, ra, rf);   // 59a6
end dfl;