import qutip as qt
import numpy as np
import benchmarkutils

name = "qfunc_operator"

samples = 3
evals = 5
cutoffs = range(10, 101, 10)

alpha = 0.7
xvec = np.linspace(-50, 50, 101)
yvec = np.linspace(-50, 50, 101)

def f(state, xvec, yvec):
    return qt.qfunc(state, xvec, yvec)

print("Benchmarking:", name)
print("Cutoff: ", end="", flush=True)
results = []
for N in cutoffs:
    print(N, "", end="", flush=True)
    state = qt.coherent(N, alpha)
    op = state*state.dag()
    t = benchmarkutils.run_benchmark(f, op, xvec, yvec, samples=samples, evals=evals)
    results.append({"N": N, "t": t})
print()

benchmarkutils.save(name, results)
