using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

srand(0)

name = "multiplication_dense_sparse_001"

samples = 2
evals = 5
cutoffs = [50:50:1000;]
Nrand = 5

function setup(N)
    s = 0.01
    b = GenericBasis(N)
    op1 = randoperator(b)
    op2 = SparseOperator(b, sprand(Complex128, N, N, s))
    result = DenseOperator(b)
    op1, op2, result
end

function f(op1, op2, result)
    operators.gemm!(Complex128(1., 0.), op1, op2, Complex128(0., 0.), result)
end

println("Benchmarking: ", name)
print("Cutoff: ")
results = []
for N in cutoffs
    print(N, " ")
    T = 0.
    for i=1:Nrand
        op1, op2, result = setup(N)
        T += @belapsed f($op1, $op2, $result) samples=samples evals=evals
    end
    push!(results, Dict("N"=>N, "t"=>T/Nrand))
end
println()

benchmarkutils.save(name, results)