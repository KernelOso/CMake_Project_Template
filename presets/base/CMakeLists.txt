
cmake_minimum_required(VERSION "3.20")

####################################################################################################
### Windows Runtime Config                                                                       ###
####################################################################################################
#set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
#set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Release>:Release>")
# This pair of lines, indicates to CMake to compile the project, using the Runtime in a statically way so, it doesn't
# depends on the VCRedist version installed.
# This configuration only works on Windows using MSVC compiler

####################################################################################################
### Compile Optimizations                                                                        ###
####################################################################################################
# in case of an release build, compile using the IPO/LTO optimizations
if(CMAKE_BUILD_TYPE STREQUAL "Release")
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
else()
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION FALSE)

endif()

####################################################################################################
### Project Config                                                                               ###
####################################################################################################
project("{{ProjectName}}") # Specify the name of the project

# Useful variables
# - ${CMAKE_PROJECT_NAME} == THIS project name
# - ${CMAKE_CURRENT_SOURCE_DIR} == The path of the directory where CmakeLists is located

##################
##### Language Standard Config
##################
# Use set() to set values in CMake Variables
set(CMAKE_C_STANDARD 11) # Specify the version of the C Standard language to use
set(CMAKE_CXX_STANDARD 17) # Specify the version of the C++ Standard language to use

##################
##### Dynamic source files import
##################
# This line, add ALL the .cpp files in the "MY_SOURCES" variable, so you don't need to add
# manually each .cpp and .c files to the "add_executable()" config
file(GLOB_RECURSE MY_SOURCES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c" "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")

##################
##### Executable config
##################
add_executable("${CMAKE_PROJECT_NAME}" "${MY_SOURCES}")

##################
##### Header files
##################
# this line, specify where's the folder where the headers file will be located
target_include_directories("${CMAKE_PROJECT_NAME}" PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}/include/" )

####################################################################################################
### Add external project libraries                                                               ###
####################################################################################################

##################
##### Git Clone Commands
##################

# <Library Name>
# git clone <url> thirdparty/<Library Name>

##################
##### Library Config
##################

# <Library Name>
# set <library config variable>

##################
##### Subdirectory Import
##################
#add_subdirectory("thirdparty/...")
# This Line, tells to CMake to look in the specified folder, for other CMakeList files to add in the project

# <Library Name>
# add_subdirectory("thirdparty/<Library Name>")

##################
##### External Project Libraries
##################
#target_link_libraries("${CMAKE_PROJECT_NAME}" <Private/Public/Protected> "SubProject")
# After add an external project whit `add_subdirectory()` you can add the sub project to the project usings this line

# <Library Name>
#target_link_libraries("${CMAKE_PROJECT_NAME}" <Private/Public/Protected> "SubProject")


####################################################################################################
### Compile Environment options                                                                  ###
####################################################################################################
# Explanation of the following 2 lines :
# Both lines set a MACRO (constant var) for the path where the resources files of the program will be located
# The first line, set a ABSOLUTE path using the CMakeLists file path variable, this line is used for a
# Development environment
#
# The Second line, set a relative path, starting with the location of the executable of the program
# this line is used for a release environment
# inside the code, you can access to a resources files in the next way :
# file( RESOURCES_PATH "file.example" )
#
# you can create more of this kind of constants, to save different resources files, databases, etc..
#target_compile_definitions("${CMAKE_PROJECT_NAME}" PUBLIC "RESOURCES_PATH=\"${CMAKE_CURRENT_SOURCE_DIR}/resources/\"")
#target_compile_definitions("${CMAKE_PROJECT_NAME}" PUBLIC "RESOURCES_PATH=\"./resources/\"")

if(CMAKE_BUILD_TYPE STREQUAL "Release")
    ##################
    ##### Dynamic folders
    ##################
    target_compile_definitions("${CMAKE_PROJECT_NAME}" PUBLIC "RESOURCES_PATH=\"./resources/\"")
else()
    ##################
    ##### Dynamic folders
    ##################
    target_compile_definitions("${CMAKE_PROJECT_NAME}" PUBLIC "RESOURCES_PATH=\"${CMAKE_CURRENT_SOURCE_DIR}/resources/\"")
endif ()

