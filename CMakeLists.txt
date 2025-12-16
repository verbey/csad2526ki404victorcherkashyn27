cmake_minimum_required(VERSION 3.15)

project(hello_world VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(hello_world main.cpp)

install(TARGETS hello_world RUNTIME DESTINATION bin)

# --- GoogleTest and unit tests
include(CTest)
option(BUILD_TESTING "Build unit tests" ON)

if(BUILD_TESTING)
	include(FetchContent)
	FetchContent_Declare(
		googletest
		GIT_REPOSITORY https://github.com/google/googletest.git
		GIT_TAG release-1.12.1
	)
	FetchContent_MakeAvailable(googletest)

	add_executable(unit_tests tests/unit_tests.cpp)
	target_include_directories(unit_tests PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
	target_link_libraries(unit_tests PRIVATE GTest::gtest_main)

	include(GoogleTest)
	gtest_discover_tests(unit_tests)
endif()