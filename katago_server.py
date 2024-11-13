#!/usr/bin/env python

# /********************************************************************
# Filename: katago_server.py
# Author: AHN
# Creation Date: Jan, 2020
# **********************************************************************/
#
# A back end API to run KataGo as a REST service
#

from katago_gtp_bot import KataGTPBot
from get_bot_app import get_bot_app

model = '/home/jsnavely/project/katago/kata1-b28c512nbt-s7944987392-d4526094999.bin.gz'
katago_exec = '/nix/var/nix/profiles/default/bin/katago'
config = '/home/jsnavely/project/katago/gtp_custom.cfg'
katago_cmd = f'{katago_exec} gtp -model {model} -config {config}'
katago_gtp_bot = KataGTPBot( katago_cmd.split() )

# Get an app with 'select-move/<botname>' endpoints
app = get_bot_app( name='katago_gtp_bot', bot=katago_gtp_bot )
hostname = '0.0.0.0'
if __name__ == '__main__':
    app.run( host=hostname, port=8888, debug=True)
