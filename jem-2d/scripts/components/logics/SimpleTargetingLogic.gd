class_name SimpleTargetingLogic
extends Node2D

@onready var body: CharacterBody2D = get_parent()
@onready var enemyDetection: EntityDetectionComponent = get_node("../EntityDetectionComponent")
@onready var sprite: AnimatedSprite2D = get_node("../AnimatedSprite2D")
@onready var attackRangeGizmo: Line2D = $"../AttackRangeGizmo"
@onready var animState: AnimationStateComponent = $"../AnimationStateComponent"
@onready var statBlock: StatBlockComponent = $"../StatBlockComponent"
@onready var killComponent: KillComponent = $"../KillComponent"
@onready var defaultDirection: Vector2 = Vector2.RIGHT if body.is_in_group("Friendly") else Vector2.LEFT

var closestTarget: Node2D = null


func _ready() -> void:
    attackRangeGizmo.points[1].x = statBlock.attackRange
    sprite.animation_finished.connect(_on_animation_finished)
    if defaultDirection == Vector2.LEFT:
        sprite.set_flip_h(true)


func _process(delta: float) -> void:
    closestTarget = enemyDetection.scan_for_target()

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


func _physics_process(_delta: float) -> void:
    if animState.currentState == AnimationStateComponent.AnimationState.DEATH:
        return

    # if target is found
    if closestTarget != null:
        (closestTarget.position - body.position).normalized() * statBlock.movespeed
        if body.position.distance_to(closestTarget.position) <= statBlock.attackRange:
            sprite.set_flip_h((closestTarget.position.x - body.position.x) < 0) # flip sprite if target stands opposite to default direction
            attack(closestTarget)
    else:
        body.velocity = defaultDirection * statBlock.movespeed
        # friendly units should stop at 2/3 of screen width to wait for approaching enemies
        if body.is_in_group("Friendly") and body.position.x >= 1000: # get_viewport_rect().size.x * (2/3):
            body.velocity = Vector2.ZERO

    body.move_and_slide()

    if body.velocity != Vector2.ZERO:
        animState.currentState = AnimationStateComponent.AnimationState.WALK
    elif animState.currentState != AnimationStateComponent.AnimationState.ATTACK:
        animState.currentState = AnimationStateComponent.AnimationState.IDLE


func attack(target):
    body.velocity = Vector2.ZERO
    animState.currentState = AnimationStateComponent.AnimationState.ATTACK


func _on_animation_finished():
    if sprite.animation == "attack":
        # closestTarget could already be dead and removed when attack animation finishes
        if closestTarget:
            closestTarget.get_node("HealthComponent").damage(statBlock.attack_damage)

    if sprite.animation == "death":
        body.queue_free()