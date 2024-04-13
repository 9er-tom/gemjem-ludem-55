class_name EntityDetectionComponent
extends Node2D

@onready var body: CharacterBody2D = get_parent()
@onready var detectionRange: Area2D = $Area2D

@export_enum("Enemy", "Friendly") var detectionTarget: String

var nearbyEntities: Array[Node2D] = []
var closestEntity: Node2D         = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass


func scan_for_target() -> Node2D:
    nearbyEntities = detectionRange.get_overlapping_bodies().filter(func targetsOnly(collider: Node2D): return collider.has_node(detectionTarget))
    print(nearbyEntities)
    if nearbyEntities.size() != 0:
        closestEntity = nearbyEntities[0]
        for entity in nearbyEntities:
            if body.position.distance_to(entity.position) < body.position.distance_to(closestEntity.position):
                closestEntity = entity
    else:
        closestEntity = null
    return closestEntity