cmake_minimum_required(VERSION 3.5.1)
project(libpystring C CXX)

if(MSVC)
  add_compile_options(/W3 /wd4005 /wd4996 /wd4018 -D_CRT_SECURE_NO_WARNINGS)
endif()

if(BUILD_SHARED_LIBS)
  set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
endif()

add_library(libpystring pystring.cpp)

install(
  TARGETS libpystring
  RUNTIME DESTINATION bin
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
)

if(NOT DISABLE_INSTALL_HEADERS)
  install(FILES pystring.h DESTINATION include)
endif()
