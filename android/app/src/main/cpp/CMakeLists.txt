cmake_minimum_required(VERSION 3.10)
project(sweffi C)

add_library(sweffi SHARED
  swe_wrapper.c

  # Swiss Ephemeris sources
  swe/sweph.c
  swe/swephlib.c
  swe/swecl.c
  swe/swehouse.c
  swe/swedate.c
  swe/swejpl.c
  swe/swemmoon.c
  swe/swemplan.c
  swe/swehel.c
  swe/swemini.c
)

target_include_directories(sweffi PRIVATE
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}/swe
)

find_library(log-lib log)
target_link_libraries(sweffi ${log-lib} m)