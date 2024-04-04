extends Node2D


@onready var sprite: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		sprite.set_texture(load("res://assets/img/popcat/pop_1.png"))
	if Input.is_action_just_released("click"):
		sprite.set_texture(load("res://assets/img/popcat/pop_0.png"))
