extends Node2D

signal entity_spawned
@export var friendlySpawnPos: Vector2
@export var enemySpawnPos: Vector2

@export var friendlyEntity: PackedScene
@export var enemyEntity: PackedScene


@export var enemySpawnPosX: int = 1200
@onready var timer: Timer = $Timer
@onready var resources: ResourceManagement = $"/root/main/HUD/ResourceBar"

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.set_wait_time(2)
	timer.timeout.connect(_on_timeout)
	timer.start()
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		spawn_entity(friendlyEntity, get_viewport().get_mouse_position())
	if Input.is_action_just_pressed("rightclick"):
		spawn_entity(enemyEntity, get_viewport().get_mouse_position())
		

#todo connect signal to _on_spawn_entity

func spawn_entity(entity: PackedScene, spawnPos = null):
	var ent: Node2D = entity.instantiate()
	if ent.is_in_group("Enemy"):
		ent.position = spawnPos if spawnPos else enemySpawnPos
		ent.get_node("ElementalAffinityComponent").local_element = randi_range(0,4) # randomizes element
		ent.scale *= randf_range(0.5, 3) 
		$Enemies.add_child(ent)
		print("enemy")

	elif ent.is_in_group("Friendly"):
		if resources.spend_resource(ent.get_node("StatBlockComponent").spawn_cost):
			ent.position = spawnPos if spawnPos else friendlySpawnPos
			$Friendlies.add_child(ent)
			print("friendly")
	else:
		print("nothing")
		
func _on_timeout():
	var enemySpawnPosY: int = randi_range(0, get_viewport_rect().size.y)
	spawn_entity(enemyEntity, Vector2(enemySpawnPosX, enemySpawnPosY))
	timer.start()
	
