FROM ryanrhymes/owl:ubuntu
ARG JUPYTERHUB_VERSION=0.9.4
RUN sudo apt-get update
RUN sudo apt-get install -y python3-pip
RUN pip3 install --no-cache jupyterhub==$JUPYTERHUB_VERSION notebook
RUN sudo apt-get -y install debianutils libgmp-dev libzmq3-dev m4 perl pkg-config zlib1g-dev 
RUN opam install -y jupyter merlin
RUN sudo /home/opam/.local/bin/jupyter kernelspec install --name ocaml-jupyter "$(opam config var share)/jupyter"
ENTRYPOINT []
WORKDIR /home/opam
RUN sudo apt-get install plplot-driver-cairo
COPY ocamlinit .ocamlinit
COPY download_all.ml download_all.ml
RUN ./download_all.ml
RUN git clone https://github.com/jonludlam/owl_jupyter.git
RUN cd owl_jupyter && dune build && dune install
RUN ./download_all.ml
COPY start-singleuser.sh /home/opam/.local/bin/
WORKDIR /home/opam/work
CMD ["/home/opam/.local/bin/start-singleuser.sh"]

