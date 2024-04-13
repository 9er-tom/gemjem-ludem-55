extends Node2D

signal entity_spawned
@export var friendlySpawnPos: Vector2
@export var enemySpawnPos: Vector2
@export var debugEntity: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready(): 
	#_on_spawn_entity(debugEntity)
	pass


#todo connect signal to _on_spawn_entity

func _on_spawn_entity(entity: PackedScene, spawnPos = null) -> void:
	var ent: Node2D = entity.instantiate()

	if ent.has_node("Enemy"):
		$Enemies.add_child(ent)
		print("enemy")
		ent.position = spawnPos if spawnPos else enemySpawnPos

	elif ent.has_node("Friendly"):
		$Friendlies.add_child(ent)
		print("friendly")
		ent.position = spawnPos if spawnPos else friendlySpawnPos

	else:
		print("nothing")
		return

	#ent.global_position = spawnPos
