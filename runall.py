import subprocess

subprocess.run(["python", "hardware-specs.py"], check=True)
subprocess.run(["julia", "run_QuantumOptics.jl"], check=True)
subprocess.run(["python", "run_QuTiP.py"], check=True)
