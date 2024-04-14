extends Node2D

@export var friendlyEntity: PackedScene
@export var enemyEntity: PackedScene
@export var enemySpawnPosX: int = 1200
@export var lowestSpawnPoint: int = 300

@onready var timer: Timer = $SpawnTimer
@onready var gameTimer: Timer = $GameTimer
@onready var resources: ResourceManagement = $"/root/main/HUD/ResourceBar"
@onready var spawnMarker: Sprite2D = $"/root/main/MovableSpawner"

var spawnTime = 7
var flatSizeIncrease = 0
var numberOfEnemiesInWave = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	gameTimer.set_wait_time(30)
	gameTimer.timeout.connect(increase_difficulty)
	gameTimer.start()
	timer.set_wait_time(spawnTime)
	timer.timeout.connect(_on_timeout)
	timer.start()

	$"/root/main/HUD/Drawer/Node2D/ImageScorer".drawn_sigil.connect(_on_drawn_sigil)

func increase_difficulty():
	#spawnTime -= 0.3
	flatSizeIncrease += 0.1
	numberOfEnemiesInWave += 1
	timer.set_wait_time(spawnTime)
	gameTimer.start()

	print("D increased")
	pass

func _process(_delta: float) -> void:
	pass

func spawn_entity(entity: PackedScene, spawnPos: Vector2, elementalType = null):
	spawnPos.y = clamp(spawnPos.y, 0, lowestSpawnPoint)

	var ent: Node2D = entity.instantiate()
	if ent.is_in_group("Enemy"):
		ent.position = spawnPos
		ent.get_node("ElementalAffinityComponent").local_element = elementalType if elementalType != null else randi_range(0, 4) # randomizes element
		ent.scale *= custom_random(0.7,3) + flatSizeIncrease
		$Enemies.add_child(ent)
		print("enemy")

	elif ent.is_in_group("Friendly"):
		if resources.spend_resource(ent.get_node("StatBlockComponent").spawn_cost):
			ent.position = spawnPos
			ent.get_node("ElementalAffinityComponent").local_element = elementalType if elementalType != null else randi_range(0, 4) # randomizes element
			$Friendlies.add_child(ent)
			print("friendly")
	else:
		print("nothing")


func _on_timeout():
	spawn_enemies()
	timer.start()


func _on_drawn_sigil(elementalType: ElementalAffinityComponent.ElementType):
	spawn_entity(friendlyEntity, spawnMarker.position, elementalType)
	
	
func spawn_enemies():
	var type = randi_range(0,4)
	for i in range(numberOfEnemiesInWave):
		var enemySpawnPosY: int = randi_range(0, lowestSpawnPoint)
		spawn_entity(enemyEntity, Vector2(enemySpawnPosX + 5*i, enemySpawnPosY), type)


func custom_random(min_val, max_val):
	# Adjust the distribution here according to your bias
	var fullrange = max_val - min_val
	var random_val = randf_range(0, 1) * randf_range(0, 1) * fullrange
	return min_val + random_val
