#!/bin/sh

echo "Keosd instance is starting...\n"

# rm files from previous deployment
rm -rf /blockchain/wallet/*

# deploy keosd instance with desired configs
keosd \
--wallet-dir /blockchain/wallet     \
--plugin eosio::http_plugin         \
--plugin eosio::wallet_api_plugin   \
--http-server-address 0.0.0.0:9876  \
--access-control-allow-origin='*'   \
--verbose-http-errors               \
--http-validate-host=false          \
--unlock-timeout=999999
