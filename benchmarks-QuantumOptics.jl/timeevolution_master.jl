using QuantumOptics
using BenchmarkTools

suite = BenchmarkGroup()

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

for Ncutoff in [2, 3, 5, 7, 10, 15, 20, 30, 50]
    suite[Ncutoff] = @benchmarkable f($Ncutoff) samples=5 seconds=100
end