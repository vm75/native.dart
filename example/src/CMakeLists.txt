cmake_minimum_required(VERSION 3.18.1)

project("example")

add_library(
    WasmFfi
    SHARED
    native.c
)
