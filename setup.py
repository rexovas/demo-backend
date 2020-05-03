from setuptools import setup, find_packages
from pathlib import Path
import re

install_requires = open('requirements.txt').read().splitlines()

VERSION_FILE = Path('src/version.py')
with open(VERSION_FILE, 'r', encoding='utf-8') as version_file:
        version = re.search(r'^\s+__version__\s*=\s*[\'"]([^\'"]*)[\'"]', version_file.read(), re.MULTILINE).group(1)

with open('README.md') as f:
    readme = f.read()

with open('LICENSE') as f:
    license = f.read()

setup(
    name='demo-backend',
    version=version,
    description='Demo Backend API for serving table data',
    long_description=readme,
    author='David Lovas',
    author_email='dlovas@rexovas.com',
    url='https://github.com/rexovas/demo-backend',
    license=license,
    packages=find_packages(),
    install_requires=install_requires,
    scripts=['scripts/start.sh']
)