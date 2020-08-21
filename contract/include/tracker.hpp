#include <eosio/eosio.hpp>

// location table
struct [[eosio::table("location"), eosio::contract("tracker")]] location {
    uint64_t id;
    std::string location;
    eosio::time_point_sec updated;

    uint64_t primary_key() const { return id; }
};

class tracker : eosio::contract {
    public:

    // constructor
    tracker(eosio::name receiver, eosio::name code,  eosio::datastream<const char*> ds) : eosio::contract(receiver, code, ds) {}

    // create an item to track in location table (adds new row)
    [[eosio::action]]
    void create(uint64_t id, eosio::name account, std::string location);

    // update an item that already exists in the location table
    [[eosio::action]]
    void update(uint64_t id, eosio::name account, std::string location);

    location loc_table;
};