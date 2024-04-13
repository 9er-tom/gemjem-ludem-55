class_name health
extends Node


# Assuming health is directly proportional to sprite size
var health_per_pixel = 0.1  # Adjust this value as needed
var health_points = 0

func _ready():
	var sprite = get_parent().get_parent().get_parent()
	
	# Calculate health based on sprite size
	health_points = sprite.scale.length() * health_per_pixel
	print("Calculated health_points: ", health_points)


func damage(damage_points):
	health_points -= damage_points
	
func heal(heal_points):
	health_points += heal_points
