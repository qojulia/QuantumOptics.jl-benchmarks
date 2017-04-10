using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

name = "timeevolution_timedependent"

samples = 3
evals = 1
cutoffs = [10:100:10;]

# System parameters
const ω = 1.89 # Frequency of driving laser
const ωc = 2.13 # Cavity frequency
const η = 0.76 # Pump strength
const κ = 0.34 # Decay rate
const δc = ωc - ω # Detuning


H(t, n, a, at) = ωc*n + η*(a*exp(1im*ω*t) + at*exp(-1im*ω*t))

function f(Ncutoff)
    b = FockBasis(Ncutoff)

    a = destroy(b)
    at = create(b)
    n = number(b)

    Γ = Matrix{Float64}(1,1)
    Γ[1,1] = κ
    J = [a]
    Jdagger = [at]

    # Initial state
    α0 = 0.3 - 0.5im
    psi0 = coherentstate(b, α0)

    T = [0:1.:10;]
    αt = Float64[]
    fout(t, rho) = push!(αt, real(expect(a, rho)))
    HJ(t::Float64, rho::DenseOperator) = (H(t, n, a, at), J, Jdagger)
    timeevolution.master_dynamic(T, psi0, HJ; Gamma=Γ, fout=fout, reltol=1e-6, abstol=1e-8)
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
