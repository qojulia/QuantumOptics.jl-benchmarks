using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

name = "timeevolution_master"

samples = 2
evals = 2
cutoffs = [10:10:50;]

function f(Ncutoff)
    κ = 1.
    η = 4κ
    Δ = 0
    tmax = 100
    tsteps = 201
    T = Vector(linspace(0, tmax, tsteps))

    b = FockBasis(Ncutoff)
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
results = []
for N in cutoffs
    print(N, " ")
    t = @belapsed f($N) samples=samples evals=evals
    push!(results, Dict("N"=>N, "t"=>t))
end
println()

benchmarkutils.save(name, results)
