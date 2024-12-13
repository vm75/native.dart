# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(example_ffi_plugin_library VERSION 0.0.1 LANGUAGES C)

add_library(example_ffi_plugin SHARED
  "example_ffi_plugin.c"
)

set_target_properties(example_ffi_plugin PROPERTIES
  PUBLIC_HEADER example_ffi_plugin.h
  OUTPUT_NAME "example_ffi_plugin"
)

target_compile_definitions(example_ffi_plugin PUBLIC DART_SHARED_LIB)
