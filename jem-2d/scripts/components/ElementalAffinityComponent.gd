class_name ElementalAffinityComponent
extends Node

enum ElementType {WATER = 0, LIFE = 1, HOLY = 2, NECRO = 3, FIRE = 4}
@export var element: ElementType

var affinityMatrix = [
						 [0, -1, 0, 0, 1],
						 [-1, 0, 0, 1, 0],
						 [0, 0, 0, -1, 1],
						 [0, -1, 1, 0, 0],
						 [1, 0, -1, 0, 0]
					 ]


func calc_affinity(source: ElementType, target: ElementType):
	return affinityMatrix[source][target]
