import scipy.sparse as sp
import benchmarkutils

name = "multiplication_dense_sparse"

samples = 5
evals = 100
cutoffs = range(50, 1001, 50)

s = 0.01

def f(op1, op2):
    return op1*op2

print("Benchmarking:", name)
print("Cutoff: ", end="", flush=True)
results = []
for N in cutoffs:
    print(N, "", end="", flush=True)
    op1 = sp.rand(N, N, 1., dtype=float)*0.2j
    op2 = sp.rand(N, N, s, dtype=float)*0.1j
    t = benchmarkutils.run_benchmark(f, op1, op2, samples=samples, evals=evals)
    results.append({"N": N, "t": t})
print()

benchmarkutils.save(name, results)
