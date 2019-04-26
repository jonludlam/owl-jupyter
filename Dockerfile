FROM ryanrhymes/owl:debian
ARG JUPYTERHUB_VERSION=0.9.4
RUN sudo apt-get update
RUN sudo apt-get install -y python3-pip
RUN pip3 install --no-cache jupyterhub==$JUPYTERHUB_VERSION notebook
RUN pip3 install --no-cache jupyter_contrib_nbextensions
RUN pip3 install --no-cache RISE
RUN sudo apt-get -y install debianutils libgmp-dev libzmq3-dev m4 perl pkg-config zlib1g-dev pandoc texlive-xetex
RUN opam install -y jupyter merlin bos
RUN sudo -E /home/opam/.local/bin/jupyter kernelspec install --name ocaml-jupyter "$(opam config var share)/jupyter"
ENTRYPOINT []
WORKDIR /home/opam
RUN sudo apt-get install plplot12-driver-cairo
COPY ocamlinit .ocamlinit
COPY download_all.ml download_all.ml
RUN git clone https://github.com/jonludlam/owl_jupyter.git

RUN cd owl_jupyter && dune build && dune install
COPY start-singleuser.sh /home/opam/.local/bin/
RUN sudo apt-get install -y gnuplot
RUN git clone https://github.com/ghennequin/gp.git
RUN cd gp && dune build && dune install
RUN git clone https://github.com/ghennequin/juplot.git
RUN cd juplot && dune build && dune install
RUN opam depext -y sundialsml
RUN opam install -y sundialsml ocamlformat
RUN git clone https://github.com/owlbarn/owl_ode.git
RUN cd owl_ode && dune build && dune install 
RUN git clone https://github.com/Gnuplotting/gnuplot-palettes.git
COPY gnuplot .gnuplot
RUN /home/opam/.local/bin/jupyter contrib nbextension install --user
RUN /home/opam/.local/bin/jupyter-nbextension install rise --py --user
RUN /home/opam/.local/bin/jupyter-nbextension enable rise --py --user
COPY notebook.json /home/opam/.jupyter/nbconfig/notebook.json
RUN sudo chown opam /home/opam/.jupyter/nbconfig/notebook.json
WORKDIR /home/opam/work
ENV OCAML_JUPYTER_LOG debug
CMD ["/home/opam/.local/bin/start-singleuser.sh"]

