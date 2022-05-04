add_library(dungeons_ui button.cpp class_select.cpp config.cpp context.cpp new_attributes.cpp text.cpp to_string.cpp)

target_include_directories(dungeons_ui PUBLIC "${PROJECT_SOURCE_DIR}/dungeons")

target_link_libraries(dungeons_ui PUBLIC ionpot)
