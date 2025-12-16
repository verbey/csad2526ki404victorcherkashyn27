cmake_minimum_required(VERSION 3.15)

project(hello_world VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(hello_world main.cpp)

install(TARGETS hello_world RUNTIME DESTINATION bin)