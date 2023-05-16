#!/usr/bin/python3

import json
from jinja2 import Environment, FileSystemLoader
import sys
import argparse

default_input = "report.json"


def main():
    MIN_PYTHON = (3, 6)  # This is for format strings
    if sys.version_info < MIN_PYTHON:
        sys.exit("Python %s.%s or later is required.\n" % MIN_PYTHON)

    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--input', required=False, help='Select input file.')
    args = parser.parse_args()

    if args.input:
        in_file = args.input
    else:
        in_file = default_input
    try:
        with open(in_file, "rt") as json_file:
            data = json_file.read()
            #data = json.load(json_file)
    except FileNotFoundError:
        sys.exit(f"{in_file} not found. Hint: You can specify a file manually with \'-i filename\'.")
    
    data = data.replace("\\", "\\\\textbackslash ")
    data = data.replace("_", "\\\\_")
    data = json.loads(data)

    print(f"Keys: {data.keys()}")
    environment = Environment(loader=FileSystemLoader("templates/"))
    template = environment.get_template("example.tex")

    compiler = data["COMPILER INFORMATION"]
    #lol.update(data["Commits"][0])
    print(f"Data to jinja: {compiler}")
    content = template.render(compiler=compiler)

    with open("out.tex", "wt") as out_file:
        out_file.write(content)


if __name__ == "__main__":
    main()
