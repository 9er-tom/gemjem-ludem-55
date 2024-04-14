class_name GameScore extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	text= text.c_escape()
	text = text.replace("\\r\\n", "\n")
	text = text.c_unescape()
	pass # Replace with function body.


var score = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	text = "Score: " + str(int(score))
	pass

func increas_score(value):
	score += value

func reset_score():
	score = 0;