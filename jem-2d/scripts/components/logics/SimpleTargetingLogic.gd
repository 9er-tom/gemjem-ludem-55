class_name SimpleTargetingLogic
extends Node2D

@onready var body: CharacterBody2D = get_parent()
@onready var enemyDetection: EntityDetectionComponent = get_node("../EntityDetectionComponent")
@onready var sprite: AnimatedSprite2D = get_node("../AnimatedSprite2D")
@onready var targetingGizmo: Line2D = $"../TargetingGizmo"
@onready var animState: AnimationStateComponent = $"../AnimationStateComponent"
@onready var statBlock: StatBlockComponent = $"../StatBlockComponent"
@onready var killComponent: KillComponent = $"../KillComponent"
@onready var elementalAffinity: ElementalAffinityComponent = $"../ElementalAffinityComponent"
@onready var defaultDirection: Vector2 = Vector2.RIGHT if body.is_in_group("Friendly") else Vector2.LEFT

var closestTarget: Node2D = null


func _ready() -> void:
    targetingGizmo.points[1].x = statBlock.attackRange
    sprite.animation_finished.connect(_on_animation_finished)
    sprite.set_flip_h(defaultDirection == Vector2.LEFT)


func _process(delta: float) -> void:
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

    if animState.currentState == AnimationStateComponent.AnimationState.DEATH:
        return

    closestTarget = enemyDetection.scan_for_target()

    animState.currentState = AnimationStateComponent.AnimationState.WALK
    # if target is found
    if closestTarget != null:
        targetingGizmo.points[1] = closestTarget.global_position - body.global_position
        targetingGizmo.show()
        body.velocity = (closestTarget.position - body.position).normalized() * statBlock.movespeed # move towards target
        if body.position.distance_to(closestTarget.position) <= statBlock.attackRange:
            sprite.set_flip_h((closestTarget.position.x - body.position.x) < 0) # flip sprite if target stands opposite to default direction
            attack(closestTarget)
    else:
        sprite.set_flip_h(defaultDirection == Vector2.LEFT) # reset sprite flip
        targetingGizmo.hide()
        body.velocity = defaultDirection * statBlock.movespeed
        # friendly units should stop at 2/3 of screen width to wait for approaching enemies
        if body.is_in_group("Friendly"):
            if (body.position.x >= 700) and (body.position.x <= 800):
                body.velocity = Vector2.ZERO
                defaultDirection = Vector2.RIGHT
            elif body.position.x > 800:
                defaultDirection = Vector2.LEFT

    if (body.velocity == Vector2.ZERO) and (animState.currentState != AnimationStateComponent.AnimationState.ATTACK):
        animState.currentState = AnimationStateComponent.AnimationState.IDLE


func _physics_process(_delta: float) -> void:
    if animState.currentState == AnimationStateComponent.AnimationState.DEATH:
        return

    body.move_and_slide()


func attack(target):
    body.velocity = Vector2.ZERO
    animState.currentState = AnimationStateComponent.AnimationState.ATTACK


func _on_animation_finished():
    if sprite.animation == "attack":
        # closestTarget could already be dead and removed when attack animation finishes
        if closestTarget:
            # if affinity is effective, deal 150% damage, otherwise 100%
            var damageScaling: float = 1 if elementalAffinity.calc_affinity(closestTarget) <= 0 else statBlock.elementalAffinityDamageScaling
            closestTarget.get_node("HealthComponent").damage(statBlock.attack_damage * damageScaling)

    if sprite.animation == "death":
        body.queue_free()
