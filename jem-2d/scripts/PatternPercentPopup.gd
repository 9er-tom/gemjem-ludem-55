extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_image_scorer_drawn_sigil_percent(percent):
	spawn_floating_label(str(roundi(percent)), Vector2(0, 0))
	pass # Replace with function body.


func spawn_floating_label(text: String, start_position: Vector2):
	var label: Label = Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.position = start_position
	add_child(label)


# Set label properties
	# label.add_font_override("font", preload("res://path_to_your_font.tres"))  # Optional: Set custom font if needed

	# Create a Tween for animation
	var tween = get_tree().create_tween()

	# Move upwards
	var end_position = start_position + Vector2(0, -50) # Adjust Y offset as needed
	tween.tween_property(label, "position", end_position, 2.0)

	# Fade out
	tween.tween_property(label, "modulate", Color(label.modulate.r, label.modulate.g, label.modulate.b, 0), 2.0)
	tween.tween_callback(label.queue_free)
