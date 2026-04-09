extends CharacterBody3D

const SPEED = 5.5
var ladder_array = []
var is_hovering := false
var inspecting := false
var inspectedItem: Node3D = null
var rotationSpeed := 0.01
var zoomDistance := 0.7
var zoomMin := -0.3
var zoomMax := 1.4
var zoomSpeed := 0.1

@onready var placeholder := $Neck/Camera3D/InspectHolder
@onready var reticle := $CanvasLayer/CenterContainer/Reticle
@onready var ray := $Neck/Camera3D/RayCast3D
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
	reticle.visible = false

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
		
	if ray.is_colliding():
		var obj = ray.get_collider()
		
		while obj and not obj.is_in_group("Pickups"):
			obj = obj.get_parent()
		
		if obj:
			if !is_hovering:
				is_hovering = true
				reveal_reticle()
		else:
			if is_hovering:
				is_hovering = false
				hide_reticle()
	else:
		if is_hovering:
			is_hovering = false
			hide_reticle()

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
	if inspecting and placeholder:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoomDistance += zoomSpeed
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoomDistance -= zoomSpeed
			zoomDistance = clamp(zoomDistance, zoomMin, zoomMax)
			placeholder.position.z = lerp(placeholder.position.z, zoomDistance, 0.1)

		if event is InputEventMouseMotion and inspectedItem:
			inspectedItem.rotate_y(-event.relative.x * rotationSpeed)
			inspectedItem.rotate_x(-event.relative.y * rotationSpeed)
			
		if event.is_action_pressed("interact"):
			stop_inspect()
		return
	
	if event.is_action_pressed("interact"):
		try_inspect()
	
	if Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			Neck.rotate_y(-event.relative.x * 0.005)
			camera.rotate_x(-event.relative.y * 0.005)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func try_inspect():
	if not ray.is_colliding():
		return
	var obj = ray.get_collider()
	while obj and not obj.is_in_group("Pickups"):
		obj = obj.get_parent()
	if obj:
		start_inspect(obj)
	
func start_inspect(obj: Node3D):
	inspecting = true
	reticle.visible = false
	set_physics_process(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	inspectedItem = obj.duplicate()
	placeholder.add_child(inspectedItem)
	inspectedItem.transform.origin = Vector3(0, 0, -3)
	var tween = create_tween()
	tween.tween_property(inspectedItem, "transform:origin", Vector3(0, 0, -2), 0.25)\
	.set_trans(Tween.TRANS_SINE)\
	.set_ease(Tween.EASE_OUT)
	
	inspectedItem.scale = Vector3.ONE * 0.1
	obj.visible = false

func stop_inspect():
	inspecting = false
	set_physics_process(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if inspectedItem:
		inspectedItem.queue_free()
		inspectedItem = null

func reveal_reticle():
	reticle.visible = true

func hide_reticle():
	reticle.visible = false
