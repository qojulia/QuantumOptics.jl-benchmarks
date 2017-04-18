using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

srand(0)

name = "multiplication_sparse_sparse"

samples = 5
evals = 100
cutoffs = [50:50:1001;]

function setup(N)
    s = 0.01
    op1 = sprand(Complex128, N, N, s)
    op2 = sprand(Complex128, N, N, s)
    op1, op2
end

function f(op1, op2)
    op1*op2
end

println("Benchmarking: ", name)
print("Cutoff: ")
results = []
for N in cutoffs
    print(N, " ")
    op1, op2 = setup(N)
    t = @belapsed f($op1, $op2) samples=samples evals=evals
    push!(results, Dict("N"=>N, "t"=>t))
end
println()

benchmarkutils.save(name, results)