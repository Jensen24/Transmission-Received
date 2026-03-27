extends CharacterBody3D

const SPEED = 2.5
var ladder_array = []

@onready var Neck := $Neck
@onready var camera := $Neck/Camera3D

enum State{
	NORMAL,
	LADDER
}
var current_state = State.NORMAL
func _ready() -> void:
	# Set Mouse Invisible
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if current_state == State.LADDER:
		velocity = Vector3.ZERO
		var input_climb := Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
		# Y axis movement
		velocity.y = input_climb * SPEED  
		move_and_slide()
		return

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (Neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			Neck.rotate_y(-event.relative.x * 0.005)
			camera.rotate_x(-event.relative.y * 0.005)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))
