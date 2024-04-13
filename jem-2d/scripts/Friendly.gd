class_name Friendly
extends Node2D

@onready var body: CharacterBody2D = get_parent()
@onready var enemyDetection: EntityDetectionComponent = get_node("../EntityDetectionComponent")
@onready var sprite: AnimatedSprite2D = get_node("../AnimatedSprite2D")
@onready var attackRangeGizmo: Line2D = $"../AttackRangeGizmo"
@onready var animState: AnimationStateComponent = $"../AnimationStateComponent"

var defaultDirection: Vector2 = Vector2.RIGHT
var closestTarget: Node2D     = null

@export var movespeed: int = 100
@export var attackRange: int = 300
@export var attack_damage: int = 1



func _ready() -> void:
	attackRangeGizmo.points[1].x = attackRange
	sprite.animation_finished.connect(_on_animation_finished)


func _process(delta: float) -> void:
	closestTarget = enemyDetection.scan_for_target()


func _physics_process(_delta: float) -> void:

	# if target is found
	if closestTarget != null:
		(closestTarget.position - body.position).normalized() * movespeed
		if body.position.distance_to(closestTarget.position) <= attackRange:
			attack(closestTarget)
	else:
		body.velocity = Vector2.RIGHT * movespeed if body.position.x < 750 else Vector2.ZERO
	body.move_and_slide()

	if body.velocity != Vector2.ZERO:
		animState.currentState = AnimationStateComponent.AnimationState.WALK
	elif animState.currentState != AnimationStateComponent.AnimationState.ATTACK:
		animState.currentState = AnimationStateComponent.AnimationState.IDLE

	match animState.currentState:
		AnimationStateComponent.AnimationState.WALK:
			sprite.play("walk")
		AnimationStateComponent.AnimationState.ATTACK:
			sprite.play("attack")
		AnimationStateComponent.AnimationState.IDLE:
			sprite.play("idle")
		AnimationStateComponent.AnimationState.DEATH:
			pass
		AnimationStateComponent.AnimationState.SPAWN:
			pass
		
func attack(target):
	body.velocity = Vector2.ZERO
	animState.currentState = AnimationStateComponent.AnimationState.ATTACK

func _on_animation_finished():
	if sprite.animation == "attack":
		closestTarget.get_node("HealthComponent").damage(attack_damage)
		
	if sprite.animation == "death":
		body.queue_free()