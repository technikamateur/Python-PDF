#!/usr/bin/python3

import json
from jinja2 import Environment, FileSystemLoader


with open("test.json", "rt") as json_file:
    data = json.load(json_file)

print(data.keys())
environment = Environment(loader=FileSystemLoader("templates/"))
template = environment.get_template("example.tex")
content = template.render(data["General Information"])

with open ("out.tex", "wt") as out_file:
    out_file.write(content)