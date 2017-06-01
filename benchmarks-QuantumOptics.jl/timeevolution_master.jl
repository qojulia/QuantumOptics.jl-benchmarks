using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

name = "timeevolution_master"

samples = 3
evals = 1
cutoffs = [5:5:55;]

function setup(N)
    nothing
end

function f(N)
    κ = 1.
    η = 4κ
    Δ = 0
    tspan = [0:0.5:100;]

    b = FockBasis(N-1)
    a = destroy(b)
    ad = dagger(a)
    n = number(b)
    H = Δ*ad*a + η*(a + ad)
    J = [a]
    rates = [2κ]

    Ψ₀ = fockstate(b, 0)
    ρ₀ = Ψ₀ ⊗ dagger(Ψ₀)
    exp_n = Float64[]
    fout(t, ρ) = push!(exp_n, real(expect(n, ρ)))
    timeevolution.master(tspan, ρ₀, H, J; Gamma=rates, fout=fout, reltol=1e-6, abstol=1e-8)
    exp_n
end

println("Benchmarking: ", name)
print("Cutoff: ")
checks = Dict{Int, Float64}()
results = []
for N in cutoffs
    print(N, " ")
    checks[N] = abs(sum(f(N)))
    t = @belapsed f($N) samples=samples evals=evals
    push!(results, Dict("N"=>N, "t"=>t))
end
println()

benchmarkutils.check(name, checks)
benchmarkutils.save(name, results)
