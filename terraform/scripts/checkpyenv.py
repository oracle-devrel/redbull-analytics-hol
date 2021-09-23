# Copyright (c) 2021 Oracle and/or its affiliates.

import subprocess
import sys

# Libraries to install
libraries = [
'jupyterlab',
'pandas',
'pandarallel',
'dask',
'seaborn',
'matplotlib',
'plotly',
'lxml',
'selenium',
'beautifulsoup4',
'scikit-learn',
'Flask',
'gunicorn'
]

reqs = subprocess.check_output([sys.executable, '-m', 'pip', 'freeze'])
installed_packages = [r.decode().split('==')[0] for r in reqs.split()]

#print(installed_packages)
for l in libraries:
    if l not in installed_packages:
         print(f'Error Library not installed : {l}')

print('End checking python env')
