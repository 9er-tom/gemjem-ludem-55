extends Node2D


@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		sprite.set_texture(load("res://assets/img/popcat/pop_1.png") as Texture2D)
	if Input.is_action_just_released("click"):
		sprite.set_texture(load("res://assets/img/popcat/pop_0.png") as Texture2D)
