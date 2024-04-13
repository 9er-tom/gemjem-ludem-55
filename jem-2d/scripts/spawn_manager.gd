extends Node2D

signal entity_spawned
@export var spawnPos: Vector2
@export var debugEntity: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
    _on_spawn_entity(debugEntity)


#todo connect signal to _on_spawn_entity

func _on_spawn_entity(entity: PackedScene):
    var ent: Node2D = entity.instantiate()

    if ent.has_node("Enemy"):
        $Enemies.add_child(ent)
        print("enemy")
    elif ent.has_node("Friendly"):
        $Friendlies.add_child(ent)
        print("friendly")
    else:
        print("nothing")
        return

    ent.global_position = spawnPos
	
	
