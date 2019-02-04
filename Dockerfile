FROM ryanrhymes/owl
ARG JUPYTERHUB_VERSION=0.9.4
RUN sudo apt-get update
RUN sudo apt-get install -y python3-pip
RUN pip3 install --no-cache jupyterhub==$JUPYTERHUB_VERSION notebook
RUN sudo apt-get -y install debianutils libgmp-dev libzmq3-dev m4 perl pkg-config zlib1g-dev 
RUN opam install -y jupyter
RUN sudo /home/opam/.local/bin/jupyter kernelspec install --name ocaml-jupyter "$(opam config var share)/jupyter"
ENTRYPOINT []
CMD ["/home/opam/.local/bin/jupyterhub-singleuser"]

