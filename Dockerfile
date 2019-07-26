FROM ryanrhymes/owl:debian
ARG JUPYTERHUB_VERSION=0.9.4
ENV OPAM_SWITCH_PREFIX='/home/opam/.opam/4.07' \
    CAML_LD_LIBRARY_PATH='/home/opam/.opam/4.07/lib/stublibs:/home/opam/.opam/4.07/lib/ocaml/stublibs:/home/opam/.opam/4.07/lib/ocaml' \
  OCAML_TOPLEVEL_PATH='/home/opam/.opam/4.07/lib/toplevel' \
  MANPATH=':/home/opam/.opam/4.07/man' \
  PATH='/home/opam/.opam/4.07/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

RUN opam switch 4.07
RUN cd /home/opam/opam-repository && git pull origin master
RUN opam update
RUN sudo apt-get update
RUN sudo apt-get install -y python3-pip vim debianutils libgmp-dev libzmq3-dev m4 perl pkg-config zlib1g-dev pandoc texlive-xetex plplot12-driver-cairo gnuplot libsundials-serial-dev
RUN pip3 install --no-cache jupyterhub==$JUPYTERHUB_VERSION notebook
RUN pip3 install --no-cache jupyter_contrib_nbextensions
RUN pip3 install --no-cache RISE
RUN opam install -y jupyter merlin bos sundialsml ocamlformat lbfgs plplot
RUN sudo -E /home/opam/.local/bin/jupyter kernelspec install --name ocaml-jupyter "$(opam config var share)/jupyter"
ENTRYPOINT []
WORKDIR /home/opam
COPY ocamlinit .ocamlinit
COPY update.sh update.sh
#COPY download_all.ml download_all.ml
#RUN ./download_all.ml
RUN opam install --deps-only owl-top
RUN mkdir libs
WORKDIR /home/opam/libs
RUN git clone https://github.com/owlbarn/owl.git owl-github
RUN git clone https://github.com/jonludlam/owl_jupyter.git
RUN git clone https://github.com/owlbarn/owl_ode.git && cd owl_ode && git checkout 2d4f176d3539de5b
RUN git clone https://github.com/tachukao/owl_lbfgs.git
RUN git clone https://github.com/hennequin-lab/gp.git
RUN git clone https://github.com/hennequin-lab/juplot.git
RUN git clone https://github.com/pkp-neuro/pkp-tutorials.git
RUN dune build && dune install
COPY start-singleuser.sh /home/opam/.local/bin/
RUN git clone https://github.com/Gnuplotting/gnuplot-palettes.git
COPY gnuplot .gnuplot
RUN /home/opam/.local/bin/jupyter contrib nbextension install --user
RUN /home/opam/.local/bin/jupyter-nbextension install rise --py --user
RUN /home/opam/.local/bin/jupyter-nbextension enable rise --py --user
COPY notebook.json /home/opam/.jupyter/nbconfig/notebook.json
RUN sudo chown opam /home/opam/.jupyter/nbconfig/notebook.json
COPY custom.tar.gz /home/opam/.jupyter/
RUN cd /home/opam/.jupyter && tar xvf custom.tar.gz
RUN mkdir /home/opam/pkp
RUN mkdir /home/opam/pkp/work
RUN rm -rf /home/opam/libs/owl-github
WORKDIR /home/opam/pkp
ENV OCAML_JUPYTER_LOG debug
CMD ["/home/opam/.local/bin/start-singleuser.sh"]

