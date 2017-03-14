using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

name = "qfunc_state"

samples = 5
evals = 20
cutoffs = [10:10:100;]

alpha = 0.7
xvec = collect(linspace(-50, 50, 100))
yvec = collect(linspace(-50, 50, 100))

function f(state, xvec, yvec)
    qfunc(state, xvec, yvec)
end

println("Benchmarking: ", name)
print("Cutoff: ")
results = []
for N in cutoffs
    print(N, " ")
    b = FockBasis(N-1)
    state = coherentstate(b, alpha)
    t = @belapsed f($state, $xvec, $yvec) samples=samples evals=evals
    push!(results, Dict("N"=>N, "t"=>t))
end
println()

benchmarkutils.save(name, results)
