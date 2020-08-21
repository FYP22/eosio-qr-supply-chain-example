#include "../include/tracker.hpp"

// namespace location table as proxy for multi index
using location_table = eosio::multi_index<eosio::name("location"), location>;

// create an item to track in location table (adds new row)
[[eosio::action]]
void tracker::create(uint64_t id, eosio::name account, std::string location){
    require_auth(account);
    location_table loc_table(get_self(), 0);

    // see if item already exists
    auto itr = loc_table.find(id);

    if( itr == loc_table.end() ) {
        // if it doesn't exist add new row to location table
        loc_table.emplace(account, [&]( auto& row ) {
            row.id = id;
            row.location = location;
            row.updated = eosio::publication_time();
        });
    } else {
        // if item does exist then print message and do nothing
        eosio::print_f("Item has already been created");
    }
}

[[eosio::action]]
void tracker::update(uint64_t id, eosio::name account, std::string location){
    require_auth(account);
    location_table loc_table(get_self(), 0);

    // see if item already exists
    auto itr = loc_table.find(id);

    if( itr == loc_table.end() ) {
        // if item doesn't exist then print message and do nothing
        eosio::print_f("Item has not been created");
    } else {
        // if item does exist then update `location` attribute of the row
        // and update the `updated` time to the time the transaction was published
        loc_table.modify(itr, account, [&]( auto& row ) {
            row.location = location;
            row.updated = eosio::publication_time();
        });
    }
}
