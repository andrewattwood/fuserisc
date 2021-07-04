# FuseRISC 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![UPRJ_CI](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml) [![Caravel Build](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml)



   <p align="center">
   <img src="./docs/source/fuserisc.png" width="50%" height="50%">
   </p>

### FuseRISC will demonstrate the benefits of the tight coupling of RISC-V cores and eFPGA fabric for tensorflow micro applications. Two RISC-V cores will have ALU that are integrated directly with a customised eFPGA fabric generated using the FABulous eFPGA framework. Each core is coupled to the caravel wishbone interface and has access to a 1kb OpenRAM SKY130 Standard SRAM. Other control pins are connected to the caravel LA probes. The RISC-V cores are modified IBEX cores from lowRISC.



// SPDX-License-Identifier: Apache-2.0
