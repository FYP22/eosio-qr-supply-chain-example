#include "../include/tracker.hpp"

//                                                      name         type
using location_table = eosio::multi_index<eosio::name("location"), location>;

[[eosio::action]]
void tracker::create(uint64_t id, eosio::name account, std::string location){
    require_auth(account);
    location_table loc_table(get_self(), 0);
    auto itr = loc_table.find(id);
    if( itr == loc_table.end() ) {
        loc_table.emplace(account, [&]( auto& row ) {
            row.id = id;
            row.location = location;
            row.updated = eosio::publication_time();
        });
    } else {
        eosio::print_f("Item has already been created");
    }
}

[[eosio::action]]
void tracker::update(uint64_t id, eosio::name account, std::string location){
    require_auth(account);
    location_table loc_table(get_self(), 0);
    auto itr = loc_table.find(id);
    if( itr == loc_table.end() ) {
        eosio::print_f("Item has not been created");
    } else {
        loc_table.modify(itr, account, [&]( auto& row ) {
            row.location = location;
            row.updated = eosio::publication_time();
        });
    }
}
