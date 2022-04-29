set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED true)

if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC"
OR "${CMAKE_CXX_SIMULATE_ID}" STREQUAL "MSVC")
	# /W4 -> warning level 4
	# /WX -> warnings are errors
	# /we4062 -> enable warning C4062 as an error
	add_compile_options(/W4 /WX /we4062)
else()
	add_compile_options(-Wall -Wextra -pedantic -Werror)
endif()

# subdirectories
add_subdirectory(ui)

# WIN32 flag removes the console window on Windows
add_executable(dungeons WIN32 combat_screen.cpp game.cpp main.cpp run.cpp new_char_screen.cpp)

# project version/build numbers placed here
configure_file(version.hpp.in version.hpp @ONLY)

# program can include the processed config files above
target_include_directories(dungeons PRIVATE "${PROJECT_BINARY_DIR}")

# program includes subdirs as <subdir/...>
target_include_directories(dungeons PRIVATE "${CMAKE_CURRENT_LIST_DIR}")

# dependencies
target_link_libraries(dungeons PRIVATE ionpot dungeons_ui)

# place the executable and the files/dirs it needs
# "TYPE BIN" puts them next to the executable
install(TARGETS dungeons)
install(FILES ui.cfg TYPE BIN)
install(DIRECTORY assets TYPE BIN)
