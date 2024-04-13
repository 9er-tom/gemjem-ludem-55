class_name HealthComponent
extends TextureProgressBar

# Assuming health is directly proportional to sprite size
@export var health_per_inch = 10  # Adjust this value as needed

func _ready():
	var scale: Vector2 = get_parent().scale
	# Calculate health based on sprite size
	max_value = scale.length() * health_per_inch
	value = max_value
	print("Calculated health_points: ", max_value)


func damage(damage_points):
	value -= damage_points
	visible = true
	
func heal(heal_points):
	value += heal_points
	if value >= max_value:
		visible = false
