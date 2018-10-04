using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

name = "variance_operator"

samples = 5
evals = 50
cutoffs = [100:100:2000;]

function setup(N)
    b = FockBasis(N-1)
    op = (destroy(b) + create(b))
    psi = Ket(b, ones(ComplexF64, N)/sqrt(N))
    rho = psi ⊗ dagger(psi)
    op, rho
end

function f(op, rho)
    variance(op, rho)
end

println("Benchmarking: ", name)
print("Cutoff: ")
checks = Dict{Int, Float64}()
results = []
for N in cutoffs
    print(N, " ")
    op, rho = setup(N)
    checks[N] = abs(f(op, rho))
    t = @belapsed f($op, $rho) samples=samples evals=evals
    push!(results, Dict("N"=>N, "t"=>t))
end
println()

benchmarkutils.check(name, checks)
benchmarkutils.save(name, results)
