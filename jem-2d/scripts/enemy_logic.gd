class_name enemy
extends Node

@onready var enemy_body = $"../.."
@onready var animated_sprite_2d = $".."

# Speed at which the sprite will move
var speed = 100
var xdirection = -1
var input_vector = Vector2()

var detectionRange : Area2D
signal closest_target

func _ready():
	# Get the Timer node and connect its timeout signal to this script
	$"../../Timer".start()
	enemy_body.scale.x = enemy_body.scale.x * xdirection
	detectionRange.body_entered.connect(_on_body_entered)
	detectionRange.body_exited.connect(_on_body_exited)


func _physics_process(delta):
	# Apply the movement vector to the velocity
	
	# Move the character and slide along collisions
	enemy_body.move_and_slide()


func _on_timer_timeout():
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h # Flip the sprite horizontally
	
func _on_body_entered():
	rushtarget(closest_target)
	
func _on_body_exited():
	if closest_target != null:
		rushb()
	
func rushb():
	input_vector.x = xdirection
	input_vector.y = 0
	
func rushtarget(target):
	var target_position = target.global_position
	var direction = (target_position - enemy_body.global_position).normalized()
	enemy_body.velocity = direction * speed
	# Rotate your character to face the target
	enemy_body.rotation = atan2(direction.y, direction.x)
