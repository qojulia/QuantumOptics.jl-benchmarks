using BenchmarkTools
using JSON
using QuantumOptics

# Detect the git commit hash
rootpath = abspath(".")
quantumoptics_directory = dirname(dirname(Base.functionloc(QuantumOptics.eval, Tuple{Void})[1]))
cd(quantumoptics_directory)
commitID = readstring(`git rev-parse --verify HEAD`)[1:10]
cd(rootpath)
println("Detected QuantumOptics.jl version: ", commitID)

benchmark_directory = "benchmarks-QuantumOptics.jl"
result_path = "results-QuantumOptics.jl/results-QuantumOptics.jl-$commitID.json"

const suites = BenchmarkGroup()

names = [
    "timeevolution_master.jl"
]

# Load all benchmark suits
println("Gathering benchmarks:")
for name=names
    println("    $name")
    include(joinpath(benchmark_directory, name))
    suites[name[1:end-3]] = suite
end

# If a cache of tuned parameters already exists, use it, otherwise, tune and cache
# the benchmark parameters. Reusing cached parameters is faster and more reliable
# than re-tuning `suite` every time the file is included.
paramspath = joinpath(benchmark_directory, "params.jld")

if isfile(paramspath)
    println("Tuning parameters found - loading ...")
    loadparams!(suites, BenchmarkTools.load(paramspath, "suites"), :evals, :samples);
else
    println("Tune parameters ...")
    tune!(suites)
    BenchmarkTools.save(paramspath, "suites", params(suites));
end

println("Running benchmarks ...")
results = run(suites, verbose=true)
D = Dict()
for (name, bench) in time(minimum(results))
    data = sort(collect(bench), by=x->x[1])
    D[name] = [Dict("N"=>x[1], "t"=>x[2]/1e9) for x in data]
end

println("Storing results in $result_path")
outputfile = open(result_path, "w")
write(outputfile, JSON.json(D))
close(outputfile)