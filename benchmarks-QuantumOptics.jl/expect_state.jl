using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")


name = "expect_state"

samples = 5
evals = 1000
cutoffs = [5000:5000:100001;]

alpha = 0.7

function f(op, state)
    expect(op, state)
end

println("Benchmarking: ", name)
print("Cutoff: ")
results = []
for N in cutoffs
    print(N, " ")
    b = FockBasis(N-1)
    op = (destroy(b) + create(b))
    psi = Ket(b, ones(Complex128, N)/sqrt(N))
    t = @belapsed f($op, $psi) samples=samples evals=evals
    push!(results, Dict("N"=>N, "t"=>t))
end
println()

benchmarkutils.save(name, results)