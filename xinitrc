# Start vnc server
/usr/bin/x11vnc -display :1 $SHARESTRING -autoport $APORT -repeat -forever &

# Select window manager/desktop environment
case "$DESKTOP_ENVIRONMENT" in
  fluxbox) /usr/bin/startfluxbox ;;
  awesome) awesome ;;
  xfce) startxfce4 ;;
  *) startxfce4 ;;
esac
