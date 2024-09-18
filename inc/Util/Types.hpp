// TODO: Add file header if we use this and do not discard it!
#pragma once

enum class Analysis { none, univariate, multivariate, exclusive_multivariate };
enum class Minimization { none, trivial, aggressive };
enum class FaultType { none, stuck_at_0, stuck_at_1, toggle };
// enum class FaultType {
//   None = 0b000,
//   StuckAt0 = 0b100,
//   StuckAt1 = 0b010,
//   Toggle = 0b001,
// };
enum class FaultAnalysis { none, only_fault_free_simulations, only_faulty_simulations, both};
