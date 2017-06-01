import qutip as qt
import numpy as np
import benchmarkutils

name = "timeevolution_master"

samples = 3
evals = 1
cutoffs = range(5, 56, 5)

def setup(N):
    options = qt.Options()
    options.atol = 1e-8
    options.rtol = 1e-6
    return options

def f(N, options):
    kappa = 1.
    eta = 4*kappa
    delta = 0
    tspan = np.linspace(0, 100, 201)

    a = qt.destroy(N)
    at = qt.create(N)
    n = at*a

    H = delta*n + eta*(a + at)
    c_ops = [np.sqrt(2*kappa)*a]

    psi0 = qt.basis(N, 0)
    n = qt.mesolve(H, psi0, tspan, c_ops, [n], options=options).expect[0]
    return n

print("Benchmarking:", name)
print("Cutoff: ", end="", flush=True)
checks = {}
results = []
for N in cutoffs:
    print(N, "", end="", flush=True)
    options = setup(N)
    checks[N] = sum(f(N, options))
    t = benchmarkutils.run_benchmark(f, N, options, samples=samples, evals=evals)
    results.append({"N": N, "t": t})
print()

benchmarkutils.check(name, checks)
# benchmarkutils.save(name, results)
