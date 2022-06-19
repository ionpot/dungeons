add_library(dungeons_game class.cpp config.cpp context.cpp dice.cpp entity.cpp)

target_link_libraries(dungeons_game PUBLIC ionpot)
