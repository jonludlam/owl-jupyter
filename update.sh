#!/bin/bash

# Update the git repos

cd /home/opam/libs

eval `opam config env`

cd owl_lbfgs; git pull origin master; cd ..
cd gp; git pull origin master; cd ..
cd juplot; git pull origin master; cd ..
cd pkp-tutorials; git pull origin master; cd ..

dune build && dune install

cd /home/opam/pkp
chmod -R 755 pkp-tutorials
rm -rf pkp-tutorials
git clone ../libs/pkp-tutorials
rm -rf pkp-tutorials/.git
chmod -R ugoa-w pkp-tutorials

