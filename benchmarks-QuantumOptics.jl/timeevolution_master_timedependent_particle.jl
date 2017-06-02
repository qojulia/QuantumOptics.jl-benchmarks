using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

name = "timeevolution_master_timedependent_particle"

samples = 3
evals = 1
cutoffs = [10:10:50;]

function setup(N)
    xmin = -5
    xmax = 5
    x0 = 0.3
    p0 = -0.2
    sigma0 = 1
    bx = PositionBasis(xmin, xmax, N)
    x = position(bx)
    p = momentum(bx)
    Hkin = p^2
    Vx = 2*x^2
    Ψ0 = gaussianstate(bx, x0, p0, sigma0)
    J = [x + 1im*p]
    Jdagger = [dagger(J[1])]
    Ψ0, Hkin, Vx, J, Jdagger, x
end

function f(Ψ0, Hkin, Vx, J, Jdagger, x)
    T = [0:1:10;]
    exp_x = Float64[]
    fout(t, rho) = push!(exp_x, real(expect(x, rho)))
    H(t, Hkin, Vx) = Hkin + (1 + cos(t))*Vx
    HJ(t, rho) = (H(t, Hkin, Vx), J, Jdagger)
    timeevolution.master_dynamic(T, Ψ0, HJ; fout=fout, reltol=1e-6, abstol=1e-8)
    exp_x
end

println("Benchmarking: ", name)
print("Cutoff: ")
checks = Dict{Int, Float64}()
results = []
for N in cutoffs
    print(N, " ")
    Ψ0, Hkin, Vx, J, Jdagger, x = setup(N)
    checks[N] = sum(f(Ψ0, Hkin, Vx, J, Jdagger, x))
    t = @belapsed f($Ψ0, $Hkin, $Vx, $J, $Jdagger, $x) samples=samples evals=evals
    push!(results, Dict("N"=>N, "t"=>t))
end
println()

benchmarkutils.check(name, checks)
benchmarkutils.save(name, results)
