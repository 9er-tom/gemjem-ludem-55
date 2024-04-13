class_name Friendly
extends Node2D

@onready var body: CharacterBody2D = get_parent()
@onready var enemyDetection: EntityDetectionComponent = get_node("../EntityDetectionComponent")
@onready var sprite: AnimatedSprite2D = get_node("../AnimatedSprite2D")

var defaultDirection: Vector2 = Vector2.RIGHT

@export var movespeed: int = 100


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # enemyDetection.closest_target.connect(_on_closest_target)
    pass


#body.velocity = defaultDirection * defaultSpeed

func _process(delta: float) -> void:
    move_towards(enemyDetection.scan_for_target())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
    body.move_and_slide()
    if body.velocity != Vector2.ZERO:
        sprite.play("walk")
    else:
        sprite.play("idle")


func move_towards(closestTarget: Node2D ) -> void:
    var dir: Vector2 = defaultDirection
    if closestTarget != null:
        dir = (closestTarget.position - body.position).normalized()
    body.velocity = dir * movespeed
