cmake_minimum_required(VERSION 3.29)
project(carg-os C)

if (NOT PLATFORM)
    set(PLATFORM QEMU)
endif()

set(LIBC_INCLUDE ${PROJECT_SOURCE_DIR}/libc/include)
add_subdirectory(karg)
add_subdirectory(init)
add_subdirectory(libc)

add_executable(carg-os src/dummy.c)
target_link_options(carg-os PRIVATE -nostdlib -T ${PROJECT_SOURCE_DIR}/karg/kernel.ld)
target_link_libraries(carg-os karg init libc)
