using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")


name = "variance_operator"

samples = 5
evals = 50
cutoffs = [100:100:2001;]

alpha = 0.7

function f(op, state)
    variance(op, state)
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