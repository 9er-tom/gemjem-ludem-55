class_name enemy
extends Node2D

@onready var timer: Timer = $"../Timer"
@onready var enemy_body: CharacterBody2D = get_parent()
@onready var sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var entityDetection: EntityDetectionComponent = $"../EntityDetectionComponent"
@onready var attackRangeGizmo: Line2D = $"../AttackRangeGizmo"
@onready var animState: AnimationStateComponent = $"../AnimationStateComponent"


# Speed at which the sprite will move
@export var speed = 100
var xdirection = -1
var input_vector = Vector2()
@export var attack_range = 500
@export var attack_damage = 1

var closest_target: Node2D = null

func _ready():
	attackRangeGizmo.points[1].x = attack_range
	enemy_body.scale.x = enemy_body.scale.x * xdirection
	sprite.animation_finished.connect(_on_animation_finished)
#	timer.timeout.connect(_on_timer_timeout)
#	timer.start()

func _physics_process(delta):
	if animState.currentState == AnimationStateComponent.AnimationState.DEATH:
		return
		
	# Move the character and slide along collisions
	if closest_target != null:
		rushtarget(closest_target)
		if enemy_body.position.distance_to(closest_target.position) <= attack_range:
			attack()
	else:
		rushb()
	enemy_body.move_and_slide()

	if enemy_body.velocity != Vector2.ZERO:
		animState.currentState = AnimationStateComponent.AnimationState.WALK
	elif animState.currentState != AnimationStateComponent.AnimationState.ATTACK:
		animState.currentState = AnimationStateComponent.AnimationState.IDLE

func _process(delta: float) -> void:
	closest_target = entityDetection.scan_for_target()

	match animState.currentState:
		AnimationStateComponent.AnimationState.WALK:
			sprite.play("walk")
		AnimationStateComponent.AnimationState.ATTACK:
			sprite.play("attack")
		AnimationStateComponent.AnimationState.IDLE:
			sprite.play("idle")
		AnimationStateComponent.AnimationState.DEATH:
			sprite.play("death")
		AnimationStateComponent.AnimationState.SPAWN:
			pass

func _on_timer_timeout():
	sprite.flip_h = !sprite.flip_h # Flip the sprite horizontally

func rushb():
	input_vector.x = xdirection
	input_vector.y = 0
	enemy_body.velocity = input_vector * speed
	
func rushtarget(target):
	var target_position = target.global_position
	var direction = (target_position - enemy_body.global_position).normalized()
	enemy_body.velocity = direction * speed
	# Rotate your character to face the target
	enemy_body.rotation = atan2(direction.y, direction.x)
	
func attack():
	enemy_body.velocity = Vector2.ZERO
	animState.currentState = animState.AnimationState.ATTACK
	#timer.stop()

func _on_animation_finished():
	if sprite.animation == "attack":
		# closestTarget could already be dead and removed when attack animation finishes
		if closest_target:
			closest_target.get_node("HealthComponent").damage(attack_damage)
		
	if sprite.animation == "death":
		# kill yourself B)
		enemy_body.queue_free()
