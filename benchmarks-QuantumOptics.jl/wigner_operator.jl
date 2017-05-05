using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

name = "wigner_operator"

samples = 3
evals = 5
cutoffs = [10:10:100;]

function setup(N)
    alpha = 0.7
    xvec = collect(linspace(-50, 50, 10))
    yvec = collect(linspace(-50, 50, 10))
    b = FockBasis(N-1)
    state = coherentstate(b, alpha)
    op = state ⊗ dagger(state)
    op, xvec, yvec
end

function f(state, xvec, yvec)
    wigner(state, xvec, yvec)
end

println("Benchmarking: ", name)
print("Cutoff: ")
checks = Dict{Int, Float64}()
results = []
for N in cutoffs
    print(N, " ")
    op, xvec, yvec = setup(N)
    alpha_check = 0.6 + 0.1im
    checks[N] = real(f(op, [real(alpha_check)], [imag(alpha_check)])[1, 1])
    t = @belapsed f($op, $xvec, $yvec) samples=samples evals=evals
    push!(results, Dict("N"=>N, "t"=>t))
end
println()

benchmarkutils.check(name, checks)
benchmarkutils.save(name, results)
