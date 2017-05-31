
function result = bench_multiplication_dense_sparse_01()
    name = 'multiplication_dense_sparse_01';
    s = 0.1;
    cutoffs = [50:50:1001];
    result = [];
    Nrand = 5;
    for N = cutoffs
        T = 0.;
        for i=1:Nrand
            op1 = rand(N, N);
            op2 = sprand(N, N, s);
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
