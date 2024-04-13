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


func _ready() -> void:
	attackRangeGizmo.points[1].x = attackRange

func _process(delta: float) -> void:
	closestTarget = enemyDetection.scan_for_target()

func _physics_process(_delta: float) -> void:

	if closestTarget != null:
		(closestTarget.position - body.position).normalized() * movespeed
		if body.position.distance_to(closestTarget.position) <= attackRange:
			body.velocity = Vector2.ZERO
			sprite.play("attack")
	else:
		
		body.velocity = Vector2.RIGHT * movespeed
	body.move_and_slide()
	
	if body.velocity != Vector2.ZERO:
		sprite.play("walk")

