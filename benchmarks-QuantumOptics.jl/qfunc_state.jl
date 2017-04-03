using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

name = "qfunc_state"

samples = 3
evals = 5
cutoffs = [10:10:100;]

alpha = 0.7
alpha_check = 0.6 + 0.1im
xvec = collect(linspace(-50, 50, 100))
yvec = collect(linspace(-50, 50, 100))

function f(state, xvec, yvec)
    qfunc(state, xvec, yvec)
end

println("Benchmarking: ", name)
print("Cutoff: ")
checks = Dict{Int, Float64}()
results = []
for N in cutoffs
    print(N, " ")
    b = FockBasis(N-1)
    state = coherentstate(b, alpha)
    checks[N] = f(state, [real(alpha_check)], [imag(alpha_check)])[1, 1]
    t = @belapsed f($state, $xvec, $yvec) samples=samples evals=evals
    push!(results, Dict("N"=>N, "t"=>t))
end
println()

benchmarkutils.check(name, checks)
benchmarkutils.save(name, results)
