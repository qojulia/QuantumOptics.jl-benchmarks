
function result = bench_multiplication_sparse_sparse_001()
    name = 'multiplication_sparse_sparse_001';
    s = 0.01;
    cutoffs = [50:50:1001];
    result = [];
    Nrand = 5;
    for N = cutoffs
        T = 0.;
        for i=1:Nrand
            op1 = (1.+0.3j)*sprand(N, N, s);
            op2 = (1.+0.3j)*sprand(N, N, s);
            f_ = @() f(op1, op2);
            T = T + timeit(f_);
        end
        result = [result, T/Nrand];
    end
    savebenchmark(name, cutoffs, result)
end

function result = f(op1, op2)
    result = op1*op2;
end
