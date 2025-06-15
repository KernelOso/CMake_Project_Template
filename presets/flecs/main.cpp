
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