import timeit
import importlib
import json
import qutip

benchmark_directory = "benchmarks-QuTiP"
commitID = qutip.version.version
result_path = "../results/results-QuTiP-{}-{}.json"


def run_benchmark(f, *args, samples=5, evals=1):
    t = timeit.repeat("f(*args)", globals={"f": f, "args": args}, number=evals, repeat=samples)
    return min(t)/evals

def save(name, results):
    f = open(result_path.format(commitID, name), "w")
    f.write(json.dumps(results))
    f.close()
