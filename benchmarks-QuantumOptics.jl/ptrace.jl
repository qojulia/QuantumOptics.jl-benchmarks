using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

name = "ptrace"

samples = 5
evals = 200
cutoffs = [2:30;]

function create_suboperator(c0, alpha, N)
    b = GenericBasis(N)
    data = transpose(reshape(c0 + alpha*complex(linspace(0., 1., N^2)), N, N))
    DenseOperator(b, data)
end

function create_operator(Ncutoff)
    op1 = create_suboperator(1, 0.2, Ncutoff)
    op2 = create_suboperator(2, 0.3, Ncutoff)
    op3 = create_suboperator(3, 0.4, 2)
    op4 = create_suboperator(4, 0.5, 2)
    tensor(op1, op2, op3, op4)
end

function f(op)
    ptrace(op, [2,3])
end

println("Benchmarking: ", name)
print("Cutoff: ")
checks = Dict{Int, Float64}()
results = []
for N in cutoffs
    print(N, " ")
    op = create_operator(N)
    checks[N] = sum(abs(f(op).data))
    t = @belapsed f($op) samples=samples evals=evals
    push!(results, Dict("N"=>4*N^2, "t"=>t))
end
println()

benchmarkutils.check(name, checks)
benchmarkutils.save(name, results)
