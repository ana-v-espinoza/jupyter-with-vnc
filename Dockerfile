# Heavily borrowed from docker-stacks/minimal-notebook/
# https://github.com/jupyter/docker-stacks/blob/main/minimal-notebook/Dockerfile

ARG BASE_CONTAINER=quay.io/jupyter/minimal-notebook
FROM $BASE_CONTAINER

ENV DEFAULT_ENV_NAME=unidata-standard \
    EDITOR=nano \
    VISUAL=nano \
    DISPLAY=:1

LABEL maintainer="Unidata <support-gateway@unidata.ucar.edu>"

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends vim nano curl zip unzip \
      x11vnc xvfb xinit novnc xarclock fluxbox awesome && \
      #thunar xfdesktop4 xfwm4 xfce4-panel xfce4-session \
      #xfce4-appfinder mousepad xfce4-terminal dbus-x11 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

RUN mamba install --quiet --yes \
      'conda-forge::nb_conda_kernels' \
      'conda-forge::jupyterlab-git' \
      'conda-forge::ipywidgets' \
      'conda-forge::jupyter-server-proxy' && \
    pip install --no-cache-dir nbgitpuller && \
    mamba clean --all -f -y && \
    jupyter lab clean -y && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER && \
    git clone https://github.com/novnc/novnc --depth=1

# For starting the VNC server and client
ADD jupyter_server_proxy_config.py /tmp/jupyter_server_proxy_config.py
ADD xinitrc $HOME/.xinitrc
# For this to run, the START_XVFB_AND_VNC variable must be set
ADD start_xvfb_and_vnc.sh /usr/local/bin/before-notebook.d/start_xvfb_and_vnc.sh

RUN cat /tmp/jupyter_server_proxy_config.py >> $HOME/.jupyter/jupyter_server_config.py

USER root
RUN chown 1000:100 $HOME/.xinitrc

USER $NB_UID

