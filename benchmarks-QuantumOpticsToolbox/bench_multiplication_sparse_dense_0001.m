
function result = bench_multiplication_sparse_dense_0001()
    name = 'multiplication_sparse_dense_0001';
    s = 0.001;
    cutoffs = [50:50:1001];
    result = [];
    Nrand = 5;
    for N = cutoffs
        T = 0.;
        for i=1:Nrand
            op1 = (1.+0.3j)*sprand(N, N, s);
            op2 = (1.+0.3j)*rand(N, N);
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
