extends CharacterBody3D


@onready var camera = $Camera3D

@export var move_speed = 10
@export var sprint_mult = 1.2
@export var gravity = 100
@export var mouse_sensitivity = 0.01

var camera_rotation = Vector2.ZERO
var use_camera = true

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if Input.is_action_just_pressed("Esc"):
		if (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			use_camera = false
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			use_camera = true
	
	if event is InputEventMouseMotion && use_camera:
		var mouse_event = event.relative * mouse_sensitivity
		camera_rotation += mouse_event
		transform.basis = Basis()
		camera.transform.basis = Basis()
		rotate(Vector3(0,1,0), -camera_rotation.x)			# Rotates x
		camera.rotate_object_local(Vector3(1,0,0), -camera_rotation.y) 	# Rotates y

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)

	move_and_slide()
