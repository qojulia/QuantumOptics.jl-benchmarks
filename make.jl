website = "../QuantumOptics.jl-website"
@assert isdir(website)

run(`python collect_results.py`)
run(`python extract_code.py`)

sourcecode_in = "sourcecode"
sourcecode_out = joinpath(website, "_benchmark-sourcecode/")
data_in = "results-collected"
data_out = joinpath(website, "benchmark-data/")

cp(sourcecode_in, sourcecode_out; remove_destination=true)
cp(data_in, data_out; remove_destination=true)
