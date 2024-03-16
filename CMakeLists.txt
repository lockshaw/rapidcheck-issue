cmake_minimum_required(VERSION 3.10)
project(rapidcheck-example)

find_package(rapidcheck REQUIRED)

add_library(rapidcheck-example SHARED src/main.cc)
target_link_libraries(rapidcheck-example PUBLIC rapidcheck)
