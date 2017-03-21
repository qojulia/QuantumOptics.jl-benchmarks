
function result = bench_expect_state()
    name = 'expect_state';
    cutoffs = [5000:5000:70000];
    result = [];
    for N = cutoffs
        op = (destroy(N) + create(N));
        psi = qo(ones(N, 1)/(N^(1/2)));
        f_ = @() f(op, psi);
        result = [result, timeit(f_)];
    end
    savebenchmark(name, cutoffs, result)
end

function result = f(op, state)
    result = expect(op, state);
end
