cmake_minimum_required(VERSION 3.17)
project(qr_json_example_01)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} "-std=c++17 -pthread")
set(CMAKE_USE_OPENSSL OFF)
set(USE_SYSTEM_CURL ON)

# fetch cpr
include(FetchContent)
FetchContent_Declare(cpr GIT_REPOSITORY https://github.com/whoshuu/cpr.git GIT_TAG c8d33915dbd88ad6c92b258869b03aba06587ff9) # the commit hash for 1.5.0
FetchContent_MakeAvailable(cpr)

# Requires OpenCV
FIND_PACKAGE( OpenCV REQUIRED )
MESSAGE("OpenCV version: ${OpenCV_VERSION}")

include_directories(third-party)
add_executable(qr_json_example_01 main.cpp)
TARGET_LINK_LIBRARIES(qr_json_example_01 ${OpenCV_LIBS})
TARGET_LINK_LIBRARIES(qr_json_example_01 cpr::cpr)