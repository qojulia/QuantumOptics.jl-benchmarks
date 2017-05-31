import scipy.sparse as sp
import benchmarkutils

name = "multiplication_dense_sparse_01"

samples = 2
evals = 5
cutoffs = range(50, 1001, 50)
Nrand = 5

def setup(N):
    s = 0.1
    op1 = sp.rand(N, N, 1., dtype=float)*0.2j
    op2 = sp.rand(N, N, s, dtype=float)*0.1j
    return op1, op2

def f(op1, op2):
    return op1*op2

print("Benchmarking:", name)
print("Cutoff: ", end="", flush=True)
results = []
for N in cutoffs:
    print(N, "", end="", flush=True)
    T = 0.
    for i in range(Nrand):
        op1, op2 = setup(N)
        T += benchmarkutils.run_benchmark(f, op1, op2, samples=samples, evals=evals)
    results.append({"N": N, "t": T/Nrand})
print()

benchmarkutils.save(name, results)
