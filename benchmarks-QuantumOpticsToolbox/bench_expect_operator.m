
function result = bench_expect_operator()
    name = 'expect_operator';
    cutoffs = [100:100:700];
    result = [];
    for N = cutoffs
        op = (destroy(N) + create(N));
        psi = qo(ones(N, 1)/(N^(1/2)));
        rho = psi*psi';
        f_ = @() f(op, rho);
        result = [result, timeit(f_)];
    end
    savebenchmark(name, cutoffs, result)
end

function result = f(op, state)
    result = expect(op, state);
end
