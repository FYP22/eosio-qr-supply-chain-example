#!/bin/bash
echo "WARNING: THIS WILL DELETE ALL SCANNER CONFIG DATA"
echo ""

read -sp "Do you want to delete all scanner config data and remove the program from this machine? [y/n] " confirm

if [[ ${confirm} = y ]]; then
    rm -rf build/
    rm -rf config.json
fi