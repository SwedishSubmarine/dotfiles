#!/usr/bin/env bash

countdown=$(python3 open_time.py)
sed -i "s/\(motd=\).*/\1$countdown/" server.properties
