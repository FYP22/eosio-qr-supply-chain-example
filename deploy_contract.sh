#!/bin/bash

echo ""
echo "Checking Cleos connection..."
echo ""
alias cleos="cleos --url http://0.0.0.0:8888/ --wallet-url http://0.0.0.0:9876/"
cleos get info

echo ""
echo "Creating wallet..."
echo ""
cleos wallet create --file ./blockchain/wallet/walletpwd
cleos wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

echo ""
echo "Compiling contract to WASM and ABI..."
echo ""
eosio-cpp ./contract/src/tracker.cpp

echo ""
echo "Deploying tracker contract..."
echo ""
cleos create account eosio tracker EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos set code tracker tracker.wasm
cleos set abi tracker tracker.abi

echo ""
echo "Creating test accounts..."
echo ""
cleos create account eosio scanner1 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio scanner2 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo ""
echo "Pushing test create action against contract..."
echo ""
cleos push action tracker create '[1000, scanner1, "US WEST-09"]' -p scanner1
cleos push action tracker create '[2000, scanner2, "US EAST-01"]' -p scanner2
cleos push action tracker create '[3000, scanner1, "CAN CENTRAL-01"]' -p scanner1
cleos push action tracker create '[4000, scanner2, "US CENTRAL-04"]' -p scanner2
cleos push action tracker create '[5000, scanner1, "ENG EAST-01"]' -p scanner1
cleos push action tracker create '[6000, scanner2, "JAP CENTRAL-01"]' -p scanner2
cleos push action tracker create '[7000, scanner1, "US EAST-03"]' -p scanner1
cleos push action tracker create '[8000, scanner2, "BRA WEST-01"]' -p scanner2
cleos push action tracker create '[9000, scanner1, "US WEST-06"]' -p scanner1

echo ""
echo "Viewing table from test contract..."
echo ""
cleos get table tracker '' location

echo ""
echo "Pushing test update action against contract..."
echo ""
cleos push action tracker update '[1000, scanner1, "US WEST-07"]' -p scanner1

echo ""
echo "Viewing table from test contract..."
echo ""
cleos get table tracker '' location

echo ""
echo "See all actions from contracts..."
echo ""
cleos get actions tracker