using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

srand(0)

name = "addition_dense_dense"

samples = 3
evals = 10
cutoffs = [50:50:800;]

function setup(N)
    b = GenericBasis(N)
    op1 = randoperator(b)
    op2 = randoperator(b)
    result = DenseOperator(b)
    op1, op2, result
end

function f(op1, op2, result)
    op1 + op2
end

println("Benchmarking: ", name)
print("Cutoff: ")
results = []
for N in cutoffs
    print(N, " ")
    op1, op2, result = setup(N)
    t = @belapsed f($op1, $op2, $result) samples=samples evals=evals
    push!(results, Dict("N"=>N, "t"=>t))
end
println()

benchmarkutils.save(name, results)
