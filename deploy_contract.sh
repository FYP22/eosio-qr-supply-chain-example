rm -rf tracker.wasm tracker.abi

echo "\nChecking Cleos connection...\n"
alias cleos="cleos --url http://0.0.0.0:8888/ --wallet-url http://0.0.0.0:9876/"
cleos get info

echo "\nCreating wallet...\n"
cleos wallet create --file ./blockchain/wallet/walletpwd
cleos wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

echo "\nCompiling contract to WASM and ABI...\n"
eosio-cpp ./contract/src/tracker.cpp

echo "\nDeploying tracker contract...\n"
cleos create account eosio tracker EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos set code tracker tracker.wasm
cleos set abi tracker tracker.abi

echo "\nCreating test accounts...\n"
cleos create account eosio scanner1 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
cleos create account eosio scanner2 EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

echo "\nPushing test create action against contract...\n"
cleos push action tracker create '[1000, scanner1, "US WEST-09"]' -p scanner1
cleos push action tracker create '[2000, scanner2, "US EAST-01"]' -p scanner2
cleos push action tracker create '[3000, scanner1, "CAN CENTRAL-01"]' -p scanner1
cleos push action tracker create '[4000, scanner2, "US CENTRAL-04"]' -p scanner2
cleos push action tracker create '[5000, scanner1, "ENG EAST-01"]' -p scanner1
cleos push action tracker create '[6000, scanner2, "JAP CENTRAL-01"]' -p scanner2
cleos push action tracker create '[7000, scanner1, "US EAST-03"]' -p scanner1
cleos push action tracker create '[8000, scanner2, "BRA WEST-01"]' -p scanner2
cleos push action tracker create '[9000, scanner1, "US WEST-06"]' -p scanner1

echo "\nViewing table from test contract...\n"
cleos get table tracker '' location

echo "\nPushing test update action against contract...\n"
cleos push action tracker update '[1000, scanner1, "US WEST-07"]' -p scanner1

echo "\nViewing table from test contract...\n"
cleos get table tracker '' location

echo "\nSee all actions from contracts...\n"
cleos get actions tracker