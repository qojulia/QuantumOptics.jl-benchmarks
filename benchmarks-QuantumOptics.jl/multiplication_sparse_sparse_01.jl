using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

srand(0)

name = "multiplication_sparse_sparse_01"

samples = 2
evals = 5
cutoffs = [50:50:1000;]
Nrand = 5

function setup(N)
    s = 0.1
    op1 = sprand(Complex128, N, N, s)
    op2 = sprand(Complex128, N, N, s)
    op1, op2
end

function f(op1, op2)
    op1*op2
end

println("Benchmarking: ", name)
print("Cutoff: ")
results = []
for N in cutoffs
    print(N, " ")
    T = 0.
    for i=1:Nrand
        op1, op2 = setup(N)
        T += @belapsed f($op1, $op2) samples=samples evals=evals
    end
    push!(results, Dict("N"=>N, "t"=>T/Nrand))
end
println()

benchmarkutils.save(name, results)