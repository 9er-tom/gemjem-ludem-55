class_name enemy
extends Node

@onready var animated_sprite_2d = get_parent();

# Speed at which the sprite will move
var speed = 100

func _ready():
	# Get the Timer node and connect its timeout signal to this script
	$"../Timer".start()

func _process(delta):
	var velocity = Vector2() # The sprite's movement vector

	velocity.x += 1
	animated_sprite_2d.play() # Replace "walk" with your walking animation name

	velocity = velocity.normalized() * speed
	animated_sprite_2d.position += velocity * delta


func _on_timer_timeout():
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h # Flip the sprite horizontally
