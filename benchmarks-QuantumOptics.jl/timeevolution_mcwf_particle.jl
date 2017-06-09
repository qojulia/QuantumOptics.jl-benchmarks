using QuantumOptics
using BenchmarkTools
include("benchmarkutils.jl")

name = "timeevolution_mcwf_particle"

samples = 2
evals = 100
cutoffs = [20:20:100;]
Ncheck = 200

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
    T = [0:1:10;]
    exp_x = Float64[]
    fout(t, ψ) = push!(exp_x, real(expect(x, ψ)/norm(ψ)^2))
    timeevolution.mcwf(T, psi0, H, J; fout=fout, reltol=1e-6, abstol=1e-8)
    exp_x
end

println("Benchmarking: ", name)
print("Cutoff: ")
checks = Dict{Int, Float64}()
results = []
for N in cutoffs
    print(N, " ")
    psi0, H, x, J = setup(N)
    C = 0.
    for i=1:Ncheck
        C += sum(f(psi0, H, x, J))
    end
    checks[N] = C/Ncheck
    t = @belapsed f($psi0, $H, $x, $J) samples=samples evals=evals
    push!(results, Dict("N"=>N, "t"=>t))
end
println()

benchmarkutils.check(name, checks, 0.05)
benchmarkutils.save(name, results)
