#!/bin/sh

echo "\nNodeos instance is starting...\n"

# rm content from last build
rm -rf /blockchain/data/*
rm -rf /blockchain/blocks/*
rm -rf /blockchain/config/*

# start nodeos with desired configuration
nodeos \
-e -p eosio \
--data-dir /blockchain/data     \
--blocks-dir /blockchain/blocks \
--config-dir /blockchain/config \
--plugin eosio::producer_plugin \
--plugin eosio::producer_api_plugin \
--plugin eosio::chain_api_plugin \
--plugin eosio::http_plugin \
--plugin eosio::history_plugin \
--plugin eosio::history_api_plugin \
--filter-on="*" \
--access-control-allow-origin='*' \
--contracts-console \
--http-server-address 0.0.0.0:8888 \
--http-validate-host=false \
--verbose-http-errors 