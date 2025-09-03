project('prolead', 'cpp',
  version: '3.0.3',
  default_options: ['warning_level=3', 'cpp_std=c++20']
)

# --- Dependencies ---
qhull_dep = dependency('qhull_r', required: true)
zlib_dep = dependency('zlib', required: true)
python_dep = dependency('python3-embed', required: true)
flint_dep = dependency('flint', required: true)
boost_dep = dependency(
  'boost',
  version: '>= 1.75.0',
  modules: ['program_options', 'log', 'log_setup', 'thread', 'system', 'filesystem', 'json', 'graph'],
)
omp_dep = dependency('openmp', required: true)

clipper_inc = include_directories('gdstk/external')
gdstk_inc = include_directories('gdstk/include', 'gdstk/external')


clipper_src = [
  'gdstk/external/clipper/clipper.cpp',
]
clipper = static_library(
  'clipper',
  sources: clipper_src,
  include_directories: clipper_inc,
  cpp_args: [
    '-std=c++11',
    '-Wno-pedantic'
  ]
)

gdstk_src = [
  'gdstk/src/cell.cpp',
  'gdstk/src/clipper_tools.cpp',
  'gdstk/src/curve.cpp',
  'gdstk/src/flexpath.cpp',
  'gdstk/src/gdsii.cpp',
  'gdstk/src/label.cpp',
  'gdstk/src/library.cpp',
  'gdstk/src/oasis.cpp',
  'gdstk/src/polygon.cpp',
  'gdstk/src/property.cpp',
  'gdstk/src/raithdata.cpp',
  'gdstk/src/rawcell.cpp',
  'gdstk/src/reference.cpp',
  'gdstk/src/repetition.cpp',
  'gdstk/src/robustpath.cpp',
  'gdstk/src/style.cpp',
  'gdstk/src/utils.cpp'
]
gdstk = static_library(
  'gdstk',
  sources: gdstk_src,
  include_directories: gdstk_inc,
  dependencies: [qhull_dep, zlib_dep],
  cpp_args: [
    '-std=c++11',
    '-Wno-pedantic'
    ]
)

# gdsscanner_inc = include_directories('inc/Hardware/gds')
gdsscanner_src = [
  'src/Hardware/gds/GDSScanner.cpp',
  'src/Hardware/gds/AttackedSurface.cpp',
  'src/Hardware/gds/Blacklist.cpp',
  'src/Hardware/gds/BoundingBox.cpp',
  'src/Hardware/gds/Coordinate.cpp',
  'src/Hardware/gds/GDSProbe.cpp',
  'src/Hardware/gds/GDSRectangle.cpp',
  'src/Hardware/gds/Gate.cpp',
  'src/Hardware/gds/gdstk_utils.cpp',
  ]

# prolead_hw_inc = include_directories(['inc/Hardware', 'inc/Hardware/gds/utils/gdstk'])
prolead_hw_src = [
    'src/Hardware/Adversaries.cpp',
    'src/Hardware/Cell.cpp',
    'src/Hardware/Circuit.cpp',
    'src/Hardware/Enabler.cpp',
    'src/Hardware/Execute.cpp',
    'src/Hardware/Expression.cpp',
    'src/Hardware/FaultManager.cpp',
    'src/Hardware/FaultSet.cpp',
    'src/Hardware/LibHelper.cpp',
    'src/Hardware/Library.cpp',
    'src/Hardware/ProbingSets.cpp',
    'src/Hardware/SampledRFAdversary.cpp',
    'src/Hardware/SharedData.cpp',
    'src/Hardware/Simulate.cpp',
    'src/Hardware/Target.cpp',
    'src/Hardware/TruthTable.cpp',
  ]

# prolead_util_inc = include_directories(['inc/Util', 'inc/Util/Grammars'])
prolead_util_src = [
    'src/Software/Analyze.cpp',
    'src/Software/Definitions.cpp',
    'src/Software/Execute.cpp',
    'src/Software/mulator/architectures.cpp',
    'src/Software/mulator/arm_functions.cpp',
    'src/Software/mulator/conditions.cpp',
    'src/Software/mulator/disassembler.cpp',
    'src/Software/mulator/emulator_base.cpp',
    'src/Software/mulator/emulator_execution.cpp',
    'src/Software/mulator/instruction.cpp',
    'src/Software/mulator/instruction_decoder.cpp',
    'src/Software/mulator/mnemonics.cpp',
    'src/Software/mulator/registers.cpp',
    'src/Software/mulator/return_codes.cpp',
    'src/Software/mulator/shift_types.cpp',
    'src/Software/Operators.cpp',
    'src/Software/Prepare.cpp',
    'src/Software/Print.cpp',
    'src/Software/Probing.cpp',
    'src/Software/Read.cpp',
    'src/Software/Simulate.cpp',
    'src/Software/Test.cpp',
  ]

# prolead_sw_inc = include_directories(['inc/Software', 'inc/Software/mulator'])
prolead_sw_src = [
    'src/Util/CpuCoreSelector.cpp',
    'src/Util/FileParsing.cpp',
    'src/Util/Grammars/BoolExprGrammar.cpp',
    'src/Util/Grammars/RangeGrammar.cpp',
    'src/Util/Grammars/SignalNameGrammar.cpp',
    'src/Util/Grammars/VlogConstGrammar.cpp',
    'src/Util/Logger.cpp',
    'src/Util/ProgramOptions.cpp',
    'src/Util/Settings.cpp',
    'src/Util/SettingsSchema.cpp',
    'src/Util/Sharing.cpp',
    'src/Util/Simulator.cpp',
    'src/Util/Util.cpp',
]

project_inc = [
  # gdsscanner_inc,
  'inc'
  # prolead_hw_inc,
  # prolead_util_inc,
  # prolead_sw_inc
  ]
sources = [
  'src/PROLEAD.cpp',
  gdsscanner_src,
  prolead_hw_src,
  prolead_sw_src,
  prolead_util_src
]

# Executable
executable(
  'prolead',
  sources,
  dependencies: [
    qhull_dep,
    zlib_dep,
    flint_dep,
    python_dep,
    boost_dep,
    omp_dep
  ],
  include_directories: [project_inc, clipper_inc, gdstk_inc],  # Add gdstk_inc here
  link_with: [
    gdstk,
    clipper,
  ]
)
