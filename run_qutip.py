import timeit
import importlib
import json
import qutip

benchmark_directory = "benchmarks-QuTiP"
result_path = "results-QuTiP/results-QuTiP-{}.json".format(qutip.version.version)

def run_benchmark(name):
    m = importlib.import_module(benchmark_directory + "." + name)
    results = []
    print("Cutoff: ", end="", flush=True)
    for N in m.cutoffs:
        print(N, " ", end="", flush=True)
        trial = []
        for i in range(5):
            trial.append(timeit.timeit("m.f({})".format(N),
                globals={"m": m},
                number=1))
        results.append({"N": N, "t": min(trial)})
    print("")
    return results

names = [
    "timeevolution_master"
]

results = {}

for name in names:
    print("="*60)
    print("Running ", name)
    results[name] = run_benchmark(name)

print("Writing results to json")
f = open(result_path, "w")
f.write(json.dumps(results))
f.close()
