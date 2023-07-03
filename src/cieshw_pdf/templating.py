#!/usr/bin/python3

import json
import logging
from jinja2 import Environment, FileSystemLoader
import sys
from collections import defaultdict
from pathlib import Path, WindowsPath

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


def _generate_pdf() -> int:
    if Path("out.tex").is_file():
        try:
            subprocess.run(["pdflatex", "out.tex"])
        except FileNotFoundError:
            logger.error("pdflatex not found. No pdf created.")
            return 1
    else:
        logger.error("Internal error. No tex file found.")
        return 1
    return 0


def _get_plot(plot: str, input: Path, is_plot : bool = True) -> str:
    if is_plot:
        plot = plot.split("/")[0]
        plot = plot.replace("\\_", "_")
        plot = plot.rsplit("\\", 1)[1]
        plot = plot.replace(".png", ".pgf")
        plot = input / plot
        return (str(plot))
    else:
        return plot.replace("\\_", "_")



def _jinja_magic(input: Path, data: dict) -> None:
    global template
    environment = Environment(trim_blocks=True, lstrip_blocks=True)
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
    repo_graph = repo.get("Repository graph")
    # validation tests
    validation = data.get("TEST RESULTS").get("Validation")

    # render template
    content = template.render(compiler=compiler, date=date, commits=commits, repo=repo, validation=validation, repo_graph=repo_graph, input=input)

    # write to file
    with open("out.tex", "wt") as out_file:
        out_file.write(content)
    return


def pdf(input: Path = Path("report")) -> int:
    MIN_PYTHON = (3, 7)  # 3.6 for format strings, 3.7 for pkg_resources
    if sys.version_info < MIN_PYTHON:
        logger.critical("Python %s.%s or later is required.\n" % MIN_PYTHON)
        return 1

    report_file = input / "report.json"

    with report_file.open("rt") as json_file:
        data = json_file.read()
        # data = json.load(json_file)

    # parsing backslashs and underscores
    # data = data.replace("\\\\", "\\\\textbackslash ")
    data = data.replace("_", "\\\\_")
    data = json.loads(data)
    # stop if critical errors is not empty
    if data.get("CRITICAL ERRORS"):
        logger.warning("Critical errors were found:")
        for key, value in data.get("CRITICAL ERRORS").items():
            print(f"{key}:{value}")

    logger.info(f"Keys: {data.keys()}")

    _jinja_magic(input, data)

    return _generate_pdf()
