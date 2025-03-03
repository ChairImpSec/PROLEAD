#include "Hardware/Expression.hpp"

std::vector<std::pair<std::string, std::vector<std::string>>>
    expr_lib = {
        {"A1 and A2", {"A1", "A2"}},
        {"not (A1 and A2)", {"A1", "A2"}},
        {"A1 or A2", {"A1", "A2"}},
        {"not (A1 or A2)", {"A1", "A2"}},
        {"A xor B", {"A", "B"}},
        {"not (A xor B)", {"A", "B"}},
        {"A1 and A2 and A3", {"A1", "A2", "A3"}},
        {"not (A1 and A2 and A3)", {"A1", "A2", "A3"}},
        {"A1 or A2 or A3", {"A1", "A2", "A3"}},
        {"not (A1 or A2 or A3)", {"A1", "A2", "A3"}},
        {"A xor B xor C", {"A", "B", "C"}},
        {"not (A xor B xor C)", {"A", "B", "C"}},
        {"A1 and A2 and A3 and A4", {"A1", "A2", "A3", "A4"}},
        {"not (A1 and A2 and A3 and A4)", {"A1", "A2", "A3", "A4"}},
        {"A1 or A2 or A3 or A4", {"A1", "A2", "A3", "A4"}},
        {"not (A1 or A2 or A3 or A4)", {"A1", "A2", "A3", "A4"}},
        {"A xor B xor C xor D", {"A", "B", "C", "D"}},
        {"not (A xor B xor C xor B)", {"A", "B", "C", "D"}},
        {"not A", {"A"}},
        {"not (not A)", {"A"}}};

std::vector<std::pair<std::string, std::vector<std::string>>>
    expr_glitch_ext_lib = {
        {"(A1' and (not A1) and (not B1') and B1) or ((not A1') and A1 and B1' "
         "and (not B1)) or (g_A1 and (B1' or B1 or g_B1)) or (g_B1 and (A1' or "
         "A1 or g_A1))",
         {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1"}}},
        {"(A1' and (not A1) and (not B1') and B1) or ((not A1') and A1 and B1' "
         "and (not B1)) or (g_A1 and (B1' or B1 or g_B1)) or (g_B1 and (A1' or "
         "A1 or g_A1))",
         {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1"}}},
        {"(A1' and (not A1) and (not B1') and B1) or ((not A1') and A1 and B1' "
         "and (not B1)) or (g_A1 and ((not B1') or (not B1) or g_B1)) or (g_B1 "
         "and ((not A1') or (not A1) or g_A1))",
         {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1"}}},
        {"(A1' and (not A1) and (not B1') and B1) or ((not A1') and A1 and B1' "
         "and (not B1)) or (g_A1 and ((not B1') or (not B1) or g_B1)) or (g_B1 "
         "and ((not A1') or (not A1) or g_A1))",
         {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1"}}},
        {"((A' xor A) and (B' xor B)) or g_A or g_B",
         {"A'", "A", "g_A", "B'", "B", "g_B"}},
        {"((A' xor A) and (B' xor B)) or g_A or g_B",
         {"A'", "A", "g_A", "B'", "B", "g_B"}},
        {"((A1' and (not A1) and (not A2') and A2) or ((not A1') and A1 and "
         "A2' and (not A2))) and (A3' or A3 or g_A3) or ((A1' and (not A1) and "
         "(not A3') and A3) or ((not A1') and A1 and A3' and (not A3))) and "
         "(A2' or A2 or g_A2) or ((A2' and (not A2) and (not A3') and A3) or "
         "((not A2') and A2 and A3' and (not A3))) and (A1' or A1 or g_A1) or "
         "g_A1 and (A2' or A2 or g_A2) and (A3' or A3 or g_A3) or g_A2 and "
         "(A1' or A1 or g_A1) and (A3' or A3 or g_A3) or g_A3 and (A1' or A1 "
         "or g_A1) and (A2' or A2 or g_A2)",
         {{"A1'", "A1", "g_A1", "A2'", "A2", "g_A2", "A3'", "A3", "g_A3"}}},
        {"((A1' and (not A1) and (not A2') and A2) or ((not A1') and A1 and "
         "A2' and (not A2))) and (A3' or A3 or g_A3) or ((A1' and (not A1) and "
         "(not A3') and A3) or ((not A1') and A1 and A3' and (not A3))) and "
         "(A2' or A2 or g_A2) or ((A2' and (not A2) and (not A3') and A3) or "
         "((not A2') and A2 and A3' and (not A3))) and (A1' or A1 or g_A1) or "
         "g_A1 and (A2' or A2 or g_A2) and (A3' or A3 or g_A3) or g_A2 and "
         "(A1' or A1 or g_A1) and (A3' or A3 or g_A3) or g_A3 and (A1' or A1 "
         "or g_A1) and (A2' or A2 or g_A2)",
         {{"A1'", "A1", "g_A1", "A2'", "A2", "g_A2", "A3'", "A3", "g_A3"}}},
        {"((A1' and (not A1) and (not A2') and A2) or ((not A1') and A1 and "
         "A2' and (not A2))) and ((not A3') or (not A3) or g_A3) or ((A1' and "
         "(not A1) and (not A3') and A3) or ((not A1') and A1 and A3' and (not "
         "A3))) and ((not A2') or (not A2) or g_A2) or ((A2' and (not A2) and "
         "(not A3') and A3) or ((not A2') and A2 and A3' and (not A3))) and "
         "((not A1') or (not A1) or g_A1) or g_A1 and ((not A2') or (not A2) "
         "or g_A2) and ((not A3') or (not A3) or g_A3) or g_A2 and ((not A1') "
         "or (not A1) or g_A1) and ((not A3') or (not A3) or g_A3) or g_A3 and "
         "((not A1') or (not A1) or g_A1) and ((not A2') or (not A2) or g_A2)",
         {{"A1'", "A1", "g_A1", "A2'", "A2", "g_A2", "A3'", "A3", "g_A3"}}},
        {"((A1' and (not A1) and (not A2') and A2) or ((not A1') and A1 and "
         "A2' and (not A2))) and ((not A3') or (not A3) or g_A3) or ((A1' and "
         "(not A1) and (not A3') and A3) or ((not A1') and A1 and A3' and (not "
         "A3))) and ((not A2') or (not A2) or g_A2) or ((A2' and (not A2) and "
         "(not A3') and A3) or ((not A2') and A2 and A3' and (not A3))) and "
         "((not A1') or (not A1) or g_A1) or g_A1 and ((not A2') or (not A2) "
         "or g_A2) and ((not A3') or (not A3) or g_A3) or g_A2 and ((not A1') "
         "or (not A1) or g_A1) and ((not A3') or (not A3) or g_A3) or g_A3 and "
         "((not A1') or (not A1) or g_A1) and ((not A2') or (not A2) or g_A2)",
         {{"A1'", "A1", "g_A1", "A2'", "A2", "g_A2", "A3'", "A3", "g_A3"}}},
        {"((A' xor A) and (B' xor B)) or ((A' xor A) and (C' xor C)) or ((B' "
         "xor B) and (C' xor C)) or g_A or g_B or g_C",
         {"A'", "A", "g_A", "B'", "B", "g_B", "C'", "C", "g_C"}},
        {"((A' xor A) and (B' xor B)) or ((A' xor A) and (C' xor C)) or ((B' "
         "xor B) and (C' xor C)) or g_A or g_B or g_C",
         {"A'", "A", "g_A", "B'", "B", "g_B", "C'", "C", "g_C"}},
        {"((A1' and (not A1) and (not A2') and A2) or ((not A1') and A1 and "
         "A2' and (not A2))) and (A3' or A3 or g_A3) and (A4' or A4 or g_A4) "
         "or ((A1' and (not A1) and (not A3') and A3) or ((not A1') and A1 and "
         "A3' and (not A3))) and (A2' or A2 or g_A2) and (A4' or A4 or g_A4) "
         "or ((A1' and (not A1) and (not A4') and A4) or ((not A1') and A1 and "
         "A4' and (not A4))) and (A2' or A2 or g_A2) and (A3' or A3 or g_A3) "
         "or ((A2' and (not A2) and (not A3') and A3) or ((not A2') and A2 and "
         "A3' and (not A3))) and (A1' or A1 or g_A1) and (A4' or A4 or g_A4) "
         "or ((A2' and (not A2) and (not A4') and A4) or ((not A2') and A2 and "
         "A4' and (not A4))) and (A1' or A1 or g_A1) and (A3' or A3 or g_A3) "
         "or ((A3' and (not A3) and (not A4') and A4) or ((not A3') and A3 and "
         "A4' and (not A4))) and (A1' or A1 or g_A1) and (A2' or A2 or g_A2) "
         "or g_A1 and (A2' or A2 or g_A2) and (A3' or A3 or g_A3) and (A4' or "
         "A4 or g_A4) or g_A2 and (A1' or A1 or g_A1) and (A3' or A3 or g_A3) "
         "and (A4' or A4 or g_A4) or g_A3 and (A1' or A1 or g_A1) and (A2' or "
         "A2 or g_A2) and (A4' or A4 or g_A4) or g_A4 and (A1' or A1 or g_A1) "
         "and (A2' or A2 or g_A2) and (A3' or A3 or g_A3)",
         {{"A1'", "A1", "g_A1", "A2'", "A2", "g_A2", "A3'", "A3", "g_A3", "A4'",
           "A4", "g_A4"}}},
        {"((A1' and (not A1) and (not A2') and A2) or ((not A1') and A1 and "
         "A2' and (not A2))) and (A3' or A3 or g_A3) and (A4' or A4 or g_A4) "
         "or ((A1' and (not A1) and (not A3') and A3) or ((not A1') and A1 and "
         "A3' and (not A3))) and (A2' or A2 or g_A2) and (A4' or A4 or g_A4) "
         "or ((A1' and (not A1) and (not A4') and A4) or ((not A1') and A1 and "
         "A4' and (not A4))) and (A2' or A2 or g_A2) and (A3' or A3 or g_A3) "
         "or ((A2' and (not A2) and (not A3') and A3) or ((not A2') and A2 and "
         "A3' and (not A3))) and (A1' or A1 or g_A1) and (A4' or A4 or g_A4) "
         "or ((A2' and (not A2) and (not A4') and A4) or ((not A2') and A2 and "
         "A4' and (not A4))) and (A1' or A1 or g_A1) and (A3' or A3 or g_A3) "
         "or ((A3' and (not A3) and (not A4') and A4) or ((not A3') and A3 and "
         "A4' and (not A4))) and (A1' or A1 or g_A1) and (A2' or A2 or g_A2) "
         "or g_A1 and (A2' or A2 or g_A2) and (A3' or A3 or g_A3) and (A4' or "
         "A4 or g_A4) or g_A2 and (A1' or A1 or g_A1) and (A3' or A3 or g_A3) "
         "and (A4' or A4 or g_A4) or g_A3 and (A1' or A1 or g_A1) and (A2' or "
         "A2 or g_A2) and (A4' or A4 or g_A4) or g_A4 and (A1' or A1 or g_A1) "
         "and (A2' or A2 or g_A2) and (A3' or A3 or g_A3)",
         {{"A1'", "A1", "g_A1", "A2'", "A2", "g_A2", "A3'", "A3", "g_A3", "A4'",
           "A4", "g_A4"}}},
        {"((A1' and (not A1) and (not A2') and A2) or ((not A1') and A1 and "
         "A2' and (not A2))) and ((not A3') or (not A3) or g_A3) and ((not "
         "A4') or (not A4) or g_A4) or ((A1' and (not A1) and (not A3') and "
         "A3) or ((not A1') and A1 and A3' and (not A3))) and ((not A2') or "
         "(not A2) or g_A2) and ((not A4') or (not A4) or g_A4) or ((A1' and "
         "(not A1) and (not A4') and A4) or ((not A1') and A1 and A4' and (not "
         "A4))) and ((not A2') or (not A2) or g_A2) and ((not A3') or (not A3) "
         "or g_A3) or ((A2' and (not A2) and (not A3') and A3) or ((not A2') "
         "and A2 and A3' and (not A3))) and ((not A1') or (not A1) or g_A1) "
         "and ((not A4') or (not A4) or g_A4) or ((A2' and (not A2) and (not "
         "A4') and A4) or ((not A2') and A2 and A4' and (not A4))) and ((not "
         "A1') or (not A1) or g_A1) and ((not A3') or (not A3) or g_A3) or "
         "((A3' and (not A3) and (not A4') and A4) or ((not A3') and A3 and "
         "A4' and (not A4))) and ((not A1') or (not A1) or g_A1) and ((not "
         "A2') or (not A2) or g_A2) or g_A1 and((not A2') or (not A2) or g_A2) "
         "and ((not A3') or (not A3) or g_A3) and ((not A4') or (not A4) or "
         "g_A4) or g_A2 and ((not A1') or (not A1) or g_A1) and ((not A3') or "
         "(not A3) or g_A3) and ((not A4') or (not A4) or g_A4) or g_A3 and "
         "((not A1') or (not A1) or g_A1) and ((not A2') or (not A2) or g_A2) "
         "and ((not A4') or (not A4) or g_A4) or g_A4 and ((not A1') or (not "
         "A1) or g_A1) and ((not A2') or (not A2) or g_A2) and ((not A3') or "
         "(not A3) or g_A3)",
         {"A1'", "A1", "g_A1", "A2'", "A2", "g_A2", "A3'", "A3", "g_A3", "A4'",
          "A4", "g_A4"}},
        {"((A1' and (not A1) and (not A2') and A2) or ((not A1') and A1 and "
         "A2' and (not A2))) and ((not A3') or (not A3) or g_A3) and ((not "
         "A4') or (not A4) or g_A4) or ((A1' and (not A1) and (not A3') and "
         "A3) or ((not A1') and A1 and A3' and (not A3))) and ((not A2') or "
         "(not A2) or g_A2) and ((not A4') or (not A4) or g_A4) or ((A1' and "
         "(not A1) and (not A4') and A4) or ((not A1') and A1 and A4' and (not "
         "A4))) and ((not A2') or (not A2) or g_A2) and ((not A3') or (not A3) "
         "or g_A3) or ((A2' and (not A2) and (not A3') and A3) or ((not A2') "
         "and A2 and A3' and (not A3))) and ((not A1') or (not A1) or g_A1) "
         "and ((not A4') or (not A4) or g_A4) or ((A2' and (not A2) and (not "
         "A4') and A4) or ((not A2') and A2 and A4' and (not A4))) and ((not "
         "A1') or (not A1) or g_A1) and ((not A3') or (not A3) or g_A3) or "
         "((A3' and (not A3) and (not A4') and A4) or ((not A3') and A3 and "
         "A4' and (not A4))) and ((not A1') or (not A1) or g_A1) and ((not "
         "A2') or (not A2) or g_A2) or g_A1 and((not A2') or (not A2) or g_A2) "
         "and ((not A3') or (not A3) or g_A3) and ((not A4') or (not A4) or "
         "g_A4) or g_A2 and ((not A1') or (not A1) or g_A1) and ((not A3') or "
         "(not A3) or g_A3) and ((not A4') or (not A4) or g_A4) or g_A3 and "
         "((not A1') or (not A1) or g_A1) and ((not A2') or (not A2) or g_A2) "
         "and ((not A4') or (not A4) or g_A4) or g_A4 and ((not A1') or (not "
         "A1) or g_A1) and ((not A2') or (not A2) or g_A2) and ((not A3') or "
         "(not A3) or g_A3)",
         {"A1'", "A1", "g_A1", "A2'", "A2", "g_A2", "A3'", "A3", "g_A3", "A4'",
          "A4", "g_A4"}},
        {"((A1' xor A1) and (A2' xor A2)) or ((A' xor A) and (C' xor C)) or "
         "((A' xor A) and (D' xor D)) or ((B' xor B) and (C' xor C)) or ((B' "
         "xor B) and (D' xor D)) or ((C' xor C) and (D' xor D)) or g_A or g_B "
         "or g_C or g_D",
         {"A'", "A", "g_A", "B'", "B", "g_B", "C'", "C", "g_C", "D'", "D",
          "g_D"}},
        {"((A1' xor A1) and (A2' xor A2)) or ((A' xor A) and (C' xor C)) or "
         "((A' xor A) and (D' xor D)) or ((B' xor B) and (C' xor C)) or ((B' "
         "xor B) and (D' xor D)) or ((C' xor C) and (D' xor D)) or g_A or g_B "
         "or g_C or g_D",
         {"A'", "A", "g_A", "B'", "B", "g_B", "C'", "C", "g_C", "D'", "D",
          "g_D"}},
        {"1", {}},
        {"1", {}}};

std::vector<std::pair<std::string, std::vector<std::string>>>
    expr_probe_prop_lib = {
        {"(A1' or A1 or g_A1) and (B1' or B1 or g_B1)",
         {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1"}}},
        {"(A1' or A1 or g_A1) and (B1' or B1 or g_B1)",
         {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1"}}},
        {"((not A1') or (not A1) or g_A1) and ((not B1') or (not B1) or g_B1)",
         {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1"}}},
        {"((not A1') or (not A1) or g_A1) and ((not B1') or (not B1) or g_B1)",
         {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1"}}},
        {"((A' xor A) or g_A) or ((B' xor B) or g_B)",
         {"A'", "A", "g_A", "B'", "B", "g_B"}},
        {"((A' xor A) or g_A) or ((B' xor B) or g_B)",
         {"A'", "A", "g_A", "B'", "B", "g_B"}},
        {"(A1' or A1 or g_A1) and (B1' or B1 or g_B1) and (C1' or C1 or g_C1)",
         {"A1'", "A1", "g_A1", "B1'", "B1", "g_B1", "C1'", "C1", "g_C1"}},
        {"(A1' or A1 or g_A1) and (B1' or B1 or g_B1) and (C1' or C1 or g_C1)",
         {"A1'", "A1", "g_A1", "B1'", "B1", "g_B1", "C1'", "C1", "g_C1"}},
        {"((not A1') or (not A1) or g_A1) and ((not B1') or (not B1) or g_B1) "
         "and ((not C1') or (not C1) or g_C1)",
         {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1", "C1'", "C1", "g_C1"}}},
        {"((not A1') or (not A1) or g_A1) and ((not B1') or (not B1) or g_B1) "
         "and ((not C1') or (not C1) or g_C1)",
         {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1", "C1'", "C1", "g_C1"}}},
        {"((A' xor A) or g_A) or ((B' xor B) or g_B) or ((C' xor C) or g_C)",
         {"A'", "A", "g_A", "B'", "B", "g_B", "C'", "C", "g_C"}},
        {"((A' xor A) or g_A) or ((B' xor B) or g_B) or ((C' xor C) or g_C)",
         {"A'", "A", "g_A", "B'", "B", "g_B", "C'", "C", "g_C"}},
        {"(A1' or A1 or g_A1) and (B1' or B1 or g_B1) and (C1' or C1 or g_C1) "
         "and (D1' or D1 or g_D1)",
         {"A1'", "A1", "g_A1", "B1'", "B1", "g_B1", "C1'", "C1", "g_C1", "D1'",
          "D1", "g_D1"}},
        {"(A1' or A1 or g_A1) and (B1' or B1 or g_B1) and (C1' or C1 or g_C1) "
         "and (D1' or D1 or g_D1)",
         {"A1'", "A1", "g_A1", "B1'", "B1", "g_B1", "C1'", "C1", "g_C1", "D1'",
          "D1", "g_D1"}},
        {"((not A1') or (not A1) or g_A1) and ((not B1') or (not B1) or g_B1) "
         "and ((not C1') or (not C1) or g_C1) and ((not D1') or (not D1) or "
         "g_D1)",
         {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1", "C1'", "C1", "g_C1", "D1'",
           "D1", "g_D1"}}},
        {"((not A1') or (not A1) or g_A1) and ((not B1') or (not B1) or g_B1) "
         "and ((not C1') or (not C1) or g_C1) and ((not D1') or (not D1) or "
         "g_D1)",
         {{"A1'", "A1", "g_A1", "B1'", "B1", "g_B1", "C1'", "C1", "g_C1", "D1'",
           "D1", "g_D1"}}},
        {"((A' xor A) or g_A) or ((B' xor B) or g_B) or ((C' xor C) or g_C) or "
         "((D' xor D) or g_D)",
         {"A'", "A", "g_A", "B'", "B", "g_B", "C'", "C", "g_C", "D'", "D",
          "g_D"}},
        {"((A' xor A) or g_A) or ((B' xor B) or g_B) or ((C' xor C) or g_C) or "
         "((D' xor D) or g_D)",
         {"A'", "A", "g_A", "B'", "B", "g_B", "C'", "C", "g_C", "D'", "D",
          "g_D"}},
        {"1", {}},
        {"1", {}}};

Expression::Expression(const std::string& expr,
                       std::vector<std::string> names) {
  number_of_inputs_ = names.size();
  BoolExprGrammar grammar;
  clauses_ = grammar.Parse(expr, names);
}

uint64_t Expression::GetNumberOfInputs() const { return number_of_inputs_; }

uint64_t Expression::Eval(std::vector<uint64_t> vals) const {
  vals.reserve(vals.size() + clauses_.size());
  for (const auto& clause : clauses_) {
    vals.push_back(clause.Eval(vals));
  }
  return vals.back();
}