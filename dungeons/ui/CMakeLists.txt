add_library(dungeons_ui armor_select.cpp button.cpp class_select.cpp config.cpp context.cpp entity_info.cpp label_value.cpp new_attributes.cpp new_stats.cpp weapon_select.cpp)

target_include_directories(dungeons_ui PUBLIC "${PROJECT_SOURCE_DIR}/dungeons")

target_link_libraries(dungeons_ui PUBLIC ionpot dungeons_game)
