using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

name = "coherentstate"

samples = 5
evals = 10
cutoffs = [10:1000:10010;]

function f(b)
    alpha = log(b.Nmax)
    coherentstate(b, alpha)
end

println("Benchmarking: ", name)
print("Cutoff: ")
checks = Dict{Int, Float64}()
results = []
for N in cutoffs
    print(N, " ")
    b = FockBasis(N-1)
    checks[N] = abs(expect(destroy(b), f(b)))
    t = @belapsed f($b) samples=samples evals=evals
    push!(results, Dict("N"=>N, "t"=>t))
end
println()

benchmarkutils.check(name, checks)
benchmarkutils.save(name, results)
