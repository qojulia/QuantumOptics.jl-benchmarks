import os
import json

names = [
    "multiplication",
    "coherentstate",
    "expect_operator",
    "expect_state",
    "variance_operator",
    "variance_state",
    "ptrace",
    "qfunc_operator",
    "qfunc_state",
    "timeevolution_master"
]

filenames = os.listdir("results")


def extract_version(filename, testname):
    name, _ = os.path.splitext(filename)
    assert name.startswith("results-"), name
    assert name.endswith("-" + testname), name
    return name[len("results-"):-len("-" + testname)]


for testname in names:
    print("Loading: ", testname)
    matches = filter(lambda x: testname in x, filenames)
    d = {}
    for filename in matches:
        version = extract_version(filename, testname)
        f = open("results/" + filename)
        version_escaped = version.replace(".", "_")
        d[version_escaped] = json.load(f)
        f.close()
    path = "results-collected/" + testname + ".json"
    f = open(path, "w")
    json.dump(d, f)
    f.close()
