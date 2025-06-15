#include <stdio.h>
#include <stdbool.h>
#include <SDL.h>
#include <flecs.h>

// Define the Message component
typedef struct {
    const char *value;
} Message;

// System to show the message
void show_message(ecs_iter_t *it) {
    Message *m = ecs_field(it, Message, 1);
    for (int i = 0; i < it->count; i++) {
        printf("%s\n", m[i].value);
    }
}

int main(int argc, char *argv[]) {
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        fprintf(stderr, "SDL_Init Error: %s\n", SDL_GetError());
        return 1;
    }

    SDL_Window *window = SDL_CreateWindow(
        "Window Title",
        SDL_WINDOWPOS_CENTERED,
        SDL_WINDOWPOS_CENTERED,
        800, 600,
        SDL_WINDOW_SHOWN
    );

    if (!window) {
        SDL_Quit();
        return 1;
    }

    // Initialize Flecs world
    ecs_world_t *world = ecs_init();

    // Register the Message component
    ECS_COMPONENT(world, Message);

    // Create an entity and set the Message component
    ecs_entity_t e = ecs_entity_init(world, &(ecs_entity_desc_t){
        .name = "MyEntity"
    });
    ecs_set(world, e, Message, { "¡Hi, Flecs!" });

    // Register a system to print the Message component
    ECS_SYSTEM(world, show_message, EcsOnUpdate, Message);

    // Main loop
    bool isExecuting = true;
    SDL_Event event;

    while (isExecuting) {
        while (SDL_PollEvent(&event)) {
            if (event.type == SDL_QUIT) {
                isExecuting = false;
            }
        }

        ecs_progress(world, 0);
        SDL_Delay(16); // ~60 FPS
    }

    // Cleanup
    ecs_fini(world);
    SDL_DestroyWindow(window);
    SDL_Quit();

    return 0;
}
