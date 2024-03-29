# Python-PDF
This package can generate pdf reports from cieshw json files.
## How to use
### Installation
- It's recommended to install pip packages to a `venv`. How to set up a venv can be found in the [python docs](https://docs.python.org/3/library/venv.html).
- You need wheel installed. Can be done via `pip install wheel`
- Download `.whl` from [releases](https://github.com/technikamateur/Python-PDF/releases) and install via `pip install path_to_whl`

### Usage
Usage is pretty simple. Just do the following:
```python
from cieshw_pdf import templating

input_dir = Path()
output_dir = Path() # This is optional

ret = templating.pdf(input_dir, output_dir)
```
The functions expects a python [Path object](https://docs.python.org/3/library/pathlib.html) which points to a folder, which contains a `.json`. You can also specify an output dir, if you want to. Else the output is written to your cwd.

#### New since v1.2
`templating.pdf(Path)`returns an integer. The return value is 0 if no error occured.
