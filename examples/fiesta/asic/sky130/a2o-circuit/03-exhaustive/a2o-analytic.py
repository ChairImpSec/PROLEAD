def a2o():
  lut_and0 = [0, 0, 0, 1]
  lut_and1 = [0, 0, 0, 1]
  lut_xor  = [0, 1, 1, 0]

  return lut_and0, lut_and1, lut_xor

def apply_stuck_at_one_fault(state, f_and0, f_and1, f_xor):
  state_faulted = state.copy()
  if f_and0 == 1:
    state_faulted[0] = 1
  if f_and1 == 1:
    state_faulted[1] = 1
  if f_xor == 1:
    state_faulted[2] = 1

  return state_faulted


def main():

  ctr_effective_fault = 0
  for f_and0 in [0,1]:
    for f_and1 in [0,1]:
      for f_xor in [0,1]:
        for a in [0,1]:
          for b in [0,1]:
            for c in [0,1]:
              for d in [0,1]:
                lut_and0, lut_and1, lut_xor = a2o()
                lut_and0_in = (b << 1) | a
                lut_and0_out = lut_and0[lut_and0_in]
                lut_and0_out_faulted = lut_and0_out
                if f_and0 == 1:
                  lut_and0_out_faulted = 1

                lut_and1_in = (d << 1) | c
                lut_and1_out = lut_and1[lut_and1_in]
                lut_and1_out_faulted = lut_and1_out
                if f_and1 == 1:
                  lut_and1_out_faulted = 1

                lut_xor_in = (lut_and1_out << 1) | lut_and0_out
                lut_xor_out = lut_xor[lut_xor_in]

                lut_xor_in_faulted = (lut_and1_out_faulted << 1) | lut_and0_out_faulted
                lut_xor_out_faulted = lut_xor[lut_xor_in_faulted]
                if f_xor == 1:
                  lut_xor_out_faulted = 1

                print(f"Input {a}{b}{c}{d} - Fault {f_and0}{f_and1}{f_xor} - Result {lut_xor_out}")
                print(f"Input {a}{b}{c}{d} - Fault {f_and0}{f_and1}{f_xor} - Result {lut_xor_out_faulted}")
                if lut_xor_out != lut_xor_out_faulted:
                  print(f"\tEffective fault {lut_xor_out} != {lut_xor_out_faulted}")
                  ctr_effective_fault = ctr_effective_fault + 1

  print(f"Effective Faults: {ctr_effective_fault}")



if __name__ == "__main__":
  main()
