extends Sprite2D

@export var movespeed: int = 5
	
func _physics_process(_delta: float) -> void:
	position += Input.get_vector("left", "right", "up", "down") * movespeed
	position.x = clamp(position.x, 130, 250)
	position.y = clamp(position.y, 0 + texture.get_height() * scale.y / 2, 385)


