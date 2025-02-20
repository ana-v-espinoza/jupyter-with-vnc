# Heavily borrowed from docker-stacks/minimal-notebook/
# https://github.com/jupyter/docker-stacks/blob/main/minimal-notebook/Dockerfile

ARG BASE_CONTAINER=quay.io/jupyter/minimal-notebook
FROM $BASE_CONTAINER

ENV DISPLAY=:1 \
    NOVNC_DIR=/novnc \
    DESKTOP_ENVIRONMENT=xfce

LABEL maintainer="Unidata <support-gateway@unidata.ucar.edu>"

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      # Dummy X server; vnc server & client; \
      x11vnc xvfb xinit novnc xarclock \
      # Barebones window managers \
      fluxbox awesome \
      # Some programs for a minimal xfce4 desktop
      thunar xfdesktop4 xfwm4 xfce4-panel xfce4-session \
      xfce4-appfinder mousepad xfce4-terminal dbus-x11 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    # VNC client
    git clone https://github.com/novnc/novnc --depth=1 $NOVNC_DIR
    chown -R 1000:100 $NOVNC_DIR

USER $NB_UID

RUN mamba install --quiet --yes \
      'conda-forge::jupyter-server-proxy' && \
    mamba clean --all -f -y && \
    jupyter lab clean -y && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER && \

# For this to run, the START_XVFB_AND_VNC variable must be set
ADD --chown=1000:100 xinitrc $HOME/.xinitrc
ADD start_xvfb_and_vnc.sh /usr/local/bin/before-notebook.d/start_xvfb_and_vnc.sh

# For starting the VNC server and client
ADD jupyter_server_proxy_config.py /tmp/jupyter_server_proxy_config.py
RUN cat /tmp/jupyter_server_proxy_config.py >> $HOME/.jupyter/jupyter_server_config.py

USER $NB_UID
