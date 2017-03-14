import qutip as qt
import numpy as np
import benchmarkutils

name = "coherentstate"

samples = 5
evals = 20
cutoffs = range(10, 10011, 1000)

alpha = 0.7

def f(N, alpha):
    return qt.coherent(N, alpha, method="analytic")

print("Benchmarking:", name)
print("Cutoff: ", end="", flush=True)
results = []
for N in cutoffs:
    print(N, "", end="", flush=True)
    t = benchmarkutils.run_benchmark(f, N, alpha, samples=samples, evals=evals)
    results.append({"N": N, "t": t})
print()

benchmarkutils.save(name, results)
