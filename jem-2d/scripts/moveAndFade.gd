extends Node2D

@export var fadePercent: float

@onready
var timerComponent: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	timerComponent.timeout.connect(queue_free)
	timerComponent.start()
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
var slower = 0
func _process(delta):
	modulate.a -= delta * fadePercent
	pass
