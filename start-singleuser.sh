#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

set -e

# set default ip to 0.0.0.0
if [[ "$NOTEBOOK_ARGS $@" != *"--ip="* ]]; then
  NOTEBOOK_ARGS="--ip=0.0.0.0 $NOTEBOOK_ARGS"
fi

# handle some deprecated environment variables
# from DockerSpawner < 0.8.
# These won't be passed from DockerSpawner 0.9,
# so avoid specifying --arg=empty-string
if [ ! -z "$NOTEBOOK_DIR" ]; then
  NOTEBOOK_ARGS="--notebook-dir='$NOTEBOOK_DIR' $NOTEBOOK_ARGS"
fi
if [ ! -z "$JPY_PORT" ]; then
  NOTEBOOK_ARGS="--port=$JPY_PORT $NOTEBOOK_ARGS"
fi
if [ ! -z "$JPY_USER" ]; then
  NOTEBOOK_ARGS="--user=$JPY_USER $NOTEBOOK_ARGS"
fi
if [ ! -z "$JPY_COOKIE_NAME" ]; then
  NOTEBOOK_ARGS="--cookie-name=$JPY_COOKIE_NAME $NOTEBOOK_ARGS"
fi
if [ ! -z "$JPY_BASE_URL" ]; then
  NOTEBOOK_ARGS="--base-url=$JPY_BASE_URL $NOTEBOOK_ARGS"
fi
if [ ! -z "$JPY_HUB_PREFIX" ]; then
  NOTEBOOK_ARGS="--hub-prefix=$JPY_HUB_PREFIX $NOTEBOOK_ARGS"
fi
if [ ! -z "$JPY_HUB_API_URL" ]; then
  NOTEBOOK_ARGS="--hub-api-url=$JPY_HUB_API_URL $NOTEBOOK_ARGS"
fi

echo NOTEBOOK_ARGS: $NOTEBOOK_ARGS
echo $@
env


#cd /home/opam/work && rm -rf 2019-20 && git clone https://github.com/ocamllabs/focs-201920-notebooks.git 2019-20
cd /home/opam/work && rm -rf pkp && mkdir pkp
cd /home/opam/work/pkp
git clone https://github.com/owlbarn/owl_ode.git
git clone https://github.com/tachukao/owl_lbfgs.git
git clone https://github.com/hennequin-lab/gp.git
git clone https://github.com/hennequin-lab/juplot.git
git clone https://github.com/ghennequin/pkp-tutorials.git
dune build && dune install

/home/opam/.local/bin/jupyterhub-singleuser $NOTEBOOK_ARGS "$@"
