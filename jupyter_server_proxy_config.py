######
# Begin Jupyter Server Proxy Config
######

c.ServerProxy.servers = {
   "vnc-client": {
       "command": [ "/home/jovyan/novnc/utils/novnc_proxy", "--vnc", "localhost:5900", "--listen", "{port}"],
       "timeout": 30,
       "launcher_entry": { "path_info": "vnc-client/vnc.html" }
   }
}

######
# End Jupyter Server Proxy Config
######
