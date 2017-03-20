module benchmarkutils

using QuantumOptics
using JSON

set_zero_subnormals(true)

# Detect the git commit hash
const rootpath = abspath(".")
const quantumoptics_directory = dirname(dirname(Base.functionloc(QuantumOptics.eval, Tuple{Void})[1]))
cd(quantumoptics_directory)
const commitID = readstring(`git rev-parse --verify HEAD`)[1:10]
cd(rootpath)
println("Detected QuantumOptics.jl version: ", commitID)

benchmark_directory = "benchmarks-QuantumOptics.jl"

function save(name, results)
    result_path = "../results/results-QuantumOptics.jl-$commitID-$name.json"
    f = open(result_path, "w")
    write(f, JSON.json(results))
    close(f)
end

end # module