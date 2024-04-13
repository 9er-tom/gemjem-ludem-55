class_name EntityDetectionComponent
extends Node2D

@onready var body: CharacterBody2D = get_parent()
@onready var detectionRange: Area2D = $Area2D
@export_enum("Enemy", "Friendly") var detectionTarget: String

var nearbyEntities: Array[Node2D] = []
var closestEntity: Node2D         = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detectionRange.body_entered.connect(_on_body_entered)
	detectionRange.body_exited.connect(_on_body_exited)

func scan_for_target() -> Node2D:
	if nearbyEntities.size() != 0:
		closestEntity = nearbyEntities[0]
		for entity in nearbyEntities:
			if body.position.distance_to(entity.position) < body.position.distance_to(closestEntity.position):
				closestEntity = entity
		 #todo remove on kill
	else:
		closestEntity = null
	return closestEntity


func _on_body_entered(entity: Node2D) -> void:
	print(entity, " entered")
	if not entity.has_node(detectionTarget):
		return
	nearbyEntities.append(entity)


func _on_body_exited(entity: Node2D) -> void:
	print(entity, " exited")

	if not entity.has_node(detectionTarget):
		return
	nearbyEntities.remove_at(nearbyEntities.find(entity))
