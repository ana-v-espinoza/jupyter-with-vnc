######
# Begin Jupyter Server Proxy Config
######

from os import environ

novnc_dir=environ['NOVNC_DIR']

c.ServerProxy.servers = {
   "Virtual-Desktop": {
       "command": [ f"{novnc_dir}/utils/novnc_proxy", "--vnc", "localhost:5900", "--listen", "{port}"],
       "timeout": 30,
       "launcher_entry": { "path_info": "vnc-client/vnc.html" }
   }
}

######
# End Jupyter Server Proxy Config
######
