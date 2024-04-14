class_name ElementalAffinityComponent
extends Node2D

enum ElementType {WATER = 0, LIFE = 1, HOLY = 2, NECRO = 3, FIRE = 4}
@export var local_element: ElementType

@onready var coloredIndicator = $ElementIndicator

var affinityMatrix = [
						 [0, -1, 0, 0, 1],
						 [-1, 0, 0, 1, 0],
						 [0, 0, 0, -1, 1],
						 [0, -1, 1, 0, 0],
						 [1, 0, -1, 0, 0]
					 ]


func _ready() -> void:
	match local_element:
		ElementType.NECRO:
			coloredIndicator.modulate =Color.hex(0x230000ff)
		ElementType.HOLY:
			coloredIndicator.modulate =Color.hex(0xffff2fff)
		ElementType.FIRE:
			coloredIndicator.modulate =Color.hex(0xff4d00ff)
		ElementType.WATER:
			coloredIndicator.modulate =Color.hex(0x00cfffff)
		ElementType.LIFE:
			coloredIndicator.modulate =Color.hex(0x14d300ff)


func calc_affinity(target: Node2D):
	var targetAffinity: ElementalAffinityComponent = target.get_node_or_null("ElementalAffinityComponent")
	if targetAffinity:
		var target_element = target.get_node("ElementalAffinityComponent").local_element
		return affinityMatrix[local_element][target_element]
	else:
		push_warning(target, " has no ElementalAffinityComponent")
		return 0
