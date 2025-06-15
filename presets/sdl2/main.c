#include <stdio.h>
#include <stdbool.h>
#include <SDL.h>

int main() {

    // 1. Initialize SDL modules
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        fprintf(stderr, "SDL_Init Error: %s\n", SDL_GetError());
        return 1;
    }

    // 2. Create window
    SDL_Window *window = SDL_CreateWindow(
        "Window Title",                // Window Title
        SDL_WINDOWPOS_CENTERED,       // X Window position on screen
        SDL_WINDOWPOS_CENTERED,       // Y Window position on screen
        800, 600,                      // X,Y Window size
        SDL_WINDOW_SHOWN              // Visible mode
    );

    // 3. Verify window
    if (!window) {
        SDL_Quit();
        return 1;
    }

    bool isExecuting = true;
    SDL_Event event;

    // 4. Set the main execution loop
    while (isExecuting) {

        // 5. Event Treat
        while (SDL_PollEvent(&event)) {

            if (event.type == SDL_QUIT) {
                isExecuting = false;
            }

        }

        // 6. FPS Control
        SDL_Delay(16);
    }

    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}