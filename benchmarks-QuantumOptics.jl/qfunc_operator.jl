using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

name = "qfunc_operator"

samples = 5
evals = 20
cutoffs = [10:10:200;]

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
    op = state ⊗ dagger(state)
    t = @belapsed f($op, $xvec, $yvec) samples=samples evals=evals
    push!(results, Dict("N"=>N, "t"=>t))
end
println()

benchmarkutils.save(name, results)
