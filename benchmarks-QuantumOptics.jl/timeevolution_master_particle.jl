using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

name = "timeevolution_master_particle"

samples = 3
evals = 3
cutoffs = [5:5:60;]

function setup(N)
    xmin = -5
    xmax = 5
    x0 = 0.3
    p0 = -0.2
    sigma0 = 1
    bx = PositionBasis(xmin, xmax, N)
    x = position(bx)
    p = momentum(bx)
    H = p^2 + 2*x^2
    psi0 = gaussianstate(bx, x0, p0, sigma0)
    J = [x + 1im*p]
    psi0, H, x, J
end

function f(psi0, H, x, J)
    T = [0.0:1.0:10;]
    exp_x = Float64[]
    fout(t, rho) = push!(exp_x, real(expect(x, rho)))
    timeevolution.master(T, psi0, H, J; fout=fout, reltol=1e-6, abstol=1e-8)
    exp_x
end

println("Benchmarking: ", name)
print("Cutoff: ")
checks = Dict{Int, Float64}()
results = []
for N in cutoffs
    print(N, " ")
    psi0, H, x, J = setup(N)
    checks[N] = sum(f(psi0, H, x, J))
    t = @belapsed f($psi0, $H, $x, $J) samples=samples evals=evals
    push!(results, Dict("N"=>N, "t"=>t))
end
println()

benchmarkutils.check(name, checks)
benchmarkutils.save(name, results)
