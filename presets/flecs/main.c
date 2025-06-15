#include <flecs.h>
#include <stdio.h>

// 1. Create a simple COMPONENT
typedef struct {
    const char *value;
} Name;

int main() {

    // 2. Create a flecs WORLD
    ecs_world_t *world = ecs_init();

    // 3. Register your COMPONENTs
    ECS_COMPONENT(world, Name);

    // 4. Create an ENTITY whit your COMPONENTs
    ecs_entity_t e = ecs_set_name(world, 0, "MyEntity");
    ecs_set(world, e, Name, { "¡Hi, Flecs!" });

    // 5. Create a QUERY
    ECS_QUERY(world, NameQuery, Name);

    // 6. Iterate your QUERY
    ecs_iter_t it = ecs_query_iter(world, NameQuery);
    while (ecs_query_next(&it)) {
        Name *name = ecs_field(&it, Name, 1);
        for (int i = 0; i < it.count; i++) {
            const char *ent_name = ecs_get_name(world, it.entities[i]);
            printf("Entity  : %s\n", ent_name);
            printf("Message : %s\n", name[i].value);
        }
    }

    
    return 0;
}