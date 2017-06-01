
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
    kappa = 1.;
    eta = 4*kappa;
    delta = 0;
    tspan = 0:0.5:100;

    a = destroy(Ncutoff);
    at = create(Ncutoff);
    n = at*a;
    
    H = delta*n + eta*(a + at);
    C = sqrt(2*kappa)*a;
    LH = -1i * (spre(H) - spost(H)); 
    L1 = spre(C)*spost(C')-0.5*spre(C'*C)-0.5*spost(C'*C);
    L = LH+L1;


    psi0 = basis(Ncutoff, 1);
    rho0 = psi0 * psi0';
    
    % Set up options, if required
    options.reltol = 1e-6;
    options.abstol = 1e-8;
    % Write out the data file
    ode2file('file1.dat', L, rho0, tspan, options);
    % Call the equation solver
    odesolve('file1.dat','file2.dat');
    % Read in the output data file
    fid = fopen('file2.dat','rb');
    rho = qoread(fid, dims(rho0), size(tspan));
    fclose(fid);
    result = real(expect(n, rho));
end
