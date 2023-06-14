# PROLEAD - A Probing-Based Leakage Detection Tool for Hardware and Software
This repository contains the source code for the papers <a href="https://tches.iacr.org/index.php/TCHES/article/view/9822">PROLEAD - A Probing-Based Hardware Leakage Detection Tool</a> and <a href="https://eprint.iacr.org/2023/034.pdf">PROLEAD_SW - Probing-Based Software Leakage Detection for ARM Binaries</a>.
For a quick start, we recommend to watch the quick start guides on our <a href="https://www.youtube.com/channel/UCTCuC2NMxaFPtDb4yGHHwTg">Youtube Channel</a> or to read the <a href="https://github.com/ChairImpSec/PROLEAD/wiki/Hardware-beginner's-guide">Hardware beginner's guide</a> or <a href="https://github.com/ChairImpSec/PROLEAD/wiki/Software-beginner's-guide">Software beginner's guide</a> .

## Features
PROLEAD allows to analyze the robust probing security of masked implementations provided as a Verilog netlist or ARM binary. In particular, PROLEAD supports the following features:

- Evaluation of masked hardware designs (Verilog netlists)
  - Consideration of glitches and transitions (simultaneously) 
  - Univariate and multivariate adversaries
  
- Evaluation of masked software designs (ARM binaries)  
  - Consideration of various micro-architectural effects (simultaneously)
    - Neighbor Leakage Effects
    - Bit-wise Interaction Leakages
    - Memory Overwrite Effects
    - Memory Remnant Effecs
    - Pipeline Register Overwrites
    - Pipeline Forwarding Effects
  - CPU-independent leakage detection  

## Documentation
All information about the features and use of PROLEAD can be found in the <a href="https://github.com/ChairImpSec/PROLEAD/wiki">Wiki</a>.

## Examples
Some selected examples can be found in the <a href="https://github.com/ChairImpSec/PROLEAD/tree/main/examples">examples</a> folder. More information regarding the examples can be found in the <a href="https://github.com/ChairImpSec/PROLEAD/wiki/Examples">Wiki</a>. We will provide more examples soon.

## Contact and Support
Please contact Nicolai Müller (nicolai.mueller@rub.de) if you have any questions, comments, if you found a bug that should be corrected, or if you want to reuse PROLEAD or parts of it for your own research projects.

## Publications 
- N. Müller, A. Moradi (2022): <a href="https://tches.iacr.org/index.php/TCHES/article/view/9822">PROLEAD - A Probing-Based Hardware Leakage Detection Tool</a>
- J. Zeitschner, N. Müller, A. Moradi (2023): <a href="https://eprint.iacr.org/2023/034.pdf">PROLEAD_SW - Probing-Based Software Leakage Detection for ARM Binaries</a> (pre-print)
