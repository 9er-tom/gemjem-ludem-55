extends Label


func _ready():
	get_parent().value_changed.connect(_on_value_changed)
	
func _on_value_changed(value: float):
	text = "%s" % value
