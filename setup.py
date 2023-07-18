from setuptools import setup,find_packages

setup(
    name='cieshw_pdf',
    version='1.3',
    description='This package can generate pdf reports from cieshw json files.',
    author='Daniel Körsten',
    python_requires='>=3.7',
    install_requires=[
        'Jinja2>=3.1.2',
    ],
    # adding packages
    packages=find_packages('src'),
    package_dir ={'':'src'},
    package_data={'': ['static/*'],},
)