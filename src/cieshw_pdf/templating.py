#!/usr/bin/python3

import json
import logging
from jinja2 import Environment, FileSystemLoader
import sys
from collections import defaultdict
from pathlib import Path

import subprocess

import importlib.resources as pkg_resources
from . import static

FORMAT = '%(name)s: %(levelname)s: %(message)s'
logger = logging.getLogger(__name__)
logging.basicConfig(format=FORMAT, level=logging.DEBUG)

try:
    inp_file = (pkg_resources.files(static) / 'example.tex')
    with inp_file.open("rt") as f:  # or "rt" as text file with universal newlines
        template = f.read()
except AttributeError:
    # Python < PY3.9, fall back to method deprecated in PY3.11.
    template = pkg_resources.read_text(static, 'example.tex')
    logger.warning("Your are using Python <3.9. Using fallback.")


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
    global template
    environment = Environment()
    template = environment.from_string(template)
    environment.globals.update(zip=zip)
    environment.globals.update(format_path=_get_plot)

    # compiler infos
    compiler = data.get("COMPILER INFORMATION")

    # repo infos
    date = data.get("REPORT INITIALIZATION DATE")
    repo = data.get("REPOSITORY INFORMATION")
    # commit table
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
    MIN_PYTHON = (3, 7)  # 3.6 for format strings, 3.7 pkg_resources
    if sys.version_info < MIN_PYTHON:
        logger.critical("Python %s.%s or later is required.\n" % MIN_PYTHON)
        return

    report_file = input / "report.json"

    try:
        print(f"{input.parent.resolve()}")
        with report_file.open("rt") as json_file:
            data = json_file.read()
            # data = json.load(json_file)
    except FileNotFoundError:
        logger.critical(f"{input} not found.")
        return

    # parsing backslashs and underscores
    data = data.replace("\\\\", "\\\\textbackslash ")
    data = data.replace("_", "\\\\_")
    data = json.loads(data)
    # stop if critical errors is not empty
    if data.get("CRITICAL ERRORS"):
        logger.warning("Critical errors were found:")
        for key, value in data.get("CRITICAL ERRORS").items():
            print(f"{key}:{value}")

    logger.info(f"Keys: {data.keys()}")

    _jinja_magic(input, data)

    if Path("out.tex").is_file():
        logger.info("Generating your pdf as requested.")
        _generate_pdf()


if __name__ == "__main__":
    pdf()
