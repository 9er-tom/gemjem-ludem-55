extends Area2D

signal barrier_damage_taken
# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)
	barrier_damage_taken.connect(func x(value): print("barrier damage taken: ", value))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_body_entered(entity: Node2D) -> void:
	print("entered deadzone: ", entity)
	if not entity.is_in_group("Enemy"):
		return
	barrier_damage_taken.emit(entity.get_node("HealthComponent").value)
	entity.get_node("KillComponent").kill()
	
	