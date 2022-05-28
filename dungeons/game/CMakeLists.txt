add_library(dungeons_game attributes.cpp class.cpp config.cpp context.cpp entity.cpp)

target_link_libraries(dungeons_game PUBLIC ionpot)
