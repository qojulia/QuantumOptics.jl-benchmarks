
function result = bench_multiplication()
    name = 'multiplication';
    s = 0.01;
    cutoffs = [50:50:1001];
    result = [];
    for N = cutoffs
        op1 = sprandn(N, N, s);
        op2 = sprandn(N, N, s);
        f_ = @() f(op1, op2);
        result = [result, timeit(f_)];
    end
    savebenchmark(name, cutoffs, result)
end

function result = f(op1, op2)
    result = op1*op2;
end
