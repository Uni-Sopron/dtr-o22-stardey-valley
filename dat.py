file = []

def add_single_param(name, value):
    file.append({"type": "param", "name": name, "value": value})

def add_set(name, list):
    file.append({"type": "set", "name": name, "value": list})

def add_bidimension_param(name, dict):
    file.append({"type": "bi_param", "name": name, "value": dict})

def generate():
    with open("model.dat",'w') as out:
        pass
    with open("model.dat", "a") as out:
        write_params(out)
        write_sets(out)
        write_bi_params(out)
        out.write("end;\n")


def write_params(out):
    filtered = filter(lambda item: item["type"] == "param", file)
    for row in filtered:
        out.write("param " + str(row["name"]) + " := " + str(row["value"]) + ";\n")

def write_sets(out):
    filtered = filter(lambda item: item["type"] == "set", file)
    for row in filtered:
        out.write("set " + str(row["name"]) + " :=")
        for item in row["value"]:
            out.write(" " + str(item))
        out.write(";\n")

def write_bi_params(out):
    filtered = filter(lambda item: item["type"] == "bi_param", file)
    for row in filtered:
        out.write("param " + str(row["name"]) + " := \n")
        for item in row["value"]:
            out.write(" " + str(item["name"]) + "       " + str(item["value"]) + "\n")
        out.write(";\n")
        
