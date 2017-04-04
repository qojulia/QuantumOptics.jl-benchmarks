import qutip as qt
import numpy as np
import benchmarkutils

name = "timeevolution_particle"

samples = 3
evals = 3
cutoffs = range(100, 501, 100)

options = qt.Options()
options.num_cpus = 1
options.nsteps = 10000
options.atol = 1e-6
options.rtol = 1e-6

xmin = -10
xmax = 10

x0 = 2
p0 = 1
sigma0 = 1

def setup(Npoints):
    dx = (xmax - xmin)/Npoints
    pmin = -np.pi/dx
    pmax = np.pi/dx
    dp = (pmax - pmin)/Npoints

    samplepoints_x = np.linspace(xmin, xmax, Npoints, endpoint=False)
    samplepoints_p = np.linspace(pmin, pmax, Npoints, endpoint=False)

    x = qt.Qobj(np.diag(samplepoints_x))
    @np.vectorize
    def momentumoperator(xi, xj):
        return sum([p*np.exp(1j*p*(xj-xi)) for p in samplepoints_p])*dp*dx/(2*np.pi)

    p = qt.Qobj(momentumoperator(*np.meshgrid(samplepoints_x, samplepoints_x)))
    H = p**2 + 2*x**2

    def gaussianstate(x0, p0, sigma):
        alpha = 1./(np.pi**(1/4)*np.sqrt(sigma))*np.sqrt(dx)
        data = alpha*np.exp(1j*p0*(samplepoints_x-x0) - (samplepoints_x-x0)**2/(2*sigma**2))
        return qt.Qobj(data)

    psi0 = gaussianstate(2., 1., 1.)
    return psi0, H, x

def f(psi0, H, x):
    tlist = np.linspace(0, 1, 11)
    exp_x = qt.mesolve(H, psi0, tlist, [], [x], options=options).expect[0]
    return exp_x

print("Benchmarking:", name)
print("Cutoff: ", end="", flush=True)
checks = {}
results = []
for N in cutoffs:
    print(N, "", end="", flush=True)
    psi0, H, x = setup(N)
    checks[N] = sum(f(psi0, H, x))
    t = benchmarkutils.run_benchmark(f, psi0, H, x, samples=samples, evals=evals)
    results.append({"N": N, "t": t})
print()

benchmarkutils.check(name, checks, 1e-4)
benchmarkutils.save(name, results)
