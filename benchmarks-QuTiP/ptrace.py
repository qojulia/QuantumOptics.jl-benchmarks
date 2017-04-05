import qutip as qt
import numpy as np
import benchmarkutils

name = "ptrace"

samples = 5
evals = 100
cutoffs = range(2, 16)

def create_suboperator(c0, alpha, N):
    x = np.linspace(0., 1., N**2)
    data = (c0 + alpha*x).reshape(N, N)
    return qt.Qobj(data)

def create_operator(Ncutoff):
    op1 = create_suboperator(1, 0.2, Ncutoff)
    op2 = create_suboperator(-2, 0.3, Ncutoff)
    op3 = create_suboperator(3, 0.4, 2)
    op4 = create_suboperator(4, 0.5, 2)
    return qt.tensor(op1, op2, op3, op4)

def f(op):
    return qt.ptrace(op, [1, 2])

print("Benchmarking:", name)
print("Cutoff: ", end="", flush=True)
checks = {}
results = []
for N in cutoffs:
    print(N, "", end="", flush=True)
    op = create_operator(N)
    checks[N] = abs(f(op).full()).sum()
    t = benchmarkutils.run_benchmark(f, op, samples=samples, evals=evals)
    results.append({"N": 4*N**2, "t": t})
print()

benchmarkutils.check(name, checks)
benchmarkutils.save(name, results)
