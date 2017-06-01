import os
import json

names = [
    "multiplication_sparse_sparse_01",
    "multiplication_sparse_sparse_001",
    "multiplication_sparse_sparse_0001",
    "multiplication_sparse_dense_01",
    "multiplication_sparse_dense_001",
    "multiplication_sparse_dense_0001",
    "multiplication_dense_sparse_01",
    "multiplication_dense_sparse_001",
    "multiplication_dense_sparse_0001",
    "multiplication_dense_dense",
    "coherentstate",
    "displace",
    "expect_operator",
    "expect_state",
    "variance_operator",
    "variance_state",
    "ptrace",
    "qfunc_operator",
    "qfunc_state",
    "wigner_operator",
    "wigner_state",
    "timeevolution_master",
    "timeevolution_jaynescummings",
    "timeevolution_particle",
    "timeevolution_decelerating_particle",
    "timeevolution_timedependent"
]

filenames = os.listdir("results")

def extract_version(filename, testname):
    name, _ = os.path.splitext(filename)
    if name.endswith("]"): # For example timeevolution_particle[fft]
        name, variant = name.rsplit("[", 1)
        variant = "/" + variant[:-1]
    else:
        variant = ""
    assert name.startswith("results-"), name
    assert name.endswith("-" + testname), name
    return name[len("results-"):-len("-" + testname)] + variant

def cutdigits(x):
    return float('%.3g' % (x))

for testname in names:
    print("Loading: ", testname)
    matches = filter(lambda x: testname in x, filenames)
    d = {}
    for filename in matches:
        version = extract_version(filename, testname)
        f = open("results/" + filename)
        # version_escaped = version.replace(".", "_")
        data = json.load(f)
        for point in data:
            point["t"] = cutdigits(point["t"])
        d[version] = data
        f.close()
    path = "results-collected/" + testname + ".json"
    f = open(path, "w")
    json.dump(d, f)
    f.close()
