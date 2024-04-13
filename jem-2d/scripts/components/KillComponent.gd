class_name KillComponent extends Node2D

@onready var body: Node2D = get_parent()
@onready var animState: AnimationStateComponent = $"../AnimationStateComponent"
	
func kill():
	animState.currentState = AnimationStateComponent.AnimationState.DEATH
	body.queue_free() # todo remove this as soon as we have death animations -> gets handled by animation state machine
	
	
	
