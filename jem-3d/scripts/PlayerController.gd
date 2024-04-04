extends CharacterBody3D

@onready var camera_mount = $camera_mount2
@onready var camera_3d = $camera_mount2/Camera3D

@export var mouse_sensitivity_hor = 0.5
@export var mouse_sensitivity_ver = 0.5



var SPEED = 1
@export var walking_speed = 5.0
@export var running_speed = 8.0

@export var jump_force = 4.5
@export var mass = 3

var fov = 90

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	fov = camera_3d.fov

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*mouse_sensitivity_hor))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y*mouse_sensitivity_ver))
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
		
func _physics_process(delta):
	if Input.is_action_just_pressed("menu"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_pressed("run"):
		SPEED = running_speed
		camera_3d.fov = fov * 1.05
	else:
		SPEED = walking_speed
		camera_3d.fov = fov
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta * mass

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
