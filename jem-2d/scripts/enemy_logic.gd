class_name enemy
extends Node2D

@onready var timer: Timer = $"../Timer"
@onready var enemy_body: CharacterBody2D = get_parent()
@onready var animated_sprite_2d: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var entityDetection: EntityDetectionComponent = $"../EntityDetectionComponent"
@onready var attackRangeGizmo: Line2D = $"../AttackRangeGizmo"


# Speed at which the sprite will move
@export var speed = 100
var xdirection = -1
var input_vector = Vector2()
@export var attack_range = 500
@export var attack_damage = 1

var closest_target: Node2D = null

func _ready():
	attackRangeGizmo.points[1].x = attack_range
	enemy_body.scale.x = enemy_body.scale.x * xdirection
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)
	print(animated_sprite_2d)
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _physics_process(delta):
	# Move the character and slide along collisions
	if closest_target != null:
		rushtarget(closest_target)
		if enemy_body.position.distance_to(closest_target.position) <= attack_range:
			attack()
	else:
		rushb()
	enemy_body.move_and_slide()

func _process(delta: float) -> void:
	closest_target = entityDetection.scan_for_target()

func _on_timer_timeout():
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h # Flip the sprite horizontally

func rushb():
	input_vector.x = xdirection
	input_vector.y = 0
	enemy_body.velocity = input_vector * speed
	
func rushtarget(target):
	var target_position = target.global_position
	var direction = (target_position - enemy_body.global_position).normalized()
	enemy_body.velocity = direction * speed
	# Rotate your character to face the target
	enemy_body.rotation = atan2(direction.y, direction.x)
	
func attack():
	enemy_body.velocity = Vector2.ZERO
	animated_sprite_2d.play("attack")
	timer.stop()

func _on_animation_finished():
	print(animated_sprite_2d.animation)
	if animated_sprite_2d.animation == "attack":
		closest_target.get_node("Health").damage(attack_damage)
