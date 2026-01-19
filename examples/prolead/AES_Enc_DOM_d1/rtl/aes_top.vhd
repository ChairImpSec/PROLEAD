---------------------------------------------------------------------------
--
-- Copyright (C) 2016 Stiftung Secure Information and 
--                    Communication Technologies SIC and
--                    Graz University of Technology
-- Contact: http://opensource.iaik.tugraz.at
--
-- This file is part of AES DOM.
--
-- $BEGIN_LICENSE:DEFAULT$
-- Commercial License Usage
-- Licensees holding valid commercial licenses may use this file in
-- accordance with the commercial license agreement provided with the
-- Software or, alternatively, in accordance with the terms contained in
-- a written agreement between you and SIC. For further information
-- contact us at http://opensource.iaik.tugraz.at.
--
-- GNU General Public License Usage
-- Alternatively, this file may be used under the terms of the GNU
-- General Public License version 3.0 as published by the Free Software
-- Foundation and appearing in the file LICENSE.GPL included in the
-- packaging of this file.  Please review the following information to
-- ensure the GNU General Public License version 3.0 requirements will be
-- met: http://www.gnu.org/copyleft/gpl.html.
-- 
-- This software is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this software. If not, see http://www.gnu.org/licenses/.
--
-- $END_LICENSE:DEFAULT$
--
----------------------------------------------------------------------------
--       ### aes_top.vhdl ###
--
-- Description:
-- Top module of AES encryption-only core for synthesis and p&r
-- perfectly interleaved design (-> 200 cycles per encryption for large data)  
-- else: 216 or 246, respectively
--
-- Initial Version: Date: 4. November 2015 by Hannes Gross IAIK
--
------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library common;
use common.masked_aes_pkg.all;

entity aes_top is
  generic (
    PERFECTLY_INTERLEAVED : string  := "no";  -- yes -> faster, no -> smaller
    -- Donot use eight-staged Sbox with Perfectly Interleaved variant!
    EIGHT_STAGED_SBOX     : string  := "yes";  -- yes -> smaller, less randomness
    N                     : integer := 1       -- Protection order >= 0
    );
  port (
    ClkxCI   : in std_logic;
    RstxBI   : in std_logic;
    --- Inputs:
    -- Plaintext shares
    PTxDI    : in t_shared_gf8(N downto 0);
    -- Key shares
    KxDI     : in t_shared_gf8(N downto 0);
    -- Randomnes for remasking
    Zmul1xDI : in t_shared_gf4((N*(N+1)/2)-1 downto 0);  -- for y1 * y0
    Zmul2xDI : in t_shared_gf4((N*(N+1)/2)-1 downto 0);  -- for O * y1
    Zmul3xDI : in t_shared_gf4((N*(N+1)/2)-1 downto 0);  -- for O * y0
    Zinv1xDI : in t_shared_gf2((N*(N+1)/2)-1 downto 0);  -- for inverter
    Zinv2xDI : in t_shared_gf2((N*(N+1)/2)-1 downto 0);  -- ...
    Zinv3xDI : in t_shared_gf2((N*(N+1)/2)-1 downto 0);  -- ...
    -- Blinding values for Y0*Y1 and Inverter
    Bmul1xDI : in t_shared_gf4(N downto 0);              -- for y1 * y0
    Binv1xDI : in t_shared_gf2(N downto 0);              -- for inverter
    Binv2xDI : in t_shared_gf2(N downto 0);              -- ...
    Binv3xDI : in t_shared_gf2(N downto 0);              -- ...
    -- Control signals
    StartxSI : in  std_logic; -- Start the core
    --- Output:
    DonexSO  : out std_logic; -- ciphertext is ready
    -- Cyphertext C
    CxDO     : out  t_shared_gf8(N downto 0)
    );
end aes_top;

-------------------------------------------------------------------

architecture behavorial of aes_top is
  -- Output shares
  signal QxD                   : t_shared_gf8(N downto 0);
  -- State signals from FSM
  signal StateIDLExS           : std_logic;  -- FSM waits for START signal
  signal State1xS              : std_logic;  -- at first working cycle
  signal StateKEYADDITION1o3xS : std_logic;  -- cycle 1  -> 4
  signal StateKEYADDITION2o3xS : std_logic;  -- cycle 5  -> 12
  signal StateKEYADDITION3o3xS : std_logic;  -- cycle 13 -> 16
  signal StateKEYSCHEDULExS    : std_logic;  -- cycle 17 -> 19
  signal StateSHIFTROWSxS      : std_logic;  -- cycle 20 (last)
  -- Signals derived from RCON
  signal RstRCONxS             : std_logic;  -- reset of RCON instance
  signal LastRoundxS           : std_logic;  -- round 10 (or 0 for previous round)
  signal FinishedxS            : std_logic;  -- done with round 10
  signal DonexS                : std_logic;  -- ciphertext ready to be collected
  signal RCONxD                : std_logic_vector(7 downto 0);  -- RCON value
  -- Controll signals
  signal doMixColumnsxS        : std_logic;  -- performs MixColumns at S output
  signal nextRCONxS            : std_logic;  -- calculate next RCON value
  signal showRCONxS            : std_logic;  -- show or hide RCON 
  signal moveKupxS             : std_logic;  -- roll K vertically
  -- Shared data signals
  signal KeyInxD               : t_shared_gf8(N downto 0);  -- K register input
  signal KeyInterleavedxD      : t_shared_gf8(N downto 0);  -- alternative K input
  signal KeyOutxD              : t_shared_gf8(N downto 0);  -- K register output
  signal KeyToSboxOutxD        : t_shared_gf8(N downto 0);  -- K13 register output
  signal K03xD                 : t_shared_gf8(N downto 0);  -- K03 register output
  signal StateInxD             : t_shared_gf8(N downto 0);  -- S register input
  signal StateOutxD            : t_shared_gf8(N downto 0);  -- S register output
  signal S01xD                 : t_shared_gf8(N downto 0);  -- S01 output
  signal SboxOutxD             : t_shared_gf8(N downto 0);  -- SBox output
  signal SboxInxD              : t_shared_gf8(N downto 0);  -- SBox input
  signal SboxOutxDtmp          : t_shared_gf8(N downto 0);  -- SBox tmp output

  -- Sbox pipeline registers (required for "Unprotected" only)
  signal Sbox0xDP, Sbox1xDP, Sbox2xDP, Sbox3xDP : std_logic_vector(7 downto 0);

  -- Eight stage Sbox only:
  signal disableKeyRegsxS  : std_logic;
  signal disableKeyRegsxSP : std_logic;
  signal ClkKeyRegxC       : std_logic;
begin

   -- Enable or disable clock of Key register
  clock_gating_key_reg_g : if EIGHT_STAGED_SBOX = "yes" generate
    gated_key_clock_p : process (ClkxCI, RstxBI) is
    begin  -- process gated_key_clock_p
      if RstxBI = '0' then              -- asynchronous reset (active low)
        disableKeyRegsxSP <= '0';
      elsif ClkxCI'event and ClkxCI = '1' then  -- rising clock edge
        disableKeyRegsxSP <= not disableKeyRegsxS;
      end if;
    end process gated_key_clock_p;

    -- Gated clock
    ClkKeyRegxC <= disableKeyRegsxSP and ClkxCI;
  end generate clock_gating_key_reg_g;
  -- else
  donot_clock_gate_g: if EIGHT_STAGED_SBOX = "no" generate
    -- Use normal clock
    ClkKeyRegxC <= ClkxCI;
  end generate donot_clock_gate_g;
  

  -----------------------------------------------------------------------------
  -- Control path of NOT perfectly interleaved variant
  NOT_perfetly_interleaved_variant: if PERFECTLY_INTERLEAVED = "no" generate
    -- Derive control signals from LSFR and RCON
    input_output_select_p : process (FinishedxS, K03xD, KeyInxD,
                                     KeyOutxD, KeyToSboxOutxD, KxDI,
                                     LastRoundxS, PTxDI, RCONxD, RstxBI,
                                     SboxInxD, SboxOutxD, State1xS,
                                     StateKEYADDITION1o3xS, StateKEYSCHEDULExS,
                                     StateOutxD, StateSHIFTROWSxS) is
      -- Variables
      variable last4Cycles      : std_logic;  -- during cycles 17-20
    begin  -- process input_output_select_p

      -- Variable assignments
      last4Cycles := StateKEYSCHEDULExS or StateSHIFTROWSxS;

      -- RCON control signals
      nextRCONxS <= StateSHIFTROWSxS;          -- Calc next RCON value
      showRCONxS <= State1xS;                  -- RCON value appears on output

      -- for each share
      for i in N downto 0 loop
        -- Select input of Sbox
        if(last4Cycles = '1') then                      -- during cycles 17-20:
          SboxInxD(i) <= KeyToSboxOutxD(i);             -- S13 to SBox
        elsif(FinishedxS = '1') then                    -- in preliminary round:
          SboxInxD(i) <= PTxDI(i) xor KeyInxD(i);       -- PT and key from outside
        else                                            -- default:
          SboxInxD(i) <= StateOutxD(i) xor KeyInxD(i);  -- S00 + K00 + K03
        end if;

        -- Select input of State register
        StateInxD(i) <= SboxOutxD(i);

        -- Select input of Key register
        if(FinishedxS = '1') then                 -- on first round
          KeyInxD(i) <= KxDI(i);                  -- take external key
        elsif(StateKEYADDITION1o3xS = '1') then   -- in first 4 cycles
          if i = 0 then                           -- first share only... 
            KeyInxD(i) <= KeyOutxD(i) xor SboxOutxD(i) xor RCONxD;
          else
            KeyInxD(i) <= KeyOutxD(i) xor SboxOutxD(i);
          end if;
        else
          KeyInxD(i) <= KeyOutxD(i) xor K03xD(i); -- internal key + K03
        end if;

        -- Outputs last State xor last round key
        CxDO(i) <= SboxInxD(i);
      end loop;  -- i

      -- Move K register up during cycles 13 - 20
      moveKupxS <= last4Cycles;

      -- Signal that calculations are finished and CT appears at output
      DonexSO <= State1xS and LastRoundxS;

      -- Reset RCON
      RstRCONxS <= RstxBI;
    end process input_output_select_p;
  end generate NOT_perfetly_interleaved_variant;
  
  -----------------------------------------------------------------------------
  -- Control path of perfectly interleaved variant
  perfetly_interleaved_variant: if PERFECTLY_INTERLEAVED = "yes" generate
    -- Derive control signals from LSFR and RCON
    input_output_select_p : process (K03xD, KeyOutxD, KeyToSboxOutxD,
                                     KxDI, LastRoundxS, PTxDI, RCONxD,
                                     RstxBI, S01xD, SboxOutxD, StartxSI,
                                     State1xS, StateKEYADDITION1o3xS,
                                     StateKEYADDITION2o3xS,
                                     StateKEYADDITION3o3xS, StateKEYSCHEDULExS,
                                     StateOutxD, StateSHIFTROWSxS) is
      -- Variables
      variable last4Cycles     : std_logic;  -- during cycles 17-20
      variable SxorK           : t_shared_gf8(N downto 0);  -- S00 + K00
      variable KxorSBOXxorRCON : t_shared_gf8(N downto 0);  -- key schedule
    begin  -- process input_output_select_p

       -- for each share
      for i in N downto 0 loop
        -- Variable assignments
        SxorK(i) := StateOutxD(i) xor KeyOutxD(i);

        -- only for first share Key XOR RCON value
        if i = 0 then 
          KxorSBOXxorRCON(i) := KeyOutxD(i) xor SboxOutxD(i) xor RCONxD;
        else
          KxorSBOXxorRCON(i) := KeyOutxD(i) xor SboxOutxD(i);
        end if;

        -- last 4 cycles of 20 cycle round
        last4Cycles := StateKEYSCHEDULExS or StateSHIFTROWSxS;

        -- RCON control signals
        nextRCONxS <= StateSHIFTROWSxS;  -- Calc next RCON value
        showRCONxS <= State1xS;          -- RCON value appears on output

        -- Select input of Sbox
        if(last4Cycles = '1') then              -- during cycles 17-20:
          SboxInxD(i) <= KeyToSboxOutxD(i);     -- S13 to SBox
        elsif(LastRoundxS = '1') then           -- in preliminary round:
          SboxInxD(i) <= PTxDI(i) xor KxDI(i);  -- PT and key from outside
        elsif(StateKEYADDITION1o3xS = '1') then -- at first 4 cycles:
          if i = 0 then                         -- S00 + K00 + Sbox(S13) + RCON
            SboxInxD(i) <= SxorK(i) xor SboxOutxD(i) xor RCONxD;  
          else
            SboxInxD(i) <= SxorK(i) xor SboxOutxD(i);
          end if;
        else                                    -- default:
          SboxInxD(i) <= SxorK(i) xor K03xD(i); -- S00 + K00 + K03
        end if;

        -- Select input of State register
        if(StateKEYADDITION1o3xS = '1') then    -- in first 4 cycles
          if(LastRoundxS = '1') then            -- during preliminary round:
            StateInxD(i) <= KxDI(i);            -- take key from outside
          else  -- else:                                            
            StateInxD(i) <= KxorSBOXxorRCON(i); -- next round key bytes
          end if;
        else
          StateInxD(i) <= SboxOutxD(i);         -- per default take the Sbox output
        end if;

        -- Select input of Key register
        if(StateKEYADDITION2o3xS = '1') then        -- cycles 5-12:
          KeyInxD(i) <= KeyOutxD(i) xor K03xD(i);   -- take internal key + K03
        elsif(StateKEYADDITION3o3xS = '1') then     -- cycles 13-17:
          if(LastRoundxS = '1') then                -- on first round
            KeyInxD(i) <= KxDI(i);                  -- take external key
          else
            KeyInxD(i) <= KeyOutxD(i) xor K03xD(i); -- internal key + K03
          end if;
        elsif(last4Cycles = '1') then               -- during cycles 17-20:
          KeyInxD(i) <= K03xD(i);                   -- rotate vertically
        else                                        -- else:
          KeyInxD(i) <= KxorSBOXxorRCON(i);         -- next round key bytes
        end if;

        -- Select input of second K register input
        if(StateKEYADDITION1o3xS = '1') then                 -- in first 4 cycles
          KeyInterleavedxD(i)   <= K03xD(i);                 -- meander movement
        elsif(StateKEYADDITION2o3xS = '1') then              -- cycles 5-12:
          if (LastRoundxS = '1') then                        -- on first round
            KeyInterleavedxD(i) <= KxDI(i);                  -- take external key
          else                                               -- otherwise:
            KeyInterleavedxD(i) <= KeyOutxD(i) xor K03xD(i); -- internal key + K03
          end if;
        elsif(StateKEYADDITION3o3xS = '1') then              -- cycles 13-17:
          KeyInterleavedxD(i)   <= S01xD(i);                 -- write stored K bytes back
        elsif(last4Cycles = '1') then                        -- during cycles 17-20:
          KeyInterleavedxD(i) <= KeyOutxD(i);                -- internal key
        else                                                 -- else:
          KeyInterleavedxD(i) <= KxDI(i);                    -- take external key
        end if;

        -- Outputs last State xor last round key
        if(StateKEYADDITION1o3xS = '1') then
          if i = 0 then
            CxDO(i)  <= StateOutxD(i)  xor KeyOutxD(i)  xor SboxOutxD(i)  xor RCONxD;
          else
            CxDO(i)  <= StateOutxD(i)  xor KeyOutxD(i)  xor SboxOutxD(i);
          end if;
        else
          CxDO(i)  <= StateOutxD(i)  xor KeyOutxD(i)  xor K03xD(i) ;
        end if;
      end loop;  -- i

      -- Move K register up during cycles 13 - 20
      moveKupxS <= not(StateKEYADDITION1o3xS or StateKEYADDITION2o3xS);

      -- Signal that calculations are finished and CT appears at output
      DonexSO <= State1xS and LastRoundxS;

      -- Reset RCON on start 
      RstRCONxS <= RstxBI and not StartxSI;
    end process input_output_select_p;
  end generate perfetly_interleaved_variant;

  ----
  -- Select special controller for 7-staged Sbox
  controller_7staged_sbox_g: if EIGHT_STAGED_SBOX = "yes" generate
    aes_ctrl_lsfr_23_cycles_1: entity work.aes_ctrl_lsfr_23_cycles
      port map (
        ClkxCI                => ClkxCI,
        RstxBI                => RstxBI,
        StartxSI              => StartxSI,
        LastRoundxSI          => LastRoundxS,
        StateIDLExS           => StateIDLExS,
        State1xS              => State1xS,
        StateKEYADDITION1o3xS => StateKEYADDITION1o3xS,
        StateKEYADDITION2o3xS => StateKEYADDITION2o3xS,
        StateKEYADDITION3o3xS => StateKEYADDITION3o3xS,
        StateKEYSCHEDULExS    => StateKEYSCHEDULExS,
        StateSHIFTROWSxS      => StateSHIFTROWSxS,
        disableKeyRegsxS      => disableKeyRegsxS,
        doMixColumnsxS        => doMixColumnsxS);
  end generate controller_7staged_sbox_g;
  -- else generate
  controller_selection_g: if EIGHT_STAGED_SBOX = "no" generate
    -- Control FSM, implemented as LFSR
    aes_ctrl_lsfr_1 : entity work.aes_ctrl_lsfr
      port map (
        ClkxCI                => ClkxCI,
        RstxBI                => RstxBI,
        StartxSI              => StartxSI,
        LastRoundxSI          => LastRoundxS,
        StateIDLExS           => StateIDLExS,
        StateSHIFTROWSxS      => StateSHIFTROWSxS,
        StateKEYADDITION1o3xS => StateKEYADDITION1o3xS,
        StateKEYADDITION2o3xS => StateKEYADDITION2o3xS,
        StateKEYADDITION3o3xS => StateKEYADDITION3o3xS,
        StateKEYSCHEDULExS    => StateKEYSCHEDULExS,
        State1xS              => State1xS,
        doMixColumnsxS        => doMixColumnsxS);
  end generate controller_selection_g;
  

  -- Round constant (RCON) calculation
  rcon_1 : entity work.rcon
    generic map (
      PERFECTLY_INTERLEAVED => PERFECTLY_INTERLEAVED)
    port map (
      ClkxCI       => ClkxCI,
      RstxBI       => RstRCONxS,
      NextxSI      => nextRCONxS,
      ActivexSI    => showRCONxS,
      LastRoundxSO => LastRoundxS,
      FinishedxSO  => FinishedxS,
      RCONxDO      => RCONxD);

  -----------------------------------------------------------------------------
  -- Data path
  -- Sbox
  aes_sbox : entity work.aes_sbox
    generic map (
      PIPELINED    => "yes",
      EIGHT_STAGED => EIGHT_STAGED_SBOX,
      SHARES       => N + 1)
    port map (
      ClkxCI   => ClkxCI,
      RstxBI   => RstxBI,
      XxDI     => SboxInxD,
      Zmul1xDI => Zmul1xDI,
      Zmul2xDI => Zmul2xDI,
      Zmul3xDI => Zmul3xDI,
      Zinv1xDI => Zinv1xDI,
      Zinv2xDI => Zinv2xDI,
      Zinv3xDI => Zinv3xDI,
      Bmul1xDI => Bmul1xDI,
      Binv1xDI => Binv1xDI,
      Binv2xDI => Binv2xDI,
      Binv3xDI => Binv3xDI,
      QxDO     => SboxOutxDtmp);

  -- Only for "Unprotected" variant, insert artificial pipelining
  pipelinig_for_unprotected_g: if N = 0 generate
    pipeline_regs_p : process (ClkxCI, RstxBI) is
    begin  -- process pipeline_regs_p
      if RstxBI = '0' then              -- asynchronous reset (active low)
        Sbox0xDP <= (others => '0');
        Sbox1xDP <= (others => '0');
        Sbox2xDP <= (others => '0');
        Sbox3xDP <= (others => '0');
      elsif ClkxCI'event and ClkxCI = '1' then  -- rising clock edge
        Sbox0xDP <= Sbox1xDP;
        Sbox1xDP <= Sbox2xDP;
        Sbox2xDP <= Sbox3xDP;
        Sbox3xDP <= SboxOutxDtmp(0);
      end if;
    end process pipeline_regs_p;

    SboxOutxD(0) <= Sbox0xDP;
  end generate pipelinig_for_unprotected_g;
  -- else (for all masked variants)
  sbox_output_g: if N > 0 generate
    -- use pipelining registers
    SboxOutxD <= SboxOutxDtmp;
  end generate sbox_output_g;
  
  -- Generate registers for each share
  generate_registers_g: for i in N downto 0 generate
    -- Key regs K00 - K33
    aes_key_regs: entity work.aes_key_regs
    generic map (
      PERFECTLY_INTERLEAVED => PERFECTLY_INTERLEAVED
      )
    port map (
      ClkxCI            => ClkKeyRegxC,
      RstxBI            => RstxBI,
      KeyInxDI          => KeyInxD(i),
      KeyInterleavedxDI => KeyInterleavedxD(i),
      KeySchedulexSI    => moveKupxS,
      KeyOutxDO         => KeyOutxD(i),
      KeyToSboxOutxDO   => KeyToSboxOutxD(i),
      K03xDO            => K03xD(i));

    -- Share A State register S00 - S33
    aes_state_regs: entity work.aes_state_regs
    port map (
      ClkxCI        => ClkxCI,
      RstxBI        => RstxBI,
      StateInxDI    => StateInxD(i),
      ShiftRowsxSI  => StateSHIFTROWSxS,
      MixColumnsxSI => doMixColumnsxS,
      StateOutxDO   => StateOutxD(i),
      S01xDO        => S01xD(i));
  end generate generate_registers_g;
end behavorial;
