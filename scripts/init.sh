#!/usr/bin/env bash
set -e # Exit when errores detected
set -u # exit when use variables not inicialized
set -euo pipefail
#github url
githubPresetRawUrl="https://raw.githubusercontent.com/KernelOso/CMake_Project_Template/refs/heads/main/${$1}/"
type="$2"
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
    RAW_URL="${githubPresetRawUrl}CMakeLists.txt"
    PROJECT_NAME="$(basename "$PWD")"
    TEMP_FILE="$(mktemp)"
    curl -fsSL "$RAW_URL" -o "$TEMP_FILE"
    sed "s/{{ProjectName}}/${PROJECT_NAME}/g" "$TEMP_FILE" > "./CMakeLists.txt"
    rm "$TEMP_FILE"
    # cloning github repos
    if command -v git >/dev/null 2>&1; then
        #commands file
        curl -fsSL "${githubPresetRawUrl}libraries.txt" | bash || echo "  libraries.txt doesn't exist!"
    fi
    # Generate Exampel Code
    echo -e "\033[36m Creating Example code..."
    curl -L "${githubPresetRawUrl}main.${type}" -o "./src/main.${type}"
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

        # Compile
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



