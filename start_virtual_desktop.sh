if [[ -v START_VIRTUAL_DESKTOP ]]
then
  export VD_OUT="$HOME/.virtual-desktop.out"
  export VD_ERR="$HOME/.virtual-desktop.err"

  echo "[[ INFO ]] Jupyter with VNC: $(date '+%F %T') -- Starting Virtual Desktop" \
    | tee -a $VD_OUT $VD_ERR
  echo "[[ INFO ]] Jupyter with VNC: $(date '+%F %T') -- Refer to $VD_OUT and $VD_ERR for logging information"

	xinit -- /usr/bin/Xvfb :1 1>>"${VD_OUT}" 2>>"${VD_ERR}" &
fi
