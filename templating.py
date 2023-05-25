#!/usr/bin/python3

import json
from jinja2 import Environment, FileSystemLoader
import sys
import argparse
from collections import defaultdict
from pathlib import Path

import subprocess


def _merge_dicts(d1: dict, d2: dict, d3: dict) -> dict:
    dd = defaultdict(list)
    for d in (d1, d2, d3):  # you can list as many input dicts as you want here
        for key, value in d.items():
            dd[key].append(value)
    return dd


def _generate_pdf() -> None:
    subprocess.run(["pdflatex", "out.tex"])
    return


def main():
    MIN_PYTHON = (3, 6)  # This is for format strings
    if sys.version_info < MIN_PYTHON:
        sys.exit("Python %s.%s or later is required.\n" % MIN_PYTHON)

    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--input', required=False, help='Select input file.')
    parser.add_argument('--pdf', action='store_true', help='Generate pdf after parsing.')
    args = parser.parse_args()
    default_input = "report.json"

    if args.input:
        in_file = args.input
    else:
        in_file = default_input
    try:
        with open(in_file, "rt") as json_file:
            data = json_file.read()
            # data = json.load(json_file)
    except FileNotFoundError:
        sys.exit(f"{in_file} not found. Hint: You can specify a file manually with \'-i filename\'.")

    # parsing backslashs and underscores
    data = data.replace("\\", "\\\\textbackslash ")
    data = data.replace("_", "\\\\_")
    data = json.loads(data)
    # stop if critical errors is not empty
    if data.get("CRITICAL ERRORS"):
        sys.exit(f"There were some critical errors. Therefore I\'m not able to generate the report.")

    print(f"Keys: {data.keys()}")
    environment = Environment(loader=FileSystemLoader("templates/"))
    template = environment.get_template("example.tex")
    environment.globals.update(zip=zip)

    # compiler infos
    compiler = data.get("COMPILER INFORMATION")

    # repo infos
    date = data.get("REPORT INITIALIZATION DATE")
    repo = data.get("REPOSITORY INFORMATION")
    commitsmsg = repo.get("Commits").get("commit messages")
    commitsdate = repo.get("Commits").get("commit dates")
    commitsbranches = repo.get("Commits").get("commit branches")
    commits = _merge_dicts(commitsmsg, commitsdate, commitsbranches)

    # validation tests
    validation = data.get("TEST RESULTS").get("Validation")

    # render template
    content = template.render(compiler=compiler, date=date, commits=commits, repo=repo, validation=validation)

    with open("out.tex", "wt") as out_file:
        out_file.write(content)

    if args.pdf and Path("out.tex").is_file():
        print("Generating your pdf as requested.")
        _generate_pdf()


if __name__ == "__main__":
    main()
