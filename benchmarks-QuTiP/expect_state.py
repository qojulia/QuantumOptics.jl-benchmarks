import qutip as qt
import numpy as np
import benchmarkutils

name = "expect_state"

samples = 5
evals = 1000
cutoffs = range(5000, 100001, 5000)
# cutoffs = [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, ]

alpha = 0.7

def f(op, state):
    return qt.expect(op, state)

print("Benchmarking:", name)
print("Cutoff: ", end="", flush=True)
results = []
for N in cutoffs:
    print(N, "", end="", flush=True)
    op = (qt.destroy(N) + qt.create(N))
    psi = qt.Qobj(np.ones(N, complex)/(N**(1/2)))
    t = benchmarkutils.run_benchmark(f, op, psi, samples=samples, evals=evals)
    results.append({"N": N, "t": t})
print()

benchmarkutils.save(name, results)
