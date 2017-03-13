import qutip as qt
import numpy as np
import benchmarkutils

name = "timeevolution_master"

samples = 2
evals = 2
cutoffs = range(10, 51, 10)

def f(Ncutoff):
    kap = 1.
    eta = 4*kap
    delta = 0
    tmax = 100
    tsteps = 201
    tlist = np.linspace(0, tmax, tsteps)

    a = qt.destroy(Ncutoff)
    ad = a.dag()
    H = delta*ad*a + eta*(a + ad)
    c_ops = [np.sqrt(2*kap)*a]

    psi0 = qt.basis(Ncutoff, 0)
    opts = qt.Odeoptions(num_cpus=1)
    n = qt.mesolve(H, psi0, tlist, c_ops, [ad*a], options=opts).expect[0]
    return n

print("Benchmarking:", name)
print("Cutoff: ", end="", flush=True)
results = []
for N in cutoffs:
    print(N, "", end="", flush=True)
    t = benchmarkutils.run_benchmark(f, N, samples=samples, evals=evals)
    results.append({"N": N, "t": t})
print()

benchmarkutils.save(name, results)
