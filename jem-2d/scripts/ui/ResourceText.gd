extends Label


func _ready():
	text= text.c_escape()
	text = text.replace("\\r\\n", "\n")
	text = text.c_unescape()
	get_parent().value_changed.connect(_on_value_changed)
	
func _on_value_changed(value: float):
	text = "%s" % value
