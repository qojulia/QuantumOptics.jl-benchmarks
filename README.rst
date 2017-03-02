Benchmarks for Quantum Optics Frameworks
========================================

The aim is to simulate the same examples on as many different frameworks as possible:
* Matlab: Quantum Optics Toolbox
* Python: QuTiP
* Julia: QuantumOptics.jl
* C++: C++QED


Setting up the testing environment
----------------------------------

To reduce noise dedicate a cpu core for the benchmarks. This can be done with cset:

    sudo cset shield -k on -c 0
    sudo cset shield --user=sebastian --group=users -e bash

Especially for julia one still has to set the users home directory:

    HOME=/home/sebastian