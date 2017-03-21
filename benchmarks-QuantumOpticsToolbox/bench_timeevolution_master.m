
function result = bench_timeevolution_master()
    name = 'timeevolution_master';
    cutoffs = [5:5:40];
    result = [];
    for N = cutoffs
        f_ = @() f(N);
        result = [result, timeit(f_)];
    end
    savebenchmark(name, cutoffs, result)
end

function f(Ncutoff)
    kap = 1.;
    eta = 4*kap;
    delta = 0;
    tmax = 100;
    tsteps = 201;
    tlist = linspace(0, tmax, tsteps);
    a = destroy(Ncutoff);
    ad = a';
    H = delta*ad*a + eta*(a + ad);
    C = sqrt(2*kap)*a;
    LH = -1i * (spre(H) - spost(H)); 
    L1 = spre(C)*spost(C')-0.5*spre(C'*C)-0.5*spost(C'*C);
    L = LH+L1;


    psi0 = basis(Ncutoff, 1);
    rho0 = psi0 * psi0';
    
    % Set up options, if required
    options.reltol = 1e-6;
    options.abstol = 1e-6;
    % Write out the data file
    ode2file('file1.dat', L, rho0, tlist, options);
    % Call the equation solver
    odesolve('file1.dat','file2.dat');
end
