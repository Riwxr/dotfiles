#!/usr/bin/env python3
import mpris2

# get all player URIs
uris = mpris2.get_players_uri()  # list of MPRIS DBus names

print (uris)

# for uri in uris:
    # player = mpris2.Player(uri)  # pass URI positionally
    # print(f"Name: {player.identity}, PID: {player.pid}")
