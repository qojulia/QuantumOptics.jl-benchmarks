import qutip as qt
from qutip.wigner import _qfunc_pure
import numpy as np
import benchmarkutils

name = "qfunc_state"

samples = 3
evals = 5
cutoffs = range(10, 101, 10)

alpha = 0.7
xvec = np.linspace(-50, 50, 100)
yvec = np.linspace(-50, 50, 100)

def f(state, xvec, yvec):
    return qt.qfunc(state, xvec, yvec)

print("Benchmarking:", name)
print("Cutoff: ", end="", flush=True)
results = []
for N in cutoffs:
    print(N, "", end="", flush=True)
    state = qt.coherent(N, alpha)
    t = benchmarkutils.run_benchmark(f, state, xvec, yvec, samples=samples, evals=evals)
    results.append({"N": N, "t": t})
print()

benchmarkutils.save(name, results)
