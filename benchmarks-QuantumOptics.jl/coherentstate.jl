using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

name = "coherentstate"

samples = 5
evals = 10
cutoffs = [10:1000:10010;]

alpha = 0.7

function f(b, alpha)
    coherentstate(b, alpha)
end

println("Benchmarking: ", name)
print("Cutoff: ")
results = []
for N in cutoffs
    print(N, " ")
    b = FockBasis(N-1)
    t = @belapsed f($b, $alpha) samples=samples evals=evals
    push!(results, Dict("N"=>N, "t"=>t))
end
println()

benchmarkutils.save(name, results)
