#include "Hardware/Circuit.hpp"

bool SignalStruct::operator<(const SignalStruct& other) const {
  return id < other.id;
}

bool SignalStruct::operator==(const SignalStruct& other) const {
  return id == other.id;
}

bool SignalStruct::operator!=(const SignalStruct& other) const {
  return id != other.id;
}

char *safe_strcpy(char *dest, const char *src, size_t size) {
    if (size > 0) {
        *dest = '\0';
        return strncat(dest, src, size);
    }
    return dest;
}

std::string parseNextWord(std::string::iterator& it,
                          const std::string::iterator& end) {
  if (it == end)
    throw std::runtime_error("parseNextWord was called on empty string");
  std::string::iterator word_end = it;
  while (word_end != end && !std::isspace(*word_end)) {
    ++word_end;
  }
  std::string word(it, word_end);

  it = word_end;
  while (std::isspace(*it)) ++it;
  return word;
}

void NonCommentFromFile(FILE* FileHeader, char* Str,
                        const char* CommentSyntax) {
  int l;
  char ch;

  Str[0] = 0;

  l = (int)strlen(CommentSyntax);
  do {
    if (fscanf(FileHeader, "%s", Str)) {
      if (!memcmp(CommentSyntax, Str, l)) {
        do ch = fgetc(FileHeader);
        while ((ch != '\n') && (ch != '\r') && (!feof(FileHeader)));
      }
    }
  } while ((!memcmp(CommentSyntax, Str, l)) && (!feof(FileHeader)));
}

void fReadaWord(FileBufferStruct* FileBuffer, char* Buffer, char* Attribute) {
  // reset Buffer
  memset(Buffer, 0, 10);  // Max_Name_Len

  static char Lastch = 0;
  char ch = 0;
  int i = 0;
  int j = 0;
  char BracketOpened = 0;

  if (Attribute) Attribute[0] = 0;

  while ((FileBuffer->Index <= FileBuffer->Size) || Lastch) {
    if (Lastch)
      ch = Lastch;
    else
      ch = FileBuffer->Buffer[FileBuffer->Index++];

    if ((FileBuffer->Index <= FileBuffer->Size) || Lastch) {
      Lastch = 0;

      if ((ch == 32) || (ch == 13) || (ch == 10) || (ch == 9)) {
        if (i && (!BracketOpened)) break;
      } else if ((ch == '(') || (ch == ')')) {
        if (i) {
          Lastch = ch;
          break;
        } else {
          Buffer[i++] = ch;

          if (ch == '(') {
            ch = FileBuffer->Buffer[FileBuffer->Index++];
            if (ch == '*') {
              while (FileBuffer->Index <= FileBuffer->Size) {
                ch = FileBuffer->Buffer[FileBuffer->Index++];
                if ((Buffer[i] == '*') && (ch == ')'))
                  break;
                else {
                  Buffer[i] = ch;
                  if (Attribute) Attribute[j++] = ch;
                }
              }

              if (FileBuffer->Index <= FileBuffer->Size) {
                i--;
                j--;
              }
            } else {
              Lastch = ch;
              break;
            }
          } else
            break;
        }
      } else if ((ch == '/') && i) {
        if (Buffer[i - 1] == '/')  // start of the comment "//"
        {
          i--;

          while (FileBuffer->Index <= FileBuffer->Size) {
            ch = FileBuffer->Buffer[FileBuffer->Index++];
            if ((ch == '\n') || (ch == '\r')) break;
          }
        } else
          Buffer[i++] = ch;
      } else if ((ch == '*') && i) {
        if (Buffer[i - 1] == '/')  // start of the comment "/*"
        {
          i--;

          while (FileBuffer->Index <= FileBuffer->Size) {
            ch = FileBuffer->Buffer[FileBuffer->Index++];
            if ((Buffer[i] == '*') && (ch == '/'))
              break;
            else
              Buffer[i] = ch;
          }
        } else if (Buffer[i - 1] == '(')  // start of the attribute "(*"
        {
          i--;

          while (FileBuffer->Index <= FileBuffer->Size) {
            ch = FileBuffer->Buffer[FileBuffer->Index++];
            if ((Buffer[i] == '*') && (ch == ')'))
              break;
            else {
              Buffer[i] = ch;
              if (Attribute) Attribute[j++] = ch;
            }
          }

          if (FileBuffer->Index <= FileBuffer->Size) j--;
        }
      } else {
        Buffer[i++] = ch;

        if (ch == '{') BracketOpened = 1;

        if (ch == '}') BracketOpened = 0;
      }
    }
  }

  Buffer[i] = 0;
  if (Attribute) Attribute[j] = 0;
}

int TrimSignalName(char* SignalName, int* k) {
  int i, j, l;
  static char* Str = NULL;
  char* ptr;

  if (Str == NULL)
  	Str = (char*)malloc(Max_Name_Len * sizeof(char));

  j = -1;
  l = strlen(SignalName);

  if (SignalName[l - 1] == ']') {
    for (i = l - 2; i >= 0; i--)
      if (SignalName[i] == '[') break;

    if (i >= 0) {
      SignalName[i] = 0;
      safe_strcpy(Str, &SignalName[i + 1], Max_Name_Len - 1);
      Str[strlen(Str) - 1] = 0;
      ptr = strchr(Str, ':');
      if (ptr == NULL) {
        j = atoi(Str);
        if (k != NULL) *k = -1;
      } else {
        *ptr = 0;
        j = atoi(Str);
        if (k != NULL) *k = atoi(ptr + 1);
      }
    }
  }

  return (j);
}

uint64_t CellStruct::GetNumberOfProbeExtensions() const {
  return expr_glitch_ext_.size();
};

void CellStruct::Precomp(std::vector<uint64_t>& vals) const {
  uint64_t number_of_inputs = vals.size();
  vals.resize(number_of_inputs + expr_mids_.size());

  for (uint64_t idx = number_of_inputs; idx < vals.size(); ++idx) {
    vals[idx] = expr_mids_[idx - number_of_inputs].Eval(vals);
  }
}

uint64_t CellStruct::Eval(uint64_t idx, const std::vector<uint64_t>& vals) const {
  std::vector<uint64_t> vals_with_param;
  vals_with_param.reserve(vals.size() + params_.size());
  for (const std::pair<std::string, uint64_t>& param : params_) {
    vals_with_param.push_back(param.second);
  }

  vals_with_param.insert(vals_with_param.end(), vals.begin(), vals.end());
  return expr_[idx].Eval(vals_with_param);
}

TruthTable CellStruct::GenerateSmallEnablers(
    const std::vector<Expression>& expr_mids, const Expression& expr) {
  // contains all rows of truth table that are not a transition, glitch or c
  // != c'
  std::unordered_map<uint64_t, std::vector<std::vector<bool>>> valid_rows = {
      {0, {}}, {1, {}}};
  TruthTable truth_table(2 * type->GetNumberOfInputs());
  uint64_t c, c_mod;

  IterateEnablers it(type->GetNumberOfInputs(), false);
  do {
    std::vector<uint64_t> vals = it.GetNormVectorNumb();
    vals.reserve(vals.size() + expr_mids.size());
    for (const Expression& expr_mid : expr_mids) {
      vals.push_back(expr_mid.Eval(vals));
    }
    c = expr.Eval(vals) & 1;

    vals = it.GetModVectorNumb();
    vals.reserve(vals.size() + expr_mids.size());
    for (const Expression& expr_mid : expr_mids) {
      vals.push_back(expr_mid.Eval(vals));
    }
    c_mod = expr.Eval(vals) & 1;

    if (c != c_mod) {
      truth_table.SetF(it.GetIndexVectorSmall(), true);
      if (DetectGlitches(expr_mids, expr, it.GetNormVectorNumb(),
                         it.GetModVectorNumb(), true)) {
        truth_table.SetG(it.GetIndexVectorSmall(), true);
      }
      continue;  // transition
    }
    if (DetectGlitches(expr_mids, expr, it.GetNormVectorNumb(),
                       it.GetModVectorNumb(), false)) {
      truth_table.SetF(it.GetIndexVectorSmall(), true);
      truth_table.SetG(it.GetIndexVectorSmall(), true);
      continue;
    }
    truth_table.SetF(it.GetIndexVectorSmall(),
                     false);  // if it was the only instance set to true later
    truth_table.SetG(it.GetIndexVectorSmall(), false);
    valid_rows[c].push_back(it.GetIndexVectorSmall());
  } while (it.Iterate());

  for (auto valid_row : valid_rows) {
    if (valid_row.second.size() == 1) {
      truth_table.SetF(valid_row.second[0],
                       true);  // set F to false if output is distinguishable
    }
  }
  return truth_table;
}

void CellStruct::LookupGlitchesSmallTable(TruthTable& table,
                                          TruthTable& small_table,
                                          IterateEnablers& it) {
  std::vector<uint64_t> indexes;
  bool include_same_vector = false;
  for (uint64_t glitch_index = 0; glitch_index < type->GetNumberOfInputs();
       ++glitch_index) {
    if ((it.GetNormVectorBool()[glitch_index] ==
         it.GetModVectorBool()[glitch_index]) &&
        it.GetGlitchVectorBool()[glitch_index]) {
      indexes.push_back(glitch_index);
    } else {  // glitch happening during transition
      include_same_vector = true;
    }
  }
  bool f = small_table.GetF(it.GetIndexVectorSmall()), glitch = 0;
  // go through all subsets of indexes
  std::vector<bool> flipped_mod_vector;
  for (uint64_t bitmask = 0; bitmask < (1ULL << (indexes.size())); ++bitmask) {
    flipped_mod_vector = it.GetModVectorBool();
    for (uint64_t i = 0; i < indexes.size(); ++i) {
      if (bitmask & (1 << i))
        flipped_mod_vector[indexes[i]] = !flipped_mod_vector[indexes[i]];
    }
    f |= small_table.GetF(
        ConcatBoolVectors2(it.GetNormVectorBool(), flipped_mod_vector));
    glitch |= small_table.GetF(
        ConcatBoolVectors2(it.GetNormVectorBool(), flipped_mod_vector));
  }
  if (include_same_vector) glitch |= small_table.GetF(it.GetIndexVectorSmall());
  table.SetF(it.GetIndexVector(), f);
  table.SetG(it.GetIndexVector(), glitch);
}

bool CellStruct::DetectGlitches(const std::vector<Expression>& expr_mids,
                                const Expression& expr,
                                std::vector<uint64_t> const& norm_input,
                                std::vector<uint64_t> const& mod_input,
                                bool transition_allowed) {
  std::vector<uint64_t> flipped_indexes;
  for (uint64_t i = 0; i < norm_input.size(); ++i) {
    if (norm_input[i] != mod_input[i]) {
      flipped_indexes.push_back(i);
    }
  }
  bool value_changed;
  std::vector<uint64_t> intermediate_input;
  // perform transition between inputs in different orders
  do {
    intermediate_input = norm_input;
    value_changed = false;
    for (auto flipped_index : flipped_indexes) {
      intermediate_input[flipped_index] = intermediate_input[flipped_index] ^ 1;

      std::vector<uint64_t> vals1 = intermediate_input;
      vals1.reserve(vals1.size() + expr_mids.size());
      for (const Expression& expr_mid : expr_mids) {
        vals1.push_back(expr_mid.Eval(vals1));
      }

      std::vector<uint64_t> vals2 = norm_input;
      vals2.reserve(vals2.size() + expr_mids.size());
      for (const Expression& expr_mid : expr_mids) {
        vals2.push_back(expr_mid.Eval(vals2));
      }

      if ((expr.Eval(vals1) & 1) != (expr.Eval(vals2) & 1)) {
        if (transition_allowed) {
          value_changed = true;
        } else {
          return true;
        }

      } else if (value_changed) {
        if (value_changed && transition_allowed) return true;
      }
    }
  } while (std::next_permutation(
      flipped_indexes.begin(),
      flipped_indexes.end()));  // we start with the indexes sorted => it goes
  // through all permutations
  return false;
}

void CellStruct::GenerateRelaxedFunctions(
    const std::vector<Expression>& expr_mids, const Expression& expr) {
  TruthTable small_table = GenerateSmallEnablers(expr_mids, expr);

  TruthTable table(3 * type->GetNumberOfInputs());
  IterateEnablers it(type->GetNumberOfInputs(), true);
  do {
    if (it.GetGlitchNumber() == 0) {  // no glitches
      table.SetF(it.GetIndexVector(),
                 small_table.GetF(it.GetIndexVectorSmall()));
      table.SetG(it.GetIndexVector(),
                 small_table.GetG(it.GetIndexVectorSmall()));
      continue;
    }
    // If glitch happens without glitchy inputs it will continue to do so with
    // them
    if (small_table.GetG(it.GetIndexVectorSmall())) {
      table.SetF(it.GetIndexVector(), 1);
      table.SetG(it.GetIndexVector(), 1);
      continue;
    }
    // If toggle happens without glitchy inputs it will continue to do so with
    // them
    if (small_table.GetF(it.GetIndexVectorSmall()))
      table.SetF(it.GetIndexVector(), 1);
    LookupGlitchesSmallTable(table, small_table, it);
  } while (it.Iterate());

  expr_glitch_ext_.push_back(table.OperationFromTruthTable(true));
  expr_probe_prop_.push_back(table.OperationFromTruthTable(false));
}

void CellStruct::SetExpressions(bool relaxed) {
  std::vector<std::string> primary_signals;

  for (const std::pair<std::string, uint64_t>& param : params_) {
    primary_signals.push_back(param.first);
  }

  for (uint64_t idx = 0; idx < type->GetNumberOfInputs(); ++idx) {
    primary_signals.push_back(type->GetInput(idx));
  }

  for (uint64_t idx = 0; idx < type->GetNumberOfMids(); ++idx) {
    primary_signals.push_back(type->GetMid(idx));
  }

  if ((type->GetType() == cell_t::sequential) ||
      (type->GetType() == cell_t::latch)) {
    for (uint64_t idx = 0; idx < type->GetNumberOfOutputs(); ++idx) {
      primary_signals.push_back(type->GetOutput(idx));
    }
  }

  for (const std::string& expr : type->GetExprMids()) {
    expr_mids_.emplace_back(expr, primary_signals, params_);
  }

  for (const std::string& expr : type->GetExpr()) {
    expr_.emplace_back(expr, primary_signals, params_);

    if ((type->GetType() == cell_t::relaxed || type->GetType() == cell_t::buffer) && relaxed) {
      bool found = false;

      for (uint64_t lib_idx = 0; lib_idx < expr_lib.size(); ++lib_idx) {
        uint64_t number_of_inputs = primary_signals.size();
        if (number_of_inputs == expr_lib[lib_idx].second.size()) {
          bool equal = true;

          for (uint64_t in_idx = 0; in_idx < (1ULL << number_of_inputs);
               ++in_idx) {
            std::vector<uint64_t> vals(number_of_inputs, 0);

            for (uint64_t tmp_idx = 0; tmp_idx < number_of_inputs; ++tmp_idx) {
              vals[tmp_idx] = (in_idx & (1 << tmp_idx)) != 0;
            }

            vals.reserve(vals.size() + expr_mids_.size());
            for (const Expression& expr_mid : expr_mids_) {
              vals.push_back(expr_mid.Eval(vals));
            }

            Expression tmp_expr(expr_lib[lib_idx].first,
                                expr_lib[lib_idx].second, params_);

            if (expr_.back().Eval(vals) != tmp_expr.Eval(vals)) {
              equal = false;
              break;
            }
          }

          if (equal) {
            expr_glitch_ext_.emplace_back(expr_glitch_ext_lib[lib_idx].first,
                                          expr_glitch_ext_lib[lib_idx].second,
                                          params_);
            expr_probe_prop_.emplace_back(expr_probe_prop_lib[lib_idx].first,
                                          expr_probe_prop_lib[lib_idx].second,
                                          params_);
            found = true;
            break;
          }
        }
      }

      if (!found) {
        GenerateRelaxedFunctions(expr_mids_, expr_.back());
      }
    }
  }
}

CircuitStruct::CircuitStruct(const std::string& design_file_name,
                             const std::string& topmodule_name,
                             const Settings& settings, const Library& library) {
  ReadDesignFile(design_file_name, topmodule_name, settings, library, 0, 0, 0,
                 NULL);
  SetIsProbeAllowed(settings);
  SetIsExtensionAllowed(settings);
  SetIsAnalysisAllowed(settings);
  SetIsFaultAllowed(settings);
  BOOST_LOG_TRIVIAL(info) << topmodule_name << " is read!";

  for (uint64_t idx = 0; idx < cells_.size(); ++idx) {
    if (cells_[idx].type->GetType() != cell_t::sequential) {
      gates_.push_back(idx);
    } else {
      regs_.push_back(idx);
    }
  }

  MakeCircuitDepth(settings.IsRelaxedModel());

  uint64_t ctr = 0;
  for (SignalStruct& signal : signals_) {
    signal.id = ctr++;
  }
}

void CircuitStruct::MakeCircuitDepth(bool relaxed) {
  int i;
  int OutputIndex;
  int SignalIndex;
  int CellIndex;
  short DepthIndex;
  char all_have_depth;
  std::string ErrorMessage;

  for (uint64_t idx = 0; idx < (uint64_t)cells_.size(); ++idx) {
    cells_[idx].SetExpressions(relaxed);
  }

  for (DepthIndex = 1; DepthIndex <= MaxDepth; DepthIndex++)
    free(CellsInDepth[DepthIndex]);
  free(CellsInDepth);
  free(NumberOfCellsInDepth);

  for (uint64_t gate_idx : gates_) {
    if (!cells_[gate_idx].Deleted) {
      cells_[gate_idx].Depth = -1;
    }
  }

  for (uint64_t reg_idx : regs_) {
    if (!cells_[reg_idx].Deleted) {
      cells_[reg_idx].Depth = 0;
    }
  }

  for (SignalIndex = 0; SignalIndex < NumberOfSignals; SignalIndex++)
    if (!signals_[SignalIndex].Deleted) {
      if (signals_[SignalIndex].Output >= 0)
        signals_[SignalIndex].Depth =
            cells_[signals_[SignalIndex].Output].Depth;
      else {
        signals_[SignalIndex].Depth = 0;
      }
    }

  MaxDepth = 0;

  do {
    all_have_depth = 1;

    for (CellStruct& cell : cells_) {
      if (!cell.Deleted) {
        if (!cell.type->IsRegister()) {
          if (cell.Depth == -1) {
            all_have_depth = 0;
            DepthIndex = 0;
            for (i = 0; i < (int)cell.type->GetNumberOfInputs(); i++)
              if (signals_[cell.Inputs[i]].Depth == -1)
                break;
              else if (DepthIndex < signals_[cell.Inputs[i]].Depth)
                DepthIndex = signals_[cell.Inputs[i]].Depth;

            if (i == (int)cell.type->GetNumberOfInputs()) {
              cell.Depth = DepthIndex + 1;

              for (OutputIndex = 0;
                   OutputIndex < (int)cell.type->GetNumberOfOutputs();
                   OutputIndex++)
                if (cell.Outputs[OutputIndex] != -1)
                  signals_[cell.Outputs[OutputIndex]].Depth = cell.Depth;

              if (MaxDepth < cell.Depth) MaxDepth = cell.Depth;
            }
          }
        }
      }
    }
  } while (!all_have_depth);

  CellsInDepth = (int**)malloc((MaxDepth + 1) * sizeof(int*));
  NumberOfCellsInDepth = (int*)calloc(MaxDepth + 1, sizeof(int));

  for (uint64_t gate_idx : gates_) {
    if (!cells_[gate_idx].Deleted) {
      NumberOfCellsInDepth[cells_[gate_idx].Depth]++;
    }
  }

  for (DepthIndex = 0; DepthIndex <= MaxDepth; DepthIndex++) {
    CellsInDepth[DepthIndex] =
        (int*)malloc(NumberOfCellsInDepth[DepthIndex] * sizeof(int));
    NumberOfCellsInDepth[DepthIndex] =
        0;  // temporary to be used as index in the next loop
  }

  for (uint64_t gate_idx : gates_) {
    if (!cells_[gate_idx].Deleted) {
      DepthIndex = cells_[gate_idx].Depth;
      CellsInDepth[DepthIndex][NumberOfCellsInDepth[DepthIndex]] = gate_idx;
      NumberOfCellsInDepth[DepthIndex]++;
    }
  }

  for (SignalIndex = 0; SignalIndex < NumberOfSignals; SignalIndex++)
    if (!signals_[SignalIndex].Deleted)
      if ((signals_[SignalIndex].Output != -1) &&
          (signals_[SignalIndex].Depth == -1))
        break;

  if (SignalIndex < NumberOfSignals) {
    printf("the depth of signal \"%s\" could not be identified\n",
           signals_[SignalIndex].Name);
    ErrorMessage = signals_[SignalIndex].Name;
    ErrorMessage =
        "The depth of signal \"" + ErrorMessage + "\" could not be identified!";
    throw std::runtime_error(ErrorMessage);
  }

  //-----------
  for (CellStruct& cell : cells_) {
    cell.Flag = 0;
  }

  for (uint64_t reg_idx : regs_) {
    if (!cells_[reg_idx].Deleted) {
      if (cells_[reg_idx].type->GetClock()) {
        uint64_t port_idx = *cells_[reg_idx].type->GetClock();
        SignalIndex = cells_[reg_idx].Inputs[port_idx];
        SetCellFlag(SignalIndex);
      }
    }
  }

  ClockCellsInDepth = (int**)malloc((MaxDepth + 1) * sizeof(int*));
  NumberOfClockCellsInDepth = (int*)calloc(MaxDepth + 1, sizeof(int));

  for (DepthIndex = 1; DepthIndex <= MaxDepth; DepthIndex++) {
    ClockCellsInDepth[DepthIndex] =
        (int*)malloc(NumberOfCellsInDepth[DepthIndex] * sizeof(int));
    NumberOfClockCellsInDepth[DepthIndex] = 0;

    for (i = 0; i < NumberOfCellsInDepth[DepthIndex]; i++) {
      CellIndex = CellsInDepth[DepthIndex][i];
      if (cells_[CellIndex].Flag) {
        ClockCellsInDepth[DepthIndex][NumberOfClockCellsInDepth[DepthIndex]] =
            CellIndex;
        NumberOfClockCellsInDepth[DepthIndex]++;
      }
    }
  }
}

void CircuitStruct::SetCellFlag(int SignalIndex) {
  int CellIndex;
  int InputIndex;

  if (SignalIndex != -1) {
    CellIndex = signals_[SignalIndex].Output;
    if (CellIndex != -1) {
      if ((!cells_[CellIndex].Deleted) &&
          (!cells_[CellIndex].type->IsRegister()) &&
          (!cells_[CellIndex].Flag)) {
        cells_[CellIndex].Flag = 1;

        for (InputIndex = 0;
             InputIndex < (int)cells_[CellIndex].type->GetNumberOfInputs();
             InputIndex++) {
          SignalIndex = cells_[CellIndex].Inputs[InputIndex];
          SetCellFlag(SignalIndex);
        }
      }
    }
  }
}

int CircuitStruct::SearchSignalName(char* SignalName, char Trim,
                                    const Settings& settings) {
  int SignalIndex = -1;
  int Index;
  int size;
  char flag = 0;
  uint64_t no_of_Threads = 0;

  if (Trim)
    size = strlen(SignalName);
  else
    size = Max_Name_Len;

  no_of_Threads = ceil(NumberOfSignals / 10000);
  if (no_of_Threads > settings.GetNumberOfThreads())
    no_of_Threads = settings.GetNumberOfThreads();

  omp_set_num_threads(no_of_Threads);

#pragma omp parallel for shared(flag, SignalIndex)
  for (Index = 0; Index < NumberOfSignals; Index++) {
    if (flag) continue;

    if (!strncmp(SignalName, signals_[Index].Name, size)) {
      if (Trim) {
        if ((signals_[Index].Name[size] == 0) ||
            (signals_[Index].Name[size] == '[')) {
          SignalIndex = Index;
          flag = 1;
        }
      } else {
        SignalIndex = Index;
        flag = 1;
      }
    }
  }

  if (SignalIndex == -1) {
    static char* newSignalName = NULL;
    if (newSignalName == NULL)
      newSignalName = (char*)malloc(Max_Name_Len * sizeof(char));
    safe_strcpy(newSignalName, SignalName, Max_Name_Len - 4);
    strcat(newSignalName, "[0]");

#pragma omp parallel for shared(flag, SignalIndex)
    for (Index = 0; Index < NumberOfSignals; Index++) {
      if (flag) continue;

      if (!strncmp(newSignalName, signals_[Index].Name, size)) {
        if (Trim) {
          if ((signals_[Index].Name[size] == 0) ||
              (signals_[Index].Name[size] == '[')) {
            SignalIndex = Index;
            flag = 1;
          }
        } else {
          SignalIndex = Index;
          flag = 1;
        }
      }
    }
  }

  return (SignalIndex);
}

void CircuitStruct::DesignFile_Find_IO_Port(
    int NumberOfCells, char* Str1, char SubCircuitRead,
    const Cell* CellTypeIndex, int CaseIndex, int NumberOfSignalsOffset,
    char* SubCircuitInstanceName, CircuitStruct* SubCircuit, int*& InputPorts,
    int& NumberOfInputPorts, int*& OutputPorts, int& NumberOfOutputPorts) {
  int SignalIndex;
  int InputIndex;
  int OutputIndex;
  int TempIndex;
  int i;
  int* Buffer_int;
  std::string ErrorMessage;
  static char* Str2 = NULL;
  if (Str2 == NULL)
    Str2 = (char*)malloc(Max_Name_Len * sizeof(char));

  NumberOfInputPorts = 0;
  NumberOfOutputPorts = 0;
  free(InputPorts);
  free(OutputPorts);
  InputPorts = NULL;
  OutputPorts = NULL;

  if (!SubCircuitRead) {
    if (strlen(Str1)) {
      for (InputIndex = 0; InputIndex < (int)CellTypeIndex->GetNumberOfInputs();
           InputIndex++) {
        safe_strcpy(Str2, CellTypeIndex->GetInput(InputIndex).c_str(),
                Max_Name_Len - 1);
        i = TrimSignalName(Str2);

        if ((!strcmp(Str1 + 1, CellTypeIndex->GetInput(InputIndex).c_str())) ||
            (!strcmp(Str1 + 1, Str2))) {
          Buffer_int = (int*)malloc((NumberOfInputPorts + 1) * sizeof(int));
          memcpy(Buffer_int, InputPorts, NumberOfInputPorts * sizeof(int));
          free(InputPorts);
          InputPorts = Buffer_int;

          InputPorts[NumberOfInputPorts] = InputIndex;
          NumberOfInputPorts++;

          if (i < 0)  // means the signal name was found not its trimmed
            break;
        }
      }

      if (!NumberOfInputPorts)  // the IO port NOT found in the Inputs
      {
        for (OutputIndex = 0;
             OutputIndex < (int)CellTypeIndex->GetNumberOfOutputs();
             OutputIndex++) {
          safe_strcpy(Str2, CellTypeIndex->GetOutput(OutputIndex).c_str(),
                  Max_Name_Len - 1);
          i = TrimSignalName(Str2);

          if ((!strcmp(Str1 + 1,
                       CellTypeIndex->GetOutput(OutputIndex).c_str())) ||
              (!strcmp(Str1 + 1, Str2))) {
            Buffer_int = (int*)malloc((NumberOfOutputPorts + 1) * sizeof(int));
            memcpy(Buffer_int, OutputPorts, NumberOfOutputPorts * sizeof(int));
            free(OutputPorts);
            OutputPorts = Buffer_int;

            OutputPorts[NumberOfOutputPorts] = OutputIndex;
            NumberOfOutputPorts++;

            if (i < 0)  // means the signal name was found not its trimmed
              break;
          }
        }

        if (!NumberOfOutputPorts)  // the IO port NOT found in the Outputs
        {
          ErrorMessage = Str1 + 1;
          ErrorMessage = "IO port " + ErrorMessage +
                         " not found in cell type \"" +
                         CellTypeIndex->GetIdentifier(CaseIndex) + "\"!";
          throw std::runtime_error(ErrorMessage);
        }
      }
    } else {
      for (InputIndex = 0;
           InputIndex < (int)cells_[NumberOfCells].type->GetNumberOfInputs();
           InputIndex++)
        if (cells_[NumberOfCells].Inputs[InputIndex] == -1) {
          ErrorMessage = "Input port \"" + CellTypeIndex->GetInput(InputIndex) +
                         "\" of cell \"" +
                         (std::string)cells_[NumberOfCells].Name +
                         "\" cannot be left unconnected!";
          throw std::runtime_error(ErrorMessage);
        }

      for (OutputIndex = 0;
           OutputIndex < (int)cells_[NumberOfCells].type->GetNumberOfOutputs();
           OutputIndex++)
        if (cells_[NumberOfCells].Outputs[OutputIndex] == -1) {
          Buffer_int = (int*)malloc((NumberOfOutputPorts + 1) * sizeof(int));
          memcpy(Buffer_int, OutputPorts, NumberOfOutputPorts * sizeof(int));
          free(OutputPorts);
          OutputPorts = Buffer_int;

          OutputPorts[NumberOfOutputPorts] = OutputIndex;
          NumberOfOutputPorts++;
        }
    }
  } else {
    if (strlen(Str1)) {
      TempIndex = strlen(SubCircuitInstanceName);
      strncat(SubCircuitInstanceName, ".", Max_Name_Len - 1);
      if (Str1[1] == '\\')
        strncat(SubCircuitInstanceName, Str1 + 2, Max_Name_Len - 1);
      else
        strncat(SubCircuitInstanceName, Str1 + 1, Max_Name_Len - 1);

      safe_strcpy(Str1, "\\", Max_Name_Len - 1);
      strncat(Str1, SubCircuitInstanceName, Max_Name_Len - 1);
      SubCircuitInstanceName[TempIndex] = '\0';

      for (InputIndex = 0; InputIndex < SubCircuit->NumberOfInputs;
           InputIndex++) {
        SignalIndex = SubCircuit->Inputs[InputIndex];
        if (SignalIndex > NumberOfConstants)
          SignalIndex -= NumberOfSignalsOffset;

        safe_strcpy(Str2, signals_[SignalIndex].Name, Max_Name_Len - 1);
        i = TrimSignalName(Str2);

        if ((!strcmp(Str1, signals_[SignalIndex].Name)) ||
            (!strcmp(Str1, Str2))) {
          Buffer_int = (int*)malloc((NumberOfInputPorts + 1) * sizeof(int));
          memcpy(Buffer_int, InputPorts, NumberOfInputPorts * sizeof(int));
          free(InputPorts);
          InputPorts = Buffer_int;

          InputPorts[NumberOfInputPorts] = InputIndex;
          NumberOfInputPorts++;

          if (i < 0)  // means the signal name was found not its trimmed
            break;
        }
      }

      if (!NumberOfInputPorts)  // the IO port NOT found in the
                                // SubCircuit.Inputs
      {
        for (OutputIndex = 0; OutputIndex < SubCircuit->NumberOfOutputs;
             OutputIndex++) {
          SignalIndex = SubCircuit->Outputs[OutputIndex];
          if (SignalIndex > NumberOfConstants)
            SignalIndex -= NumberOfSignalsOffset;

          safe_strcpy(Str2, signals_[SignalIndex].Name, Max_Name_Len - 1);
          i = TrimSignalName(Str2);

          if ((!strcmp(Str1, signals_[SignalIndex].Name)) ||
              (!strcmp(Str1, Str2))) {
            Buffer_int = (int*)malloc((NumberOfOutputPorts + 1) * sizeof(int));
            memcpy(Buffer_int, OutputPorts, NumberOfOutputPorts * sizeof(int));
            free(OutputPorts);
            OutputPorts = Buffer_int;

            OutputPorts[NumberOfOutputPorts] = OutputIndex;
            NumberOfOutputPorts++;

            if (i < 0)  // means the signal name was found not its trimmed
              break;
          }
        }

        if (!NumberOfOutputPorts)  // the IO port NOT found in the
                                   // subCircuit.Outputs
        {
          ErrorMessage = Str1;
          ErrorMessage = "IO port " + ErrorMessage + " not found in module \"" +
                         (std::string)SubCircuitInstanceName + "\"!";
          throw std::runtime_error(ErrorMessage);
        }
      }
    } else {
      for (InputIndex = 0; InputIndex < SubCircuit->NumberOfInputs;
           InputIndex++) {
        SignalIndex = SubCircuit->Inputs[InputIndex];
        if (SignalIndex > NumberOfConstants)
          SignalIndex -= NumberOfSignalsOffset;

        if (!signals_[SignalIndex].Deleted) {
          ErrorMessage =
              "Input port \"" + (std::string)signals_[SignalIndex].Name +
              "\" of module \"" + (std::string)SubCircuitInstanceName +
              "\" cannot be left unconnected!";
          throw std::runtime_error(ErrorMessage);
        }
      }

      for (OutputIndex = 0; OutputIndex < SubCircuit->NumberOfOutputs;
           OutputIndex++) {
        SignalIndex = SubCircuit->Outputs[OutputIndex];
        if (SignalIndex > NumberOfConstants)
          SignalIndex -= NumberOfSignalsOffset;

        if (!signals_[SignalIndex].Deleted) {
          Buffer_int = (int*)malloc((NumberOfOutputPorts + 1) * sizeof(int));
          memcpy(Buffer_int, OutputPorts, NumberOfOutputPorts * sizeof(int));
          free(OutputPorts);
          OutputPorts = Buffer_int;

          OutputPorts[NumberOfOutputPorts] = OutputIndex;
          NumberOfOutputPorts++;
        }
      }
    }
  }
}

void CircuitStruct::DesignFile_Find_Signal_Name(
    int* NumberOfCells, char* Str1, char SubCircuitRead,
    const Cell* CellTypeIndex, int CaseIndex, const Settings& settings,
    const Library& library, int Task, int NumberOfSignalsOffset,
    int NumberOfCellsOffset, char* SubCircuitInstanceName,
    CircuitStruct* SubCircuit, int*& InputPorts, int& NumberOfInputPorts,
    int*& OutputPorts, int& NumberOfOutputPorts, int& CurrentIO) {
  int SignalIndex;
  int SignalIndexWithOffset;
  int SignalIndex2;
  int SignalIndex2WithOffset;
  int InputIndex;
  int OutputIndex;
  int CellIndex;
  int InputIndex2;
  int OutputIndex2;
  int TempIndex;
  int* Buffer_int;
  int Index1, Index2, IndexUpwards;
  int j;
  int* IOSignals = NULL;
  int NumberOfIOSignals = 0;
  char* strptr;
  char* strptr2;
  char doneone;
  std::string ErrorMessage;

  static char* Str2 = NULL;
  static char* Str3 = NULL;

  if (Str2 == NULL)
    Str2 = (char*)malloc(Max_Name_Len * sizeof(char));

  if (Str3 == NULL)
    Str3 = (char*)malloc(Max_Name_Len * sizeof(char));

  if (strlen(Str1)) {
    strptr = Str1;
    if (strptr[0] == '{') strptr++;

    if (strptr[strlen(strptr) - 1] == '}') strptr[strlen(strptr) - 1] = 0;

    strptr[strlen(strptr) + 1] = 0;

    while (strlen(strptr)) {
      strptr2 = strchr(strptr, ',');
      if (strptr2) *strptr2 = 0;

      safe_strcpy(Str2, strptr, Max_Name_Len - 1);
      doneone = 0;

      SignalIndex = SearchSignalName(strptr, 1, settings);

      if (SignalIndex != -1) {
        for (SignalIndex2 = SignalIndex - 1; SignalIndex2 >= 0;
             SignalIndex2--) {
          safe_strcpy(Str2, signals_[SignalIndex2].Name, Max_Name_Len - 1);
          TrimSignalName(Str2);

          if (strcmp(strptr, Str2)) break;
        }

        for (SignalIndex = SignalIndex2 + 1; SignalIndex < NumberOfSignals;
             SignalIndex++) {
          safe_strcpy(Str2, signals_[SignalIndex].Name, Max_Name_Len - 1);
          TrimSignalName(Str2);

          if (!strcmp(strptr, Str2)) {
            Buffer_int = (int*)malloc((NumberOfIOSignals + 1) * sizeof(int));
            memcpy(Buffer_int, IOSignals, NumberOfIOSignals * sizeof(int));
            free(IOSignals);
            IOSignals = Buffer_int;

            IOSignals[NumberOfIOSignals] = SignalIndex;
            NumberOfIOSignals++;
            doneone = 1;
          } else
            break;
        }
      }

      if (!doneone) {
        safe_strcpy(Str2, strptr, Max_Name_Len - 1);
        Index1 = TrimSignalName(Str2, &Index2);

        if (Index1 <
            0)  // the given signal name does not have any index (without [])
        {
          SignalIndex = SearchSignalName(strptr, 1, settings);

          if (SignalIndex != -1) {
            for (SignalIndex2 = SignalIndex - 1; SignalIndex2 >= 0;
                 SignalIndex2--) {
              safe_strcpy(Str2, signals_[SignalIndex2].Name, Max_Name_Len - 1);
              TrimSignalName(Str2);

              if (strcmp(strptr, Str2)) break;
            }

            for (SignalIndex = SignalIndex2 + 1; SignalIndex < NumberOfSignals;
                 SignalIndex++) {
              safe_strcpy(Str2, signals_[SignalIndex].Name, Max_Name_Len - 1);
              TrimSignalName(Str2);

              if (!strcmp(strptr, Str2)) {
                Buffer_int =
                    (int*)malloc((NumberOfIOSignals + 1) * sizeof(int));
                memcpy(Buffer_int, IOSignals, NumberOfIOSignals * sizeof(int));
                free(IOSignals);
                IOSignals = Buffer_int;

                IOSignals[NumberOfIOSignals] = SignalIndex;
                NumberOfIOSignals++;
                doneone = 1;
              } else
                break;
            }
          }
        } else if ((Index1 >= 0) &&
                   (Index2 <
                    0))  // the given signal name has one index (with [ ])
        {
          SignalIndex = SearchSignalName(strptr, 0, settings);

          if (SignalIndex != -1) {
            Buffer_int = (int*)malloc((NumberOfIOSignals + 1) * sizeof(int));
            memcpy(Buffer_int, IOSignals, NumberOfIOSignals * sizeof(int));
            free(IOSignals);
            IOSignals = Buffer_int;

            IOSignals[NumberOfIOSignals] = SignalIndex;
            NumberOfIOSignals++;
            doneone = 1;
          }
        } else if ((Index1 >= 0) &&
                   (Index2 >=
                    0))  // the given signal name has two indices (with [ : ])
        {
          IndexUpwards = (Index1 < Index2) ? 1 : -1;

          for (j = Index1; ((IndexUpwards == 1) && (j <= Index2)) ||
                           ((IndexUpwards == -1) && (j >= Index2));
               j += IndexUpwards) {
            sprintf(Str3, "%s[%d]", Str2, j);

            SignalIndex = SearchSignalName(Str3, 0, settings);

            if (SignalIndex != -1) {
              Buffer_int = (int*)malloc((NumberOfIOSignals + 1) * sizeof(int));
              memcpy(Buffer_int, IOSignals, NumberOfIOSignals * sizeof(int));
              free(IOSignals);
              IOSignals = Buffer_int;

              IOSignals[NumberOfIOSignals] = SignalIndex;
              NumberOfIOSignals++;
              doneone = 1;
            } else {
              ErrorMessage = Str3;
              ErrorMessage = "Signal \"" + ErrorMessage + "\" not found!";
              throw std::runtime_error(ErrorMessage);
            }
          }
        }
      }

      if (!doneone) {
        ErrorMessage = "Signal \"" + (std::string)strptr + "\" not found!";
        throw std::runtime_error(ErrorMessage);
      }

      strptr += strlen(strptr) + 1;
    }
  } else {
    if (NumberOfInputPorts > 0) {
      if (!SubCircuitRead) {
        ErrorMessage =
            "Input port \"" + CellTypeIndex->GetInput(InputPorts[0]) +
            "\" of cell type \"" + CellTypeIndex->GetIdentifier(CaseIndex) +
            "\" cannot be left unconnected!";
        throw std::runtime_error(ErrorMessage);
      } else {
        SignalIndex = SubCircuit->Inputs[InputPorts[0]];
        if (SignalIndex >= NumberOfConstants)
          SignalIndex -= NumberOfSignalsOffset;

        ErrorMessage = "Input port \"" +
                       (std::string)signals_[SignalIndex].Name +
                       "\" of module \"" + (std::string)SubCircuitInstanceName +
                       "\" cannot be left unconnected!";
        throw std::runtime_error(ErrorMessage);
      }
    }

    for (TempIndex = 0; TempIndex < NumberOfOutputPorts; TempIndex++) {
      Buffer_int = (int*)malloc((NumberOfIOSignals + 1) * sizeof(int));
      memcpy(Buffer_int, IOSignals, NumberOfIOSignals * sizeof(int));
      free(IOSignals);
      IOSignals = Buffer_int;

      IOSignals[NumberOfIOSignals] = -1;
      NumberOfIOSignals++;
    }
  }

  //**********************************************//

  if (Task == Task_find_assign_signal_name1) {
    free(InputPorts);
    NumberOfInputPorts = NumberOfIOSignals;
    InputPorts = (int*)malloc(NumberOfInputPorts * sizeof(int));

    for (TempIndex = 0; TempIndex < NumberOfIOSignals; TempIndex++) {
      std::optional<const Cell*> tmp = library.GetBuffer();

      if (tmp) {
        CellTypeIndex = *tmp;
      }

      cells_.resize(*NumberOfCells + 1);
      cells_[*NumberOfCells].type = CellTypeIndex;
      cells_[*NumberOfCells].Inputs =
          (int*)malloc(CellTypeIndex->GetNumberOfInputs() * sizeof(int));
      cells_[*NumberOfCells].Outputs =
          (int*)malloc(CellTypeIndex->GetNumberOfOutputs() * sizeof(int));
      cells_[*NumberOfCells].Deleted = 0;

      for (InputIndex = 0;
           InputIndex < (int)cells_[*NumberOfCells].type->GetNumberOfInputs();
           InputIndex++)
        cells_[*NumberOfCells].Inputs[InputIndex] = -1;

      for (OutputIndex = 0;
           OutputIndex < (int)cells_[*NumberOfCells].type->GetNumberOfOutputs();
           OutputIndex++)
        cells_[*NumberOfCells].Outputs[OutputIndex] = -1;

      // if (Library->CellTypes[CellTypeIndex]->GateOrReg == CellType_Gate)
      cells_[*NumberOfCells].Depth = -1;

      // if (!strcmp(Str1, "assign"))
      sprintf(Str2, "assign_%d", *NumberOfCells);
      cells_[*NumberOfCells].Name = (char*)malloc(Max_Name_Len);
      safe_strcpy(cells_[*NumberOfCells].Name, Str2,
              Max_Name_Len - 1);  // Str2 = "assign_%d"

      SignalIndex = IOSignals[TempIndex];
      OutputIndex = 0;
      cells_[*NumberOfCells].Outputs[OutputIndex] = SignalIndex;
      if (SignalIndex >= NumberOfConstants)
        cells_[*NumberOfCells].Outputs[OutputIndex] += NumberOfSignalsOffset;

      if (signals_[SignalIndex].Output != -1) {
        ErrorMessage = signals_[SignalIndex].Name;
        ErrorMessage = "signal \"" + ErrorMessage +
                       "\" cannot be the output of more than one cell!";
        throw std::runtime_error(ErrorMessage);
      }
      signals_[SignalIndex].Output = *NumberOfCells + NumberOfCellsOffset;
      InputPorts[TempIndex] = *NumberOfCells;
      (*NumberOfCells)++;
    }
  } else if (Task == Task_find_assign_signal_name2) {
    if (NumberOfIOSignals != NumberOfInputPorts) {
      ErrorMessage = Str1;
      ErrorMessage = "The size of the signal \"" + ErrorMessage +
                     "\" does not match to the connected signal!";
      throw std::runtime_error(ErrorMessage);
    }

    for (TempIndex = 0; TempIndex < NumberOfIOSignals; TempIndex++) {
      SignalIndex = IOSignals[TempIndex];
      CellIndex = InputPorts[TempIndex];
      InputIndex = 0;
      cells_[CellIndex].Inputs[InputIndex] = SignalIndex;
      if (SignalIndex >= NumberOfConstants)
        cells_[CellIndex].Inputs[InputIndex] += NumberOfSignalsOffset;

      Buffer_int = (int*)malloc((signals_[SignalIndex].NumberOfInputs + 1) *
                                sizeof(int));
      memcpy(Buffer_int, signals_[SignalIndex].Inputs,
             signals_[SignalIndex].NumberOfInputs * sizeof(int));
      free(signals_[SignalIndex].Inputs);
      signals_[SignalIndex].Inputs = Buffer_int;

      signals_[SignalIndex].Inputs[signals_[SignalIndex].NumberOfInputs] =
          CellIndex + NumberOfCellsOffset;
      signals_[SignalIndex].NumberOfInputs++;
    }
  } else {
    if (NumberOfIOSignals != (NumberOfInputPorts + NumberOfOutputPorts)) {
      ErrorMessage = Str1;
      ErrorMessage = "The size of the signal \"" + ErrorMessage +
                     "\" does not match to the connected port!";
      throw std::runtime_error(ErrorMessage);
    }

    if (!SubCircuitRead) {
      for (TempIndex = 0;
           TempIndex < (NumberOfInputPorts + NumberOfOutputPorts);
           TempIndex++) {
        SignalIndex = IOSignals[TempIndex];
        if (TempIndex < NumberOfInputPorts) {
          InputIndex = InputPorts[TempIndex];
          cells_[*NumberOfCells].Inputs[InputIndex] = SignalIndex;
          if (SignalIndex >= NumberOfConstants)
            cells_[*NumberOfCells].Inputs[InputIndex] += NumberOfSignalsOffset;

          Buffer_int = (int*)malloc((signals_[SignalIndex].NumberOfInputs + 1) *
                                    sizeof(int));
          memcpy(Buffer_int, signals_[SignalIndex].Inputs,
                 signals_[SignalIndex].NumberOfInputs * sizeof(int));
          free(signals_[SignalIndex].Inputs);
          signals_[SignalIndex].Inputs = Buffer_int;

          signals_[SignalIndex].Inputs[signals_[SignalIndex].NumberOfInputs] =
              *NumberOfCells + NumberOfCellsOffset;
          signals_[SignalIndex].NumberOfInputs++;
        } else {
          OutputIndex = OutputPorts[TempIndex - NumberOfInputPorts];
          cells_[*NumberOfCells].Outputs[OutputIndex] = SignalIndex;
          if (SignalIndex >= NumberOfConstants)
            cells_[*NumberOfCells].Outputs[OutputIndex] +=
                NumberOfSignalsOffset;

          if (SignalIndex != -1) {
            if (signals_[SignalIndex].Output != -1) {
              ErrorMessage = signals_[SignalIndex].Name;
              ErrorMessage = "signal \"" + ErrorMessage +
                             "\" cannot be the output of more than one cell!";
              throw std::runtime_error(ErrorMessage);
            }

            signals_[SignalIndex].Output = *NumberOfCells + NumberOfCellsOffset;
            if (CellTypeIndex->IsRegister()) signals_[SignalIndex].Depth = 0;
          }
        }

        CurrentIO++;
      }
    } else {
      for (TempIndex = 0;
           TempIndex < (NumberOfInputPorts + NumberOfOutputPorts);
           TempIndex++) {
        SignalIndex = IOSignals[TempIndex];
        SignalIndexWithOffset = SignalIndex;
        if (SignalIndexWithOffset >= NumberOfConstants)
          SignalIndexWithOffset += NumberOfSignalsOffset;

        if (TempIndex < NumberOfInputPorts)
          SignalIndex2WithOffset = SubCircuit->Inputs[InputPorts[TempIndex]];
        else
          SignalIndex2WithOffset =
              SubCircuit->Outputs[OutputPorts[TempIndex - NumberOfInputPorts]];

        SignalIndex2 = SignalIndex2WithOffset;
        if (SignalIndex2 >= NumberOfConstants)
          SignalIndex2 -= NumberOfSignalsOffset;

        signals_[SignalIndex2].Type = signal_t::wire;

        if (SignalIndex != -1) {
          Buffer_int = (int*)malloc((signals_[SignalIndex].NumberOfInputs +
                                     signals_[SignalIndex2].NumberOfInputs) *
                                    sizeof(int));
          memcpy(Buffer_int, signals_[SignalIndex].Inputs,
                 signals_[SignalIndex].NumberOfInputs * sizeof(int));
          free(signals_[SignalIndex].Inputs);
          signals_[SignalIndex].Inputs = Buffer_int;

          for (InputIndex = 0;
               InputIndex < signals_[SignalIndex2].NumberOfInputs;
               InputIndex++) {
            CellIndex = signals_[SignalIndex2].Inputs[InputIndex];
            signals_[SignalIndex].Inputs[signals_[SignalIndex].NumberOfInputs] =
                CellIndex;
            signals_[SignalIndex].NumberOfInputs++;

            CellIndex -= NumberOfCellsOffset;
            for (InputIndex2 = 0;
                 InputIndex2 < (int)cells_[CellIndex].type->GetNumberOfInputs();
                 InputIndex2++)
              if (cells_[CellIndex].Inputs[InputIndex2] ==
                  SignalIndex2WithOffset)
                cells_[CellIndex].Inputs[InputIndex2] = SignalIndexWithOffset;
          }

          if (TempIndex >= NumberOfInputPorts) {
            if (signals_[SignalIndex].Output != -1) {
              ErrorMessage = signals_[SignalIndex].Name;
              ErrorMessage = "signal \"" + ErrorMessage +
                             "\" cannot be the output of more than one cell!";
              throw std::runtime_error(ErrorMessage);
            }

            CellIndex = signals_[SignalIndex2].Output;
            signals_[SignalIndex].Output = CellIndex;
            if (CellIndex != -1) {
              CellIndex -= NumberOfCellsOffset;

              for (OutputIndex2 = 0;
                   OutputIndex2 <
                   (int)cells_[CellIndex].type->GetNumberOfOutputs();
                   OutputIndex2++)
                if (cells_[CellIndex].Outputs[OutputIndex2] ==
                    SignalIndex2WithOffset)
                  cells_[CellIndex].Outputs[OutputIndex2] =
                      SignalIndexWithOffset;
            }
          }

          free(signals_[SignalIndex2].Inputs);
          signals_[SignalIndex2].Inputs = NULL;
          signals_[SignalIndex2].NumberOfInputs = 0;
          signals_[SignalIndex2].Deleted = 1;
        }

        CurrentIO++;
      }
    }
  }

  free(IOSignals);
}

int CircuitStruct::ReadDesignFile(
    const std::string& design_file_name, const std::string& top_module_name,
    const Settings& settings, const Library& library, int NumberOfSignalsOffset,
    int NumberOfCellsOffset, int NumberOfRegValuesOffset,
    FileBufferStruct* FB) {
  FILE* DesignFile;
  char finished;
  char ReadSignalsFinished;
  const Cell* CellTypeIndex = NULL;
  int CaseIndex = 0;
  char* Str1 = (char*)malloc(Max_Name_Len * sizeof(char));
  char* Str2 = (char*)malloc(Max_Name_Len * sizeof(char));
  char ch;
  int i, j;
  int MyNumberofIO = 0;
  int CurrentIO = 0;
  int InputIndex = 0;
  int OutputIndex = 0;
  int SignalIndex;
  int CellIndex;
  int Index1, Index2, IndexUpwards;
  int* TempInputs;
  int* TempOutputs;
  std::string ErrorMessage;
  CircuitStruct SubCircuit;

  int NumberOfCellsSubCircuit;
  char SubCircuitRead = 0;
  char* SubCircuitInstanceName = (char*)malloc(Max_Name_Len * sizeof(char));
  int* InputPorts = NULL;
  int NumberOfInputPorts = 0;
  int* OutputPorts = NULL;
  int NumberOfOutputPorts = 0;
  FileBufferStruct FileBuffer;
  struct stat file_status;

  BOOST_LOG_TRIVIAL(info) << "Reading \"" << top_module_name << "\"...";

  NumberOfSignals = 0;
  NumberOfOutputs = 0;
  NumberOfInputs = 0;

  char* Phrase = (char*)malloc(Max_Name_Len * sizeof(char));
  char Task;
  char IO_port_found = 0;

  int NumberOfCells = 0;
  NumberOfRegValues = 0;

  // --------- adding 0 and 1 Signals --------------

  NumberOfSignals = 6;
  NumberOfConstants = 6;
  signals_.resize(NumberOfSignals);
  // Signals = (SignalStruct **)malloc(NumberOfSignals * sizeof(SignalStruct
  // *));

  signals_[0].Name = (char*)malloc(Max_Name_Len);
  safe_strcpy(signals_[0].Name, "1'b0", Max_Name_Len - 1);
  signals_[0].Type = signal_t::wire;
  signals_[0].NumberOfInputs = 0;
  signals_[0].Inputs = NULL;
  signals_[0].Output = -1;
  signals_[0].Depth = 0;
  signals_[0].is_probe_allowed = false;
  signals_[0].is_extension_allowed = false;
  signals_[0].is_analysis_allowed = false;
  signals_[0].Deleted = 0;

  signals_[1].Name = (char*)malloc(Max_Name_Len);
  safe_strcpy(signals_[1].Name, "1'b1", Max_Name_Len - 1);
  signals_[1].Type = signal_t::wire;
  signals_[1].NumberOfInputs = 0;
  signals_[1].Inputs = NULL;
  signals_[1].Output = -1;
  signals_[1].Depth = 0;
  signals_[1].is_probe_allowed = false;
  signals_[1].is_extension_allowed = false;
  signals_[1].is_analysis_allowed = false;
  signals_[1].Deleted = 0;

  signals_[2].Name = (char*)malloc(Max_Name_Len);
  safe_strcpy(signals_[2].Name, "1'h0", Max_Name_Len - 1);
  signals_[2].Type = signal_t::wire;
  signals_[2].NumberOfInputs = 0;
  signals_[2].Inputs = NULL;
  signals_[2].Output = -1;
  signals_[2].Depth = 0;
  signals_[2].is_probe_allowed = false;
  signals_[2].is_extension_allowed = false;
  signals_[2].is_analysis_allowed = false;
  signals_[2].Deleted = 0;

  signals_[3].Name = (char*)malloc(Max_Name_Len);
  safe_strcpy(signals_[3].Name, "1'h1", Max_Name_Len - 1);
  signals_[3].Type = signal_t::wire;
  signals_[3].NumberOfInputs = 0;
  signals_[3].Inputs = NULL;
  signals_[3].Output = -1;
  signals_[3].Depth = 0;
  signals_[3].is_probe_allowed = false;
  signals_[3].is_extension_allowed = false;
  signals_[3].is_analysis_allowed = false;
  signals_[3].Deleted = 0;

  signals_[4].Name = (char*)malloc(Max_Name_Len);
  safe_strcpy(signals_[4].Name, "1'bx", Max_Name_Len - 1);
  signals_[4].Type = signal_t::wire;
  signals_[4].NumberOfInputs = 0;
  signals_[4].Inputs = NULL;
  signals_[4].Output = -1;
  signals_[4].Depth = 0;
  signals_[4].is_probe_allowed = false;
  signals_[4].is_extension_allowed = false;
  signals_[4].is_analysis_allowed = false;
  signals_[4].Deleted = 0;

  signals_[5].Name = (char*)malloc(Max_Name_Len);
  safe_strcpy(signals_[5].Name, "1'hx", Max_Name_Len - 1);
  signals_[5].Type = signal_t::wire;
  signals_[5].NumberOfInputs = 0;
  signals_[5].Inputs = NULL;
  signals_[5].Output = -1;
  signals_[5].Depth = 0;
  signals_[5].is_probe_allowed = false;
  signals_[5].is_extension_allowed = false;
  signals_[5].is_analysis_allowed = false;
  signals_[5].Deleted = 0;

  //---------------------------------------------------------------------------------------------//
  //------------------- reading the Signals from the design file
  //--------------------------------//

  if (FB == NULL) {
    DesignFile = fopen(design_file_name.c_str(), "rt");

    if (DesignFile == NULL) {
      ErrorMessage = "Design file " + design_file_name + " not found!";
      free(Str1);
      free(Str2);
      free(Phrase);
      free(SubCircuitInstanceName);
      throw std::runtime_error(ErrorMessage);
    }

    if (stat(design_file_name.c_str(), &file_status)) {
      ErrorMessage =
          "\ncannot find the size of design file " + design_file_name;
      free(Str1);
      free(Str2);
      free(Phrase);
      free(SubCircuitInstanceName);
      throw std::runtime_error(ErrorMessage);
    }

    FileBuffer.Buffer =
        (char*)malloc((file_status.st_size + 10) * sizeof(char));
    FileBuffer.Size =
        fread(FileBuffer.Buffer, sizeof(char), file_status.st_size, DesignFile);
    fclose(DesignFile);
  } else {
    FileBuffer.Size = FB->Size;
    FileBuffer.Buffer = FB->Buffer;
  }

  FileBuffer.Index = 0;
  finished = 0;
  ReadSignalsFinished = 0;

  do {
    do {
      fReadaWord(&FileBuffer, Str1, NULL);
    } while ((FileBuffer.Index <= FileBuffer.Size) && strcmp(Str1, "module"));

    if (FileBuffer.Index <= FileBuffer.Size) {
      fReadaWord(&FileBuffer, Str1, NULL);
      if (strcmp(Str1, top_module_name.c_str())) {
        do {
          fReadaWord(&FileBuffer, Str1, NULL);
        } while ((FileBuffer.Index <= FileBuffer.Size) &&
                 strcmp(Str1, "endmodule"));
      } else {
        do {
          fReadaWord(&FileBuffer, Str1, NULL);
          ch = Str1[strlen(Str1) - 1];
        } while ((ch != ';') && (FileBuffer.Index <=
                                 FileBuffer.Size));  // ignoring the entire list
                                                     // of input/output ports

        while ((!ReadSignalsFinished) &&
               (FileBuffer.Index <= FileBuffer.Size)) {
          fReadaWord(&FileBuffer, Str1, NULL);

          if ((!strcmp(Str1, "input")) || (!strcmp(Str1, "output")) ||
              (!strcmp(Str1, "wire"))) {
            safe_strcpy(Phrase, Str1, Max_Name_Len - 1);
            i = 0;
            Index1 = -1;
            Index2 = -1;

            do {
              ch = FileBuffer.Buffer[FileBuffer.Index++];

              if ((ch == '[') && (!i)) {
                // do nothing
              } else if ((ch == ':') && (Str1[0] != '\\')) {
                Index1 = atoi(Str1);
                i = 0;
              } else if ((ch == ']') && (Str1[0] != '\\')) {
                Index2 = atoi(Str1);
                i = 0;
              } else if ((ch == ',') || (ch == ';')) {
                IndexUpwards = (Index1 < Index2) ? 1 : -1;

                for (j = Index1; ((IndexUpwards == 1) && (j <= Index2)) ||
                                 ((IndexUpwards == -1) && (j >= Index2));
                     j += IndexUpwards) {
                  if (Index1 != -1)
                    sprintf(Str2, "%s[%d]", Str1, j);
                  else
                    sprintf(Str2, "%s", Str1);

                  SignalIndex = SearchSignalName(Str2, 0, settings);

                  if (SignalIndex != -1) {
                    if (!strcmp(Phrase, "input")) {
                      if (signals_[SignalIndex].Type != signal_t::wire) {
                        ErrorMessage = "Signal \"" + (std::string)Str2 +
                                       "\" is defined multiple times!";
                        throw std::runtime_error(ErrorMessage);
                      }
                    } else if (!strcmp(Phrase, "output")) {
                      if (signals_[SignalIndex].Type != signal_t::wire) {
                        ErrorMessage = "Signal \"" + (std::string)Str2 +
                                       "\" is defined multiple times!";
                        throw std::runtime_error(ErrorMessage);
                      }
                    } else  // if (!strcmp(Phrase, "wire"))
                    {
                      if (signals_[SignalIndex].Type == signal_t::wire) {
                        ErrorMessage = "Signal \"" + (std::string)Str2 +
                                       "\" is defined multiple times!";
                        throw std::runtime_error(ErrorMessage);
                      }
                    }
                  } else {
                    signals_.resize(NumberOfSignals + 1);

                    signals_[NumberOfSignals].Name =
                        (char*)malloc(Max_Name_Len);
                    safe_strcpy(signals_[NumberOfSignals].Name, Str2,
                            Max_Name_Len - 1);
                    signals_[NumberOfSignals].NumberOfInputs = 0;
                    signals_[NumberOfSignals].Inputs = NULL;
                    signals_[NumberOfSignals].Output = -1;
                    signals_[NumberOfSignals].is_probe_allowed = false;
                    signals_[NumberOfSignals].is_extension_allowed = false;
                    signals_[NumberOfSignals].is_analysis_allowed = false;
                    signals_[NumberOfSignals].Deleted = 0;

                    SignalIndex = NumberOfSignals;
                    NumberOfSignals++;
                  }

                  if (!strcmp(Phrase, "input")) {
                    signals_[SignalIndex].Type = signal_t::input;
                    signals_[SignalIndex].Depth = 0;

                    TempInputs =
                        (int*)malloc((NumberOfInputs + 1) * sizeof(int));
                    memcpy(TempInputs, Inputs, NumberOfInputs * sizeof(int));
                    free(Inputs);
                    Inputs = TempInputs;

                    Inputs[NumberOfInputs] =
                        SignalIndex + NumberOfSignalsOffset;
                    NumberOfInputs++;
                  } else if (!strcmp(Phrase, "output")) {
                    signals_[SignalIndex].Type = signal_t::output;
                    signals_[SignalIndex].Depth = -1;

                    TempOutputs =
                        (int*)malloc((NumberOfOutputs + 1) * sizeof(int));
                    memcpy(TempOutputs, Outputs, NumberOfOutputs * sizeof(int));
                    free(Outputs);
                    Outputs = TempOutputs;

                    Outputs[NumberOfOutputs] =
                        SignalIndex + NumberOfSignalsOffset;
                    NumberOfOutputs++;
                  } else if ((!strcmp(Phrase, "wire")) &&
                             (SignalIndex == NumberOfSignals - 1)) {
                    signals_[SignalIndex].Type = signal_t::wire;
                    signals_[SignalIndex].Depth = -1;
                  }
                }

                i = 0;
              } else if ((ch != ' ') && (ch != '\n') && (ch != '\t') &&
                         (ch != '\r')) {
                Str1[i++] = ch;
                Str1[i] = 0;
              }
            } while ((ch != ';') && (FileBuffer.Index <= FileBuffer.Size));
          } else
            ReadSignalsFinished = 1;
        }

        //---------------------------------------------------------------------------------------------//
        //------------------- reading the cells_ from the design file
        //----------------------------------//

        if (FileBuffer.Index <= FileBuffer.Size) {
          safe_strcpy(Str2, Str1, Max_Name_Len - 1);

          do {
            fReadaWord(&FileBuffer, Str1, NULL);
            if (Str1[0] != '[') strcat(Str2, " ");
            strcat(Str2, Str1);

            if (Str1[strlen(Str1) - 1] == ';') {
              i = 0;
              j = 0;
              Str1[0] = 0;
              Task = Task_find_module_type;

              do {
                ch = Str2[i++];

                if ((ch == ' ') || (ch == ';') || (ch == '=')) {
                  if (j) {
                    if (Task == Task_find_module_type) {
                      if (!strcmp(Str1, "assign")) {
                        std::optional<const Cell*> tmp2 = library.GetBuffer();
                        if (tmp2) {
                          CellTypeIndex = *tmp2;

                          SubCircuitRead = 0;
                          NumberOfInputPorts = 0;
                          free(InputPorts);
                          InputPorts = NULL;
                          NumberOfOutputPorts = 0;
                          free(OutputPorts);
                          OutputPorts = NULL;

                          Task = Task_find_assign_signal_name1;
                        } else {
                          free(Str1);
                          free(Str2);
                          free(Phrase);
                          free(SubCircuitInstanceName);
                          throw std::runtime_error(
                              "Buffer cell is not defined in the library for "
                              "\"assign\" statements!");
                        }
                      } else {
                        std::string identifier = Str1;
                        std::optional<const Cell*> cell =
                            library.GetCellById(identifier);

                        if (cell) {
                          CellTypeIndex = *cell;
                          cells_.resize(NumberOfCells + 1);

                          cells_[NumberOfCells].type = CellTypeIndex;
                          cells_[NumberOfCells].Inputs = (int*)malloc(
                              CellTypeIndex->GetNumberOfInputs() * sizeof(int));
                          cells_[NumberOfCells].Outputs =
                              (int*)malloc(CellTypeIndex->GetNumberOfOutputs() *
                                           sizeof(int));
                          cells_[NumberOfCells].params_.clear();
                          cells_[NumberOfCells].Deleted = 0;

                          for (InputIndex = 0;
                               InputIndex < (int)cells_[NumberOfCells]
                                                .type->GetNumberOfInputs();
                               InputIndex++)
                            cells_[NumberOfCells].Inputs[InputIndex] = -1;

                          for (OutputIndex = 0;
                               OutputIndex < (int)cells_[NumberOfCells]
                                                 .type->GetNumberOfOutputs();
                               OutputIndex++)
                            cells_[NumberOfCells].Outputs[OutputIndex] = -1;

                          std::string lut{Str2};
                          std::string::iterator it = lut.begin();
                          std::string::iterator end = lut.end();
                          VlogConstGrammar grammar;

                          if (lut[0] == ' ') {
                            parseNextWord(it, end);
                          }
                          parseNextWord(it, end);

                          if (parseNextWord(it, end) == "#") {
                            if (parseNextWord(it, end) == "(") {
                              do {
                                std::string param_str,
                                    param_name =
                                        parseNextWord(it, end).substr(1);
                                std::vector<vlog_bit_t> param_value;

                                if (parseNextWord(it, end) == "(") {
                                  param_str = parseNextWord(it, end);
                                  param_value = grammar.Parse(param_str);

                                  if (parseNextWord(it, end) != ")") {
                                    throw std::runtime_error(
                                        "Error while parsing the parameters "
                                        "of " +
                                        lut +
                                        ". Expected closing parenthesis!");
                                  }

                                  for (uint64_t idx = 0;
                                       idx < param_value.size(); idx++) {
                                    if (param_value[idx] == vlog_bit_t::one) {
                                      cells_[NumberOfCells].params_.push_back(
                                          std::make_pair(
                                              param_name + "[" +
                                                  std::to_string(idx) + "]",
                                              UINT64_MAX));
                                    } else {
                                      cells_[NumberOfCells].params_.push_back(
                                          std::make_pair(
                                              param_name + "[" +
                                                  std::to_string(idx) + "]",
                                              0));
                                    }
                                  }
                                }
                              } while (parseNextWord(it, end) == ",");
                            }
                            i = it - lut.begin();
                          }

                          std::sort(
                              cells_[NumberOfCells].params_.begin(),
                              cells_[NumberOfCells].params_.end(),
                              [](const std::pair<std::string, uint64_t>& a,
                                 const std::pair<std::string, uint64_t>& b) {
                                return a.first < b.first;
                              });

                          std::vector<std::pair<std::string, uint64_t>>
                              required_default_params;

                          for (const std::pair<std::string,
                                               std::vector<vlog_bit_t>>& param :
                               CellTypeIndex->GetParams()) {
                            for (uint64_t idx = 0; idx < param.second.size();
                                 ++idx) {
                              if (std::find_if(
                                      cells_[NumberOfCells].params_.begin(),
                                      cells_[NumberOfCells].params_.end(),
                                      [&param,
                                       idx](const std::pair<std::string,
                                                            uint64_t>& a) {
                                        std::string tmp_name =
                                            param.first + "[" +
                                            std::to_string(idx) + "]";
                                        return a.first == tmp_name;
                                      }) ==
                                  cells_[NumberOfCells].params_.end()) {
                                if (param.second[idx] == vlog_bit_t::one) {
                                  required_default_params.push_back(
                                      std::make_pair(param.first + "[" +
                                                         std::to_string(idx) +
                                                         "]",
                                                     UINT64_MAX));
                                } else {
                                  required_default_params.push_back(
                                      std::make_pair(param.first + "[" +
                                                         std::to_string(idx) +
                                                         "]",
                                                     0));
                                }
                              }
                            }
                          }

                          cells_[NumberOfCells].params_.insert(
                              cells_[NumberOfCells].params_.end(),
                              required_default_params.begin(),
                              required_default_params.end());

                          std::sort(
                              cells_[NumberOfCells].params_.begin(),
                              cells_[NumberOfCells].params_.end(),
                              [](const std::pair<std::string, uint64_t>& a,
                                 const std::pair<std::string, uint64_t>& b) {
                                return a.first < b.first;
                              });

                          if (CellTypeIndex->GetType() == cell_t::sequential) {
                            cells_[NumberOfCells].Depth = 0;
                            cells_[NumberOfCells].RegValueIndexes =
                                (int*)malloc(
                                    CellTypeIndex->GetNumberOfOutputs() *
                                    sizeof(int));
                            for (OutputIndex = 0;
                                 OutputIndex <
                                 (int)CellTypeIndex->GetNumberOfOutputs();
                                 OutputIndex++)
                              cells_[NumberOfCells]
                                  .RegValueIndexes[OutputIndex] =
                                  NumberOfRegValuesOffset + NumberOfRegValues++;
                          } else  // is a gate or a latch
                          {
                            cells_[NumberOfCells].Depth = -1;
                          }

                          Task = Task_find_module_name;
                          MyNumberofIO = CellTypeIndex->GetNumberOfInputs() +
                                         CellTypeIndex->GetNumberOfOutputs();
                          CurrentIO = 0;
                          SubCircuitRead = 0;
                        } else {
                          SubCircuit.NumberOfSignals = 0;
                          SubCircuit.Inputs = NULL;
                          SubCircuit.Outputs = NULL;
                          SubCircuit.NumberOfInputs = 0;
                          SubCircuit.NumberOfOutputs = 0;
                          SubCircuit.NumberOfConstants = 0;
                          SubCircuit.NumberOfRegValues = 0;
                          SubCircuit.MaxDepth = 0;
                          SubCircuit.CellsInDepth = NULL;
                          SubCircuit.NumberOfCellsInDepth = NULL;
                          SubCircuit.cells_.clear();

                          NumberOfCellsSubCircuit = SubCircuit.ReadDesignFile(
                              design_file_name, Str1, settings, library,
                              NumberOfSignalsOffset + NumberOfSignals -
                                  NumberOfConstants,
                              NumberOfCellsOffset + NumberOfCells,
                              NumberOfRegValuesOffset + NumberOfRegValues,
                              &FileBuffer);

                          signals_.insert(signals_.end(),
                                          SubCircuit.signals_.begin() +
                                              SubCircuit.NumberOfConstants,
                                          SubCircuit.signals_.end());
                          NumberOfSignals += SubCircuit.NumberOfSignals -
                                             SubCircuit.NumberOfConstants;

                          cells_.insert(cells_.end(), SubCircuit.cells_.begin(),
                                        SubCircuit.cells_.end());
                          NumberOfCells += NumberOfCellsSubCircuit;
                          NumberOfRegValues += SubCircuit.NumberOfRegValues;

                          MyNumberofIO = SubCircuit.NumberOfInputs +
                                         SubCircuit.NumberOfOutputs;
                          CurrentIO = 0;
                          SubCircuitRead = 1;
                          Task = Task_find_module_name;
                        }
                      }
                    } else if (Task == Task_find_module_name) {
                      if (!SubCircuitRead) {
                        cells_[NumberOfCells].Name =
                            (char*)malloc(Max_Name_Len);
                        safe_strcpy(cells_[NumberOfCells].Name, Str1,
                                Max_Name_Len - 1);
                      } else {
                        safe_strcpy(SubCircuitInstanceName, Str1,
                                Max_Name_Len - 1);

                        for (SignalIndex = SubCircuit.NumberOfConstants;
                             SignalIndex < SubCircuit.NumberOfSignals;
                             SignalIndex++) {
                          safe_strcpy(Str1, "\\", Max_Name_Len - 1);
                          strncat(Str1, SubCircuitInstanceName,
                                  Max_Name_Len - 1);
                          strncat(Str1, ".", Max_Name_Len - 1);
                          if (SubCircuit.signals_[SignalIndex].Name[0] == '\\')
                            strncat(Str1,
                                    SubCircuit.signals_[SignalIndex].Name + 1,
                                    Max_Name_Len - 1);
                          else
                            strncat(Str1, SubCircuit.signals_[SignalIndex].Name,
                                    Max_Name_Len - 1);

                          safe_strcpy(SubCircuit.signals_[SignalIndex].Name, Str1,
                                  Max_Name_Len - 1);
                        }

                        for (CellIndex = 0; CellIndex < NumberOfCellsSubCircuit;
                             CellIndex++) {
                          safe_strcpy(Str1, "\\", Max_Name_Len - 1);
                          strncat(Str1, SubCircuitInstanceName,
                                  Max_Name_Len - 1);
                          strncat(Str1, ".", Max_Name_Len - 1);
                          if (SubCircuit.cells_[CellIndex].Name[0] == '\\')
                            strncat(Str1, SubCircuit.cells_[CellIndex].Name + 1,
                                    Max_Name_Len - 1);
                          else
                            strncat(Str1, SubCircuit.cells_[CellIndex].Name,
                                    Max_Name_Len - 1);

                          safe_strcpy(SubCircuit.cells_[CellIndex].Name, Str1,
                                  Max_Name_Len - 1);
                        }
                      }

                      Task = Task_find_open_bracket;
                      IO_port_found = 0;
                    } else if (Task == Task_find_IO_port) {
                      if (Str1[0] == '.') {
                        DesignFile_Find_IO_Port(
                            NumberOfCells, Str1, SubCircuitRead, CellTypeIndex,
                            CaseIndex, NumberOfSignalsOffset,
                            SubCircuitInstanceName, &SubCircuit, InputPorts,
                            NumberOfInputPorts, OutputPorts,
                            NumberOfOutputPorts);

                        IO_port_found = 1;
                        Task = Task_find_open_bracket;
                      } else {
                        ErrorMessage = Str1;
                        ErrorMessage =
                            "Error in reading the netlist, '.' is expected "
                            "in " +
                            ErrorMessage + "!";
                        free(Str1);
                        free(Str2);
                        free(Phrase);
                        free(SubCircuitInstanceName);
                        throw std::runtime_error(ErrorMessage);
                      }
                    } else if ((Task == Task_find_signal_name) ||
                               (Task == Task_find_assign_signal_name1) ||
                               (Task == Task_find_assign_signal_name2)) {
                      DesignFile_Find_Signal_Name(
                          &NumberOfCells, Str1, SubCircuitRead, CellTypeIndex,
                          CaseIndex, settings, library, Task,
                          NumberOfSignalsOffset, NumberOfCellsOffset,
                          SubCircuitInstanceName, &SubCircuit, InputPorts,
                          NumberOfInputPorts, OutputPorts, NumberOfOutputPorts,
                          CurrentIO);

                      if (Task == Task_find_assign_signal_name1)
                        if (ch == '=')
                          Task = Task_find_assign_signal_name2;
                        else
                          Task = Task_find_equal;
                      else if (Task == Task_find_assign_signal_name2)
                        Task = -1;  // to avoid incrementing NumberOfCells
                      else
                        Task = Task_find_close_bracket;
                    }

                    j = 0;
                    Str1[0] = 0;
                  } else if (ch == '=') {
                    if (Task == Task_find_equal)
                      Task = Task_find_assign_signal_name2;
                    else {
                      free(Str1);
                      free(Str2);
                      free(Phrase);
                      free(SubCircuitInstanceName);
                      ErrorMessage = "Error in reading the netlist, Taskid: " +
                                     std::to_string(Task) +
                                     "!\n\"=\" is placed in a wrong position.";
                      throw std::runtime_error(ErrorMessage);
                    }
                  }
                } else if (ch == '(') {
                  if (Task == Task_find_open_bracket) {
                    if (IO_port_found)
                      Task = Task_find_signal_name;
                    else
                      Task = Task_find_IO_port;
                  } else if (Task == Task_find_IO_port) {
                    if (Str1[0] == '.') {
                      DesignFile_Find_IO_Port(
                          NumberOfCells, Str1, SubCircuitRead, CellTypeIndex,
                          CaseIndex, NumberOfSignalsOffset,
                          SubCircuitInstanceName, &SubCircuit, InputPorts,
                          NumberOfInputPorts, OutputPorts, NumberOfOutputPorts);

                      Task = Task_find_signal_name;
                    } else {
                      ErrorMessage = Str1;
                      ErrorMessage =
                          "Error in reading the netlist, '.' is expected in " +
                          ErrorMessage + "!";
                      free(Str1);
                      free(Str2);
                      free(Phrase);
                      free(SubCircuitInstanceName);
                      throw std::runtime_error(ErrorMessage);
                    }
                  } else {
                    ErrorMessage = "Error in reading the netlist, Taskid: " +
                                   std::to_string(Task) +
                                   "!\n\"(\" is placed in a wrong position.";
                    free(Str1);
                    free(Str2);
                    free(Phrase);
                    free(SubCircuitInstanceName);
                    throw std::runtime_error(ErrorMessage);
                  }

                  j = 0;
                  Str1[0] = 0;
                } else if (ch == ')') {
                  if (Task == Task_find_close_bracket) {
                    if (CurrentIO < MyNumberofIO) Task = Task_find_comma;
                  } else if (Task == Task_find_signal_name) {
                    DesignFile_Find_Signal_Name(
                        &NumberOfCells, Str1, SubCircuitRead, CellTypeIndex,
                        CaseIndex, settings, library, Task,
                        NumberOfSignalsOffset, NumberOfCellsOffset,
                        SubCircuitInstanceName, &SubCircuit, InputPorts,
                        NumberOfInputPorts, OutputPorts, NumberOfOutputPorts,
                        CurrentIO);

                    if (CurrentIO < MyNumberofIO)
                      Task = Task_find_comma;
                    else
                      Task = Task_find_close_bracket;
                  } else if (Task == Task_find_comma) {
                    Str1[0] = 0;
                    DesignFile_Find_IO_Port(
                        NumberOfCells, Str1, SubCircuitRead, CellTypeIndex,
                        CaseIndex, NumberOfSignalsOffset,
                        SubCircuitInstanceName, &SubCircuit, InputPorts,
                        NumberOfInputPorts, OutputPorts, NumberOfOutputPorts);

                    Str1[0] = 0;
                    DesignFile_Find_Signal_Name(
                        &NumberOfCells, Str1, SubCircuitRead, CellTypeIndex,
                        CaseIndex, settings, library, Task,
                        NumberOfSignalsOffset, NumberOfCellsOffset,
                        SubCircuitInstanceName, &SubCircuit, InputPorts,
                        NumberOfInputPorts, OutputPorts, NumberOfOutputPorts,
                        CurrentIO);

                    Task = Task_find_close_bracket;
                  } else {
                    ErrorMessage = "Error in reading the netlist, Taskid: " +
                                   std::to_string(Task) +
                                   "!\n\")\" is placed in a wrong position.";
                    free(Str1);
                    free(Str2);
                    free(Phrase);
                    free(SubCircuitInstanceName);
                    throw std::runtime_error(ErrorMessage);
                  }

                  j = 0;
                  Str1[0] = 0;
                } else if ((ch == ',') && (Str1[0] != '{')) {
                  if (Task == Task_find_comma) {
                    IO_port_found = 0;
                    Task = Task_find_IO_port;

                    j = 0;
                    Str1[0] = 0;
                  } else {
                    ErrorMessage = "Error in reading the netlist, Taskid: " +
                                   std::to_string(Task) +
                                   "!\n\".\" is placed in a wrong position.";
                    free(Str1);
                    free(Str2);
                    free(Phrase);
                    free(SubCircuitInstanceName);
                    throw std::runtime_error(ErrorMessage);
                  }
                } else {
                  Str1[j++] = ch;
                  Str1[j] = 0;
                }

              } while (ch != ';');

              if ((!SubCircuitRead) && (Task >= 0)) NumberOfCells++;

              Str1[0] = 0;
              Str2[0] = 0;
            }

          } while (strcmp(Str1, "endmodule") &&
                   (FileBuffer.Index <= FileBuffer.Size));

          finished = 1;
        }
      }
    }
  } while ((FileBuffer.Index <= FileBuffer.Size) && (!finished));

  free(Str1);
  free(Str2);
  free(Phrase);
  free(SubCircuitInstanceName);

  if (FB == NULL) {
    free(FileBuffer.Buffer);
  }

  if (!finished) {
    ErrorMessage = "Target module " + top_module_name + " not found!";
    throw std::runtime_error(ErrorMessage);
  }

  // turn '1bx' and '1hx' to constant 0
  safe_strcpy(signals_[4].Name, "1'b0", Max_Name_Len - 1);
  safe_strcpy(signals_[5].Name, "1'h0", Max_Name_Len - 1);
  return NumberOfCells;
}

// TODO: add to circuit.cpp
bool CircuitStruct::IsGateThatOutputsSignalDeleted(int signal_index) {
  return cells_[signals_[signal_index].Output].Deleted == 1;
}

uint64_t CircuitStruct::GetNumberOfInputsForSignalsComputingCell(
    uint64_t signal_index) const {
  if (signals_[signal_index].Output == -1) {
    std::string error_message =
        "Tried to access a cell that computes \"" +
        (std::string)signals_[signal_index].Name + "\". As  \"" +
        (std::string)signals_[signal_index].Name +
        "\" is a primary input, such a cell cannot be found!";
    throw std::logic_error(error_message);
  } else {
    return cells_[signals_[signal_index].Output].type->GetNumberOfInputs();
  }
}

std::vector<uint64_t> CircuitStruct::GetSignals() const {
  std::vector<uint64_t> result;
  int cell_index, output_index;

  result.push_back(0);
  result.push_back(1);
  result.push_back(2);
  result.push_back(3);
  result.push_back(4);
  result.push_back(5);

  for (cell_index = 0; cell_index < NumberOfInputs; ++cell_index) {
    result.push_back(Inputs[cell_index]);
  }

  for (uint64_t reg_idx : regs_) {
    for (output_index = 0;
         output_index < (int)cells_[reg_idx].type->GetNumberOfOutputs();
         ++output_index) {
      if (cells_[reg_idx].Outputs[output_index] != -1) {
        result.push_back(cells_[reg_idx].Outputs[output_index]);
      }
    }
  }

  for (short depth_index = 1; depth_index <= MaxDepth; ++depth_index) {
    for (cell_index = 0; cell_index < NumberOfCellsInDepth[depth_index];
         ++cell_index) {
      for (output_index = 0;
           output_index < (int)cells_[CellsInDepth[depth_index][cell_index]]
                              .type->GetNumberOfOutputs();
           ++output_index) {
        result.push_back(cells_[CellsInDepth[depth_index][cell_index]]
                             .Outputs[output_index]);
      }
    }
  }

  return result;
}

uint64_t CircuitStruct::GetSignalIndexByName(const std::string& signal_name) {
  uint64_t index, number_of_signals = NumberOfSignals;
  std::string current_signal_name;

  for (index = 0; index < number_of_signals; ++index) {
    current_signal_name = signals_[index].Name;

    if (current_signal_name == signal_name) {
      return index;
    }
  }

  if (index == number_of_signals) {
    throw std::logic_error("Error while searching a signal. The signal \"" +
                           signal_name + "\" could not be found!");
  }

  return 0;
}

void CircuitStruct::PropagateProbe(uint64_t signal_index, const bool allowed) {
  uint64_t input_index;
  signals_[signal_index].is_probe_allowed = allowed;

  if ((signals_[signal_index].Output == -1) ||
      cells_[signals_[signal_index].Output].type->IsRegister()) {
    signals_[signal_index].is_probe_allowed = false;
  } else {
    for (uint64_t index = 0;
         index < GetNumberOfInputsForSignalsComputingCell(signal_index);
         ++index) {
      input_index = cells_[signals_[signal_index].Output].Inputs[index];
      PropagateProbe(input_index, allowed);
    }
  }
}

void CircuitStruct::PropagateExtension(uint64_t signal_index,
                                       const bool allowed) {
  uint64_t input_index;
  signals_[signal_index].is_extension_allowed = allowed;

  if ((signals_[signal_index].Output == -1) ||
      cells_[signals_[signal_index].Output].type->IsRegister()) {
    signals_[signal_index].is_extension_allowed = false;
  } else {
    for (uint64_t index = 0;
         index < GetNumberOfInputsForSignalsComputingCell(signal_index);
         ++index) {
      input_index = cells_[signals_[signal_index].Output].Inputs[index];
      PropagateExtension(input_index, allowed);
    }
  }
}

void CircuitStruct::SetIsProbeAllowed(const Settings& settings) {
  uint64_t number_of_signals = NumberOfSignals;
  std::string signal_name;

  if (settings.side_channel_analysis.locations.first_include) {
    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signals_[index].is_probe_allowed = false;
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      if (signals_[index].Output == -1) {
        signals_[index].is_probe_allowed = false;
      } else {
        signal_name = signals_[index].Name;
        if (std::regex_match(
                signal_name,
                settings.side_channel_analysis.locations.included_elements)) {
          signals_[index].is_probe_allowed = true;
        }
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      if (signals_[index].Output == -1) {
        signals_[index].is_probe_allowed = false;
      } else {
        signal_name = signals_[index].Name;
        if (std::regex_match(
                signal_name,
                settings.side_channel_analysis.locations.included_paths)) {
          PropagateProbe(index, true);
        }
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = signals_[index].Name;
      if (std::regex_match(
              signal_name,
              settings.side_channel_analysis.locations.excluded_elements)) {
        signals_[index].is_probe_allowed = false;
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = signals_[index].Name;
      if (std::regex_match(
              signal_name,
              settings.side_channel_analysis.locations.excluded_paths)) {
        PropagateProbe(index, false);
      }
    }
  } else {
    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signals_[index].is_probe_allowed = true;
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = signals_[index].Name;
      if (std::regex_match(
              signal_name,
              settings.side_channel_analysis.locations.excluded_elements)) {
        signals_[index].is_probe_allowed = false;
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = signals_[index].Name;
      if (std::regex_match(
              signal_name,
              settings.side_channel_analysis.locations.excluded_paths)) {
        PropagateProbe(index, false);
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      if (signals_[index].Output == -1) {
        signals_[index].is_probe_allowed = false;
      } else {
        signal_name = signals_[index].Name;
        if (std::regex_match(
                signal_name,
                settings.side_channel_analysis.locations.included_elements)) {
          signals_[index].is_probe_allowed = true;
        }
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      if (signals_[index].Output == -1) {
        signals_[index].is_probe_allowed = false;
      } else {
        signal_name = signals_[index].Name;
        if (std::regex_match(
                signal_name,
                settings.side_channel_analysis.locations.included_paths)) {
          PropagateProbe(index, true);
        }
      }
    }
  }

  if (settings.GetMinimization() != Minimization::none) {
    for (uint64_t index = 0; index < number_of_signals; ++index) {
      uint64_t number_of_inputs = signals_[index].NumberOfInputs;
      for (uint64_t input_index = 0; input_index < number_of_inputs;
           ++input_index) {
        if (!cells_[signals_[index].Inputs[input_index]].type->IsRegister()) {
          signals_[index].is_probe_allowed = false;
          break;
        }
      }
    }

    if (settings.IsRelaxedModel()) {
      uint64_t signal_index;
      for (uint64_t index = 0; index < number_of_signals; ++index) {
        if (signals_[index].is_probe_allowed) {
          signal_index = index;

          while (
              (signals_[signal_index].Output != -1) &&
              (GetNumberOfInputsForSignalsComputingCell(signal_index) == 1) &&
              (!signals_[signal_index].Deleted)) {
            signal_index = cells_[signals_[signal_index].Output].Inputs[0];
          }

          if (signals_[signal_index].Output != -1) {
            signals_[signal_index].is_probe_allowed = true;
          }
        }
      }
    }
  }

  for (uint64_t index = 0; index < number_of_signals; ++index) {
    if (signals_[index].Deleted) {
      signals_[index].is_probe_allowed = false;
    }
  }
}

void CircuitStruct::SetIsExtensionAllowed(const Settings& settings) {
  uint64_t number_of_signals = NumberOfSignals;
  std::string signal_name;

  if (settings.side_channel_analysis.extension.first_include) {
    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signals_[index].is_extension_allowed = false;
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      if ((signals_[index].Output == -1) ||
          cells_[signals_[index].Output].type->IsRegister()) {
        signals_[index].is_extension_allowed = false;
      } else {
        signal_name = signals_[index].Name;
        if (std::regex_match(
                signal_name,
                settings.side_channel_analysis.extension.included_elements)) {
          signals_[index].is_extension_allowed = true;
        }
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      if ((signals_[index].Output == -1) ||
          cells_[signals_[index].Output].type->IsRegister()) {
        signals_[index].is_extension_allowed = false;
      } else {
        signal_name = signals_[index].Name;
        if (std::regex_match(
                signal_name,
                settings.side_channel_analysis.extension.included_paths)) {
          PropagateExtension(index, true);
        }
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = signals_[index].Name;
      if (std::regex_match(
              signal_name,
              settings.side_channel_analysis.extension.excluded_elements)) {
        signals_[index].is_extension_allowed = false;
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = signals_[index].Name;
      if (std::regex_match(
              signal_name,
              settings.side_channel_analysis.extension.excluded_paths)) {
        PropagateExtension(index, false);
      }
    }
  } else {
    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signals_[index].is_extension_allowed = true;
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = signals_[index].Name;
      if (std::regex_match(
              signal_name,
              settings.side_channel_analysis.extension.excluded_elements)) {
        signals_[index].is_extension_allowed = false;
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = signals_[index].Name;
      if (std::regex_match(
              signal_name,
              settings.side_channel_analysis.extension.excluded_paths)) {
        PropagateExtension(index, false);
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      if ((signals_[index].Output == -1) ||
          cells_[signals_[index].Output].type->IsRegister()) {
        signals_[index].is_extension_allowed = false;
      } else {
        signal_name = signals_[index].Name;
        if (std::regex_match(
                signal_name,
                settings.side_channel_analysis.extension.included_elements)) {
          signals_[index].is_extension_allowed = true;
        }
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      if ((signals_[index].Output == -1) ||
          cells_[signals_[index].Output].type->IsRegister()) {
        signals_[index].is_extension_allowed = false;
      } else {
        signal_name = signals_[index].Name;
        if (std::regex_match(
                signal_name,
                settings.side_channel_analysis.extension.included_paths)) {
          PropagateExtension(index, true);
        }
      }
    }
  }

  for (uint64_t index = 0; index < number_of_signals; ++index) {
    if (signals_[index].Deleted) {
      signals_[index].is_extension_allowed = false;
    }
  }
}

void CircuitStruct::SetIsAnalysisAllowed(const Settings& settings) {
  uint64_t number_of_signals = signals_.size();
  uint64_t number_of_constants = NumberOfConstants;
  std::string signal_name;

  if (settings.side_channel_analysis.analysis.first_include) {
    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signals_[index].is_analysis_allowed = false;
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = signals_[index].Name;
      if (std::regex_match(
              signal_name,
              settings.side_channel_analysis.analysis.included_elements)) {
        signals_[index].is_analysis_allowed = true;
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = signals_[index].Name;
      if (std::regex_match(
              signal_name,
              settings.side_channel_analysis.analysis.excluded_elements)) {
        signals_[index].is_analysis_allowed = false;
      }
    }
  } else {
    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signals_[index].is_analysis_allowed = true;
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = signals_[index].Name;
      if (std::regex_match(
              signal_name,
              settings.side_channel_analysis.analysis.excluded_elements)) {
        signals_[index].is_analysis_allowed = false;
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = signals_[index].Name;
      if (std::regex_match(
              signal_name,
              settings.side_channel_analysis.analysis.included_elements)) {
        signals_[index].is_analysis_allowed = true;
      }
    }
  }

  for (uint64_t index = 0; index < number_of_constants; ++index) {
    signals_[index].is_analysis_allowed = false;
  }

  std::string with_point = "." + settings.GetClockSignalName();

  for (uint64_t index = 0; index < number_of_signals; ++index) {
    signal_name = signals_[index].Name;
    if (signal_name == settings.GetClockSignalName() ||
        signal_name.find(with_point) != std::string::npos) {
      signals_[index].is_analysis_allowed = false;
    }
  }

  for (uint64_t index = 0; index < number_of_signals; ++index) {
    if (signals_[index].Deleted) {
      signals_[index].is_analysis_allowed = false;
    }
  }
}

void CircuitStruct::SetIsFaultAllowed(const Settings& settings) {
  uint64_t number_of_signals = signals_.size();
  std::string signal_name;

  if (settings.fault_injection.locations.first_include) {
    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signals_[index].is_fault_allowed = false;
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = signals_[index].Name;
      if (std::regex_match(
              signal_name,
              settings.fault_injection.locations.included_elements)) {
        signals_[index].is_fault_allowed = true;
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = signals_[index].Name;
      if (std::regex_match(
              signal_name,
              settings.fault_injection.locations.excluded_elements)) {
        signals_[index].is_fault_allowed = false;
      }
    }
  } else {
    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signals_[index].is_fault_allowed = true;
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = signals_[index].Name;
      if (std::regex_match(
              signal_name,
              settings.fault_injection.locations.excluded_elements)) {
        signals_[index].is_fault_allowed = false;
      }
    }

    for (uint64_t index = 0; index < number_of_signals; ++index) {
      signal_name = signals_[index].Name;
      if (std::regex_match(
              signal_name,
              settings.fault_injection.locations.included_elements)) {
        signals_[index].is_fault_allowed = true;
      }
    }
  }

  for (uint64_t index = 0; index < number_of_signals; ++index) {
    if (signals_[index].Deleted) {
      signals_[index].is_fault_allowed = false;
    }
  }

  // TODO set clock signal to false
}

// NOTE: Global inputs are not allowed to be faulted!
// TODO: I would prefer to switch to pointer here!
bool CircuitStruct::IsFaultOnSignalAllowed(uint64_t signal_index,
                                           uint64_t clock_signal_index) const {
  return !signals_[signal_index].Deleted &&
         (signal_index != clock_signal_index) &&
         signals_[signal_index].Type != signal_t::input;
}
