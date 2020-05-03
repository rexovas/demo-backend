from setuptools import setup, find_packages


with open('README.md') as f:
    readme = f.read()

with open('LICENSE') as f:
    license = f.read()

setup(
    name='demo-backend',
    version='1.0.0',
    description='Demo Backend API for serving table data',
    long_description=readme,
    author='David Lovas',
    author_email='dlovas@rexovas.com',
    url='https://github.com/rexovas/demo-backend',
    license=license,
    packages=find_packages()
)