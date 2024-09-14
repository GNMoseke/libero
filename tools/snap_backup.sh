#!/bin/bash

[ -n "$1" ] || { echo "provide output directory"; exit 1; }

# check for 0B images
cd $HOME/snap/libero/current

echo "Checking for 0B image files:"
ls -la libero_data/ | rg "0B"

mkdir -p $1
outpath="$1/libero_bak_$(date +"%Y%m%d").tar"
tar -czf $outpath ./libero.json ./libero_data/

echo "Backup successfully saved to $outpath"
