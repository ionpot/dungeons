add_library(dungeons_game class.cpp combat.cpp config.cpp context.cpp entity.cpp log.cpp string.cpp)

target_link_libraries(dungeons_game PUBLIC ionpot)
