using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

name = "timeevolution_master"

samples = 3
evals = 5
cutoffs = [5:5:60;]

function f(Ncutoff)
    κ = 1.
    η = 4κ
    Δ = 0
    tmax = 100
    tsteps = 201
    T = Vector(linspace(0, tmax, tsteps))

    b = FockBasis(Ncutoff-1)
    a = destroy(b)
    ad = dagger(a)
    n = number(b)
    H = Δ*ad*a + η*(a + ad)
    J = [destroy(b)]
    Γ = [2κ]

    Ψ₀ = fockstate(b, 0)
    ρ₀ = Ψ₀ ⊗ dagger(Ψ₀)
    exp_n = Float64[]
    fout(t, ρ) = push!(exp_n, real(expect(n, ρ)))
    timeevolution.master(T, ρ₀, H, J; Gamma=Γ, fout=fout, reltol=1e-6, abstol=1e-8)
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
