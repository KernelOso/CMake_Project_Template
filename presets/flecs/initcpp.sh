#!/usr/bin/env bash
set -e # Exit when errores detected
set -u # exit when use variables not inicialized
set -euo pipefail
# Missing CMake 
if command -v cmake >/dev/null 2>&1; then
    echo -e "\033[36m Initializing Project..."
    #Generate Directories
    echo -e "\033[36m Creating Directories..."
    dirs=("thirdparty" "resources" "include" "src" "cmake-build-debug" "cmake-build-release" )
    for dir in "${dirs[@]}"; do
        if [[ -d "$dir" ]]; then
            echo -e "\033[33m  Directory '$dir' already exist!"
        else
            mkdir "$dir"
            echo -e "\033[32m Directory '$dir' created!"
        fi
    done
    # Get CMake Config File
    echo -e "\033[36m Creating CMakeLists file..."
    RAW_URL="https://raw.githubusercontent.com/KernelOso/CMake_Project_Template/refs/heads/main/presets/flecs/CMakeLists.txt"
    PROJECT_NAME="$(basename "$PWD")"
    TEMP_FILE="$(mktemp)"
    curl -fsSL "$RAW_URL" -o "$TEMP_FILE"
    sed "s/{{ProjectName}}/${PROJECT_NAME}/g" "$TEMP_FILE" > "./CMakeLists.txt"
    rm "$TEMP_FILE"
    # cloning github repos
    if command -v git >/dev/null 2>&1; then
        #flecs
        git clone --depth 1 https://github.com/SanderMertens/flecs.git thirdparty/flecs
    fi
    # Generate Exampel Code
    echo -e "\033[36m Creating Example code..."
    cat > "src/main.cpp" << EOF

#include <flecs.h>
#include <iostream>

// 1. Create a simple COMPONENT
struct Name {
    std::string value;
};

int main() {

    // 2. Create a flecs WORLD
    flecs::world world;

    // 3. Register your COMPONENTs
    world.component<Name>();

    // 4. Create an ENTITY whit your COMPONENTs
    auto e = world.entity("MyEntity")
             .set<Name>({ "¡Hi, Flecs!" });

    // 5. Create a QUERY
    flecs::query<const Name> q = world.query<const Name>();

    // 6. Iterate your QUERY
    q.each([](flecs::entity e, const Name& name) {
        std::cout << "Entity  : " << e.name() << "\n";
        std::cout << "Message : " << name.value << "\n";
    });

    return 0;
}

EOF
    echo "\033[32m Project generated successfully!"
    # compile debug and release folders
    cmake -S . -B cmake-build-debug -DCMAKE_BUILD_TYPE=Debug
    cmake -S . -B cmake-build-release -DCMAKE_BUILD_TYPE=Release
    # show commands to compile
    cat <<EOF
########################################
########################################
#### Project Generated Successfully!####
########################################
########################################

To Compile and run your code, use the follow commands :

    # Debug Compilation :

        #C ompile
        cmake --build cmake-build-debug

        # Run
        ./cmake-build-debug/${PROJECT_NAME}

    # Release Compilation :

        # Compile
        cmake --build cmake-build-release
        # Run
        ./cmake-build-release/${PROJECT_NAME}

EOF
else 
    echo -e "\033[31m You need CMake for use this project"
fi



