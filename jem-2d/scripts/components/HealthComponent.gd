class_name HealthComponent
extends Node2D

# Assuming health is directly proportional to sprite size
@export var health_per_pixel = 0.1  # Adjust this value as needed
@export var health_points = 0

func _ready():
	var scale: Vector2 = get_parent().scale
	
	# Calculate health based on sprite size
	health_points = scale.length() * health_per_pixel
	print("Calculated health_points: ", health_points)


func damage(damage_points):
	health_points -= damage_points
	
func heal(heal_points):
	health_points += heal_points
