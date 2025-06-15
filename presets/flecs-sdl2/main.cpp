
#include <iostream>
#include <SDL.h>
#include <flecs.h>

struct Message {    //create a component
    std::string value;
};

int main() {

    if ( SDL_Init(SDL_INIT_VIDEO) != 0 ){    //Initialize your components
        std::cerr << "SDL_Init Error: " << SDL_GetError() << std::endl;
        return 1;
    }


    SDL_Window *window = SDL_CreateWindow(    //create a window
            "Window Title",                   //Window Title
            SDL_WINDOWPOS_CENTERED,    // X Window position on screen
            SDL_WINDOWPOS_CENTERED,    // Y Window position on screen
            800 , 600 ,             // X,Y Window size
            SDL_WINDOW_SHOWN           //Visible mode
        );
    if (!window){    //verify your window
        SDL_Quit();
        return 1;
    }

    //SDL variables
    bool isExecuting = true;
    SDL_Event event;

    // -- flecs initialization
    flecs::world world;    //create a flecs world

    world.component<Message>();    //regist your components

    auto e = world.entity("MyEntity")    //create and regist an entity
                 .set<Message>({ "¡Hi, Flecs!" });

    world.system<Message>("show Message!") //create and regist a system
        .each([](const Message& msg){
        std::cout << msg.value << "\n";
    });

    //Main loop
    while (isExecuting) {


        while (SDL_PollEvent(&event)) {    //treat the events

            if (event.type == SDL_QUIT) {
                isExecuting = false;
            }

        }

        world.progress();    //process your world

        SDL_Delay(16); //60 fps
    }

    //Clean SDL
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}