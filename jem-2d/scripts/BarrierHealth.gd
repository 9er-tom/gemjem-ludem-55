extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	$"/root/main/Deadzone".barrier_damage_taken.connect(_on_damage_taken)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_damage_taken(damage: int):
	value -= damage
	if value <= 0:
		get_tree().set_pause(true)
		$"../GameOverScreen".show()