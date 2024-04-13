class_name KillComponent extends Node2D

@onready var body: CharacterBody2D = get_parent()
@onready var animState: AnimationStateComponent = $"../AnimationStateComponent"
	
func kill():
	# disable body collission so they don't keep beating up the corpse until it despawns
	body.set_collision_layer(0)
	animState.currentState = AnimationStateComponent.AnimationState.DEATH
	
