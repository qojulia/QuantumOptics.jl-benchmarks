using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

name = "expect_operator"

samples = 5
evals = 100
cutoffs = [100:100:2500;]

function f(op, state)
    expect(op, state)
end

println("Benchmarking: ", name)
print("Cutoff: ")
checks = Dict{Int, Float64}()
results = []
for N in cutoffs
    print(N, " ")
    b = FockBasis(N-1)
    op = (destroy(b) + create(b))
    psi = Ket(b, ones(Complex128, N)/sqrt(N))
    rho = psi ⊗ dagger(psi)
    checks[N] = abs(f(op, rho))
    t = @belapsed f($op, $rho) samples=samples evals=evals
    push!(results, Dict("N"=>N, "t"=>t))
end
println()

benchmarkutils.check(name, checks)
benchmarkutils.save(name, results)
