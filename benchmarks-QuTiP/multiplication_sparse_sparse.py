import scipy.sparse as sp
import benchmarkutils

name = "multiplication_sparse_sparse"

samples = 5
evals = 100
cutoffs = range(50, 1001, 50)

def setup(N):
    s = 0.01
    op1 = sp.rand(N, N, s, dtype=float)*0.2j
    op2 = sp.rand(N, N, s, dtype=float)*0.1j
    return op1, op2

def f(op1, op2):
    return op1*op2

print("Benchmarking:", name)
print("Cutoff: ", end="", flush=True)
results = []
for N in cutoffs:
    print(N, "", end="", flush=True)
    op1, op2 = setup(N)
    t = benchmarkutils.run_benchmark(f, op1, op2, samples=samples, evals=evals)
    results.append({"N": N, "t": t})
print()

benchmarkutils.save(name, results)
