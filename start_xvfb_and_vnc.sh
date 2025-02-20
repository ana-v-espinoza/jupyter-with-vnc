if [[ -v START_XVFB_AND_VNC ]]
then
	xinit -- /usr/bin/Xvfb :1 &
fi
