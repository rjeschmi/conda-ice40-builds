#!/usr/bin/env python

import yaml
import json
import sys
import os
import subprocess

package = os.getenv("PACKAGE")

args=list(sys.argv[1:])


with open(args.pop(0)) as f:
    try:
        conda_render = yaml.safe_load(f)
        #print("Loaded render: %s" % conda_render)
    except yaml.YAMLError as exc:
        print(exc)

render_version = conda_render['package']['version']

#print("searching for package %s " % package)
raw_json = subprocess.check_output('conda search --json %s ' % package, shell=True)

#print("DEBUG: %s " % raw_json)

conda_search = json.loads(raw_json)

versions = conda_search[package]

for version in versions:
    if(version['version'] == render_version):
        print('export SKIP_BUILD="1"')

