extends Label


func _ready():
	text= text.c_escape()
	text = text.replace("\\r\\n", "\n")
	text = text.c_unescape()