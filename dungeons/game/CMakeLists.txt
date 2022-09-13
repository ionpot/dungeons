add_library(dungeons_game attributes.cpp class.cpp combat.cpp config.cpp context.cpp entity.cpp level_up.cpp log.cpp string.cpp)

target_link_libraries(dungeons_game PUBLIC ionpot)
