#!/bin/bash

# Set the port
PORT=7878

# # Stop any program currently running on the set port
# echo 'preparing port' $PORT '...'
# fuser -k 7878/tcp

# switch directories
cd build/web/

# Start the server
echo 'Server starting on port' $PORT '...'
python3 -m http.server $PORT