#!/usr/bin/python3

import json
from jinja2 import Environment, FileSystemLoader
import sys
from collections import defaultdict
from pathlib import Path

import subprocess


def _merge_dicts(*args: dict) -> dict:
    dd = defaultdict(list)
    for d in (args):  # you can list as many input dicts as you want here
        for key, value in d.items():
            dd[key].append(value)
    return dd


def _generate_pdf() -> None:
    subprocess.run(["pdflatex", "out.tex"])
    return

def _get_plot(plot: str, input: Path) -> Path:
    plot = plot.split("/")[0]
    plot = plot.rsplit("\\textbackslash ", 1)[1]
    plot = plot.replace("\\_", "_")
    plot = plot.replace(".png", ".pgf")
    return input / plot

def _jinja_magic(input: Path, data: dict) -> None:
    environment = Environment(loader=FileSystemLoader("templates/"))
    template = environment.get_template("example.tex")
    environment.globals.update(zip=zip)
    environment.globals.update(format_path=_get_plot)

    # compiler infos
    compiler = data.get("COMPILER INFORMATION")

    # repo infos
    date = data.get("REPORT INITIALIZATION DATE")
    repo = data.get("REPOSITORY INFORMATION")
    ## commit table
    commitsmsg = repo.get("Commits").get("commit messages")
    commitsdate = repo.get("Commits").get("commit dates")
    commitsbranches = repo.get("Commits").get("commit branches")
    commits = _merge_dicts(commitsmsg, commitsdate, commitsbranches)
    repo_graph = _get_plot(data.get("REPOSITORY INFORMATION").get("Repository graph"), input)
    # validation tests
    validation = data.get("TEST RESULTS").get("Validation")

    # render template
    content = template.render(compiler=compiler, date=date, commits=commits, repo=repo, validation=validation, repo_graph=repo_graph, input=input)

    # write to file
    with open("out.tex", "wt") as out_file:
        out_file.write(content)
    return


def pdf(input: Path = Path("report")):
    MIN_PYTHON = (3, 6)  # This is for format strings
    if sys.version_info < MIN_PYTHON:
        sys.exit("Python %s.%s or later is required.\n" % MIN_PYTHON)

    report_file = input / "report.json"

    try:
        print(f"{input.parent.resolve()}")
        with report_file.open("rt") as json_file:
            data = json_file.read()
            # data = json.load(json_file)
    except FileNotFoundError:
        sys.exit(f"{input} not found.")

    # parsing backslashs and underscores
    data = data.replace("\\\\", "\\\\textbackslash ")
    data = data.replace("_", "\\\\_")
    data = json.loads(data)
    # stop if critical errors is not empty
    if data.get("CRITICAL ERRORS"):
        sys.exit(f"There were some critical errors. Therefore I\'m not able to generate the report.")

    # TODO: logging
    print(f"Keys: {data.keys()}")

    _jinja_magic(input, data)

    if Path("out.tex").is_file():
        print("Generating your pdf as requested.")
        _generate_pdf()


if __name__ == "__main__":
    pdf()
