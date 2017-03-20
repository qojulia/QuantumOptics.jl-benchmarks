using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")


name = "expect_operator"

samples = 5
evals = 100
cutoffs = [100:100:2500;]

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
    rho = psi ⊗ dagger(psi)
    t = @belapsed f($op, $rho) samples=samples evals=evals
    push!(results, Dict("N"=>N, "t"=>t))
end
println()

benchmarkutils.save(name, results)