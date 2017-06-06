using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

name = "timeevolution_master_timedependent_cavity"

samples = 3
evals = 1
cutoffs = [10:10:100;]

function setup(N)
    nothing
end

function f(N)
    κ = 1.
    η = 1.5
    ωc = 1.8
    ωl = 2.
    Δc = ωl - ωc
    α0 = 0.3 - 0.5im
    tspan = [0:1.:10;]

    b = FockBasis(N-1)
    a = destroy(b)
    at = create(b)
    n = number(b)

    H = Δc*at*a + η*(a + at)
    J = [a]
    Jdagger = [at]
    rates = [κ]

    Ψ0 = coherentstate(b, α0)

    αt = Float64[]
    fout(t, rho) = push!(αt, real(expect(a, rho)))
    H(t, n, a, at) = ωc*n + η*(a*exp(1im*ωl*t) + at*exp(-1im*ωl*t))
    HJ(t::Float64, rho::DenseOperator) = (H(t, n, a, at), J, Jdagger)
    timeevolution.master_dynamic(tspan, Ψ0, HJ; rates=rates, fout=fout, reltol=1e-6, abstol=1e-8)
    αt
end

println("Benchmarking: ", name)
print("Cutoff: ")

checks = Dict{Int, Float64}()
results = []
for N in cutoffs
    print(N, " ")
    checks[N] = sum(f(N))
    t = @belapsed f($N) samples=samples evals=evals
    push!(results, Dict("N"=>N, "t"=>t))
end
println()

benchmarkutils.check(name, checks)
benchmarkutils.save(name, results)
