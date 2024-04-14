extends Node2D

@export var friendlyEntity: PackedScene
@export var enemyEntity: PackedScene
@export var enemySpawnPosX: int = 1200

@onready var timer: Timer = $Timer
@onready var resources: ResourceManagement = $"/root/main/HUD/ResourceBar"
@onready var spawnMarker: Sprite2D = $"/root/main/MovableSpawner"


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.set_wait_time(2)
	timer.timeout.connect(_on_timeout)
	timer.start()

	$"/root/main/HUD/Drawer/Node2D/ImageScorer".drawn_sigil.connect(_on_drawn_sigil)


func _process(_delta: float) -> void:
	pass

func spawn_entity(entity: PackedScene, spawnPos: Vector2, elementalType = null):
	spawnPos.y = clamp(spawnPos.y, 0, 380)

	var ent: Node2D = entity.instantiate()
	if ent.is_in_group("Enemy"):
		ent.position = spawnPos
		ent.get_node("ElementalAffinityComponent").local_element = elementalType if elementalType else randi_range(0, 4) # randomizes element
		ent.scale *= randf_range(0.5, 3)
		$Enemies.add_child(ent)
		print("enemy")

	elif ent.is_in_group("Friendly"):
		if resources.spend_resource(ent.get_node("StatBlockComponent").spawn_cost):
			ent.position = spawnPos
			ent.get_node("ElementalAffinityComponent").local_element = elementalType if elementalType else randi_range(0, 4) # randomizes element
			$Friendlies.add_child(ent)
			print("friendly")
	else:
		print("nothing")


func _on_timeout():
	var enemySpawnPosY: int = randi_range(0, get_viewport_rect().size.y)
	spawn_entity(enemyEntity, Vector2(enemySpawnPosX, enemySpawnPosY))
	timer.start()


func _on_drawn_sigil(elementalType: ElementalAffinityComponent.ElementType):
	spawn_entity(friendlyEntity, spawnMarker.position, elementalType)
	
	
