cmake_minimum_required(VERSION 3.5)
project(tracker)

find_package(eosio.cdt)

add_contract(tracker tracker tracker.cpp)