using QuantumOptics
using BenchmarkTools
using SparseArrays
include("benchmarkutils.jl")

using Random; Random.seed!(0)

basename = "addition_sparse_dense"

samples = 2
evals = 5
cutoffs = [50:50:800;]
S = [0.1, 0.01, 0.001]
Nrand = 5

function setup(N, s)
    b = GenericBasis(N)
    op1 = SparseOperator(b, sprand(ComplexF64, N, N, s))
    op2 = randoperator(b)
    result = DenseOperator(b)
    op1, op2, result
end

function f(op1, op2, result)
    op1 + op2
end

for s in S
    name = basename * "_" * replace(string(s), "." => "")
    println("Benchmarking: ", name)
    print("Cutoff: ")
    results = []
    for N in cutoffs
        print(N, " ")
        T = 0.
        for i=1:Nrand
            op1, op2, result = setup(N, s)
            T += @belapsed f($op1, $op2, $result) samples=samples evals=evals
        end
        push!(results, Dict("N"=>N, "t"=>T/Nrand))
    end
    println()
    benchmarkutils.save(name, results)
end
