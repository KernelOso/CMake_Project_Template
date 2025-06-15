#!/usr/bin/env bash

set -e # Exit when errores detected
set -u # exit when use variables not inicialized
set -euo pipefail

echo -e "\033[36m Initializing Project..."

echo -e "\033[36m Creating Directories..."
dirs=("thirdparty" "resources" "include" "src" )
for dir in "${dirs[@]}"; do
    if [[ -d "$dir" ]]; then
        echo -e "\033[33m  Directory '$dir' already exist!"
    else
        mkdir "$dir"
        echo -e "\033[32m Directory '$dir' created!"
    fi
done

echo -e "\033[36m Creating CMakeLists file..."
RAW_URL="https://raw.githubusercontent.com/KernelOso/CMake_Project_Template/refs/heads/main/CMakeLists.txt"
PROJECT_NAME="$(basename "$PWD")"
TEMP_FILE="$(mktemp)"
curl -fsSL "$RAW_URL" -o "$TEMP_FILE"
sed "s/{{ProjectName}}/${PROJECT_NAME}/g" "$TEMP_FILE" > "./CMakeLists.txt"
rm "$TEMP_FILE"

echo -e "\033[36m Creating Example code..."

cat > "src/main.cpp" << EOF
#include <iostream>

int main() {
    std::cout << "Hello World!" << std::endl;
    return 0;
}

EOF

echo "\033[32m Project generated successfully!"

