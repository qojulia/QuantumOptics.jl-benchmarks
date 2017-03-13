import qutip as qt
import numpy as np
import benchmarkutils

name = "expect_operator"

samples = 5
evals = 1000
cutoffs = range(100, 2001, 100)

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
    rho = psi*psi.dag()
    t = benchmarkutils.run_benchmark(f, op, rho, samples=samples, evals=evals)
    results.append({"N": N, "t": t})
print()

benchmarkutils.save(name, results)
