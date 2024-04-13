class_name Friendly
extends Node2D

@onready var body: CharacterBody2D = get_parent()
@onready var enemyDetection: EntityDetectionComponent = get_node("../EntityDetectionComponent")
@onready var sprite: AnimatedSprite2D = get_node("../AnimatedSprite2D")
@onready var attackRangeGizmo: Line2D = $"../AttackRangeGizmo"


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

	if closestTarget != null:
		(closestTarget.position - body.position).normalized() * movespeed
		if body.position.distance_to(closestTarget.position) <= attackRange:
			attack(closestTarget)
	else:
		
		body.velocity = Vector2.RIGHT * movespeed
	body.move_and_slide()
	
	if body.velocity != Vector2.ZERO:
		sprite.play("walk")
		
func attack(target):
	body.velocity = Vector2.ZERO
	sprite.play("attack")

func _on_animation_finished():
	print(sprite.animation)
	if sprite.animation == "attack":
		closestTarget.get_node("Health").damage(attack_damage)
