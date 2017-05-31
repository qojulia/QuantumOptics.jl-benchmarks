
function result = bench_multiplication_sparse_dense_01()
    name = 'multiplication_sparse_dense_01';
    s = 0.1;
    cutoffs = [50:50:1001];
    result = [];
    Nrand = 5;
    for N = cutoffs
        T = 0.;
        for i=1:Nrand
            op1 = sprand(N, N, s);
            op2 = rand(N, N);
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
