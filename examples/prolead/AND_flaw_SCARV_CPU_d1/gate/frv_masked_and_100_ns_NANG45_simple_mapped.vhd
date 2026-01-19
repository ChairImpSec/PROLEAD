
library IEEE;

use IEEE.Std_Logic_1164.all;

entity frv_masked_and is

   port( g_clk, clk_en, z0, z1, ax, ay, bx, by : in std_logic;  qx, qy : out 
         std_logic);

end frv_masked_and;

architecture SYN_verilog of frv_masked_and is

signal t1x0x, t3x0x, n14, n15, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36
   , n37, n_1000, n_1001 : std_logic;

begin
   
   t1_regx0x : DFF_X1 port map( D => n15, CK => g_clk, Q => t1x0x, QN => n_1000
                           );
   t3_regx0x : DFF_X1 port map( D => n14, CK => g_clk, Q => t3x0x, QN => n_1001
                           );
   U34 : XOR2_X1 port map( A => by, B => z0, Z => n34);
   U35 : XOR2_X1 port map( A => n34, B => t3x0x, Z => n27);
   U36 : NAND2_X1 port map( A1 => n27, A2 => bx, ZN => n28);
   U37 : XNOR2_X1 port map( A => n28, B => z1, ZN => qy);
   U38 : XOR2_X1 port map( A => z0, B => ay, Z => n31);
   U39 : XOR2_X1 port map( A => t1x0x, B => n31, Z => n29);
   U40 : NAND2_X1 port map( A1 => n29, A2 => ax, ZN => n30);
   U41 : XNOR2_X1 port map( A => z1, B => n30, ZN => qx);
   U42 : NAND2_X1 port map( A1 => n31, A2 => clk_en, ZN => n33);
   U43 : INV_X1 port map( A => clk_en, ZN => n35);
   U44 : NAND2_X1 port map( A1 => t3x0x, A2 => n35, ZN => n32);
   U45 : NAND2_X1 port map( A1 => n33, A2 => n32, ZN => n14);
   U46 : NAND2_X1 port map( A1 => n34, A2 => clk_en, ZN => n37);
   U47 : NAND2_X1 port map( A1 => t1x0x, A2 => n35, ZN => n36);
   U48 : NAND2_X1 port map( A1 => n37, A2 => n36, ZN => n15);

end SYN_verilog;
