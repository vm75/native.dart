cmake_minimum_required(VERSION 3.18.1)

project("example")

add_library(
    native_example
    SHARED
    native_example.c
)
