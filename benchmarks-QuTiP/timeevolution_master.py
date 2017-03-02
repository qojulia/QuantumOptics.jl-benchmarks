import qutip as qt
import numpy as np
import timeit

cutoffs = [2, 3, 5, 7, 10, 15, 20, 30, 50]

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
