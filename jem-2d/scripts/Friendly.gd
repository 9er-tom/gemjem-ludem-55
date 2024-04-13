class_name Friendly
extends Node2D

@onready var body: CharacterBody2D = get_parent()
@onready var sprite: AnimatedSprite2D = get_node("../AnimatedSprite2D")

@export var defaultVelocity: Vector2 = Vector2(100, 0)


# Called when the node enters the scene tree for the first time.
func _ready():
	print(body)
	body.velocity = defaultVelocity
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	body.move_and_slide()
	
	if body.velocity != Vector2.ZERO:
		sprite.play("walk")
	else: 
		sprite.play("idle")
