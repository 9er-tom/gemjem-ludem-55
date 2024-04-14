class_name KillComponent extends Node2D

@onready var body: CharacterBody2D = get_parent()
@onready var animState: AnimationStateComponent = $"../AnimationStateComponent"
@onready var resourceManagement: ResourceManagement = $"/root/main/HUD/ResourceBar"
@onready var gameScore: GameScore = $"/root/main/HUD/GameScore"
@onready var statBlock: StatBlockComponent = $"../StatBlockComponent"
	
func kill():
	# enemies give resources on death
	if body.is_in_group("Enemy"):
		resourceManagement.gain_resource(statBlock.resource_on_death)
		gameScore.increas_score(body.scale.x)
	# disable body collission so they don't keep beating up the corpse until it despawns
	body.set_collision_layer(0)
	animState.currentState = AnimationStateComponent.AnimationState.DEATH
	
