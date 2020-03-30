using QuantumOptics
using BenchmarkTools
using SparseArrays
include("benchmarkutils.jl")

using Random; Random.seed!(0)

basename = "multiplication_bra_sparse"

samples = 2
evals = 5
cutoffs = [100:100:1000;]
S = [0.1, 0.01, 0.001]
Nrand = 5

function setup(N, s)
    b = GenericBasis(N)
    op1 = SparseOperator(b, sprand(ComplexF64, N, N, s))
    psi = dagger(randstate(b))
    result = copy(psi)
    op1, psi, result
end

function f(op1, psi, result)
    QuantumOpticsBase.gemv!(ComplexF64(1., 0.), psi, op1, ComplexF64(0., 0.), result)
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
            op1, psi, result = setup(N, s)
            T += @belapsed f($op1, $psi, $result) samples=samples evals=evals
        end
        push!(results, Dict("N"=>N, "t"=>T/Nrand))
    end
    println()
    benchmarkutils.save(name, results)
end
