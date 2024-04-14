class_name StatBlockComponent extends Node2D


@export var movespeed: int = 100
@export var attackRange: int = 300
@export var attack_damage: int = 1
@export var spawn_cost: int
@export var resource_on_hit: int = 1
@export var resource_on_death: int = 5

## damage multiplier on advantageous elemental affinity
@export var elementalAffinityDamageScaling: float = 1.5  
