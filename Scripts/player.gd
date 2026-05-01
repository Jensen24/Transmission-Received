extends CharacterBody3D

const SPEED = 5.5
var ladder_array = []
var is_hovering := false
var inspecting := false
var inspectSource = null
var heldFuse = null
var hasScrewDri = false
var hasKey = false
var inspectedItem: Node3D = null
var rotationSpeed := 0.01
var zoomDistance := -1.0
var zoomMin := -1.2
var zoomMax := -0.5
var zoomSpeed := 0.1

@onready var reticle := $CanvasLayer/CenterContainer/Reticle
@onready var ray := $Neck/Camera3D/RayCast3D
@onready var Neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var inspectCamera := $CanvasLayer/SubViewportContainer/SubViewport/Camera3D
@onready var inspectViewport := $CanvasLayer/SubViewportContainer/SubViewport
@onready var placeholder := $CanvasLayer/SubViewportContainer/SubViewport/InspectHolder
@onready var inspectContainer := $CanvasLayer/SubViewportContainer

enum State{
	NORMAL,
	LADDER
}
var current_state = State.NORMAL
func _ready() -> void:
	# Set Mouse Invisible
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	inspectContainer.visible = false
	reticle.visible = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if current_state == State.LADDER:
		# Disable floor collision while climbing
		set_collision_mask_value(1, false)
		velocity = Vector3.ZERO
		var input_climb := Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
		# Y axis movement
		velocity.y = input_climb * SPEED  
		move_and_slide()
		return
		
	# Toggle collision back on
	set_collision_mask_value(1, true)
	
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
	if inspecting and inspectedItem:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoomDistance += zoomSpeed
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoomDistance -= zoomSpeed
			zoomDistance = clamp(zoomDistance, zoomMin, zoomMax)
			inspectedItem.position.z = lerp(inspectedItem.position.z, zoomDistance, 0.1)

		if event is InputEventMouseMotion and inspectedItem:
			inspectedItem.rotate_y(-event.relative.x * rotationSpeed)
			inspectedItem.rotate_x(-event.relative.y * rotationSpeed)
			
		if event.is_action_pressed("interact"):
			stop_inspect()
		return
	
	if event.is_action_pressed("interact"):
		if inspecting:
			stop_inspect()
		else:
			try_inspect_or_place()
	
	if Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			Neck.rotate_y(-event.relative.x * 0.005)
			camera.rotate_x(-event.relative.y * 0.005)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func try_inspect_or_place():
	if not ray.is_colliding():
		return
		
	var obj = ray.get_collider()
	# Attempt Slot First
	if obj and obj.has_method("interact"):
		obj.interact(self)
		return
	# If not, Inspect
	while obj and not obj.is_in_group("Pickups"):
		obj = obj.get_parent()
	if obj:
		var source = obj.get_parent()
		start_inspect(obj, source)
	
func start_inspect(obj: Node3D, source):
	inspecting = true
	inspectSource = source
	reticle.visible = false
	set_physics_process(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	inspectContainer.visible = true
	inspectCamera.global_transform = camera.global_transform
	inspectedItem = obj.duplicate()
	inspectCamera.add_child(inspectedItem)
	inspectedItem.transform = Transform3D.IDENTITY
	inspectedItem.position = Vector3(0, 0, -1)
	var tween = create_tween()
	tween.tween_property(inspectedItem, "transform:origin", Vector3(0, 0, -1), 0.25)\
	.set_trans(Tween.TRANS_SINE)\
	.set_ease(Tween.EASE_OUT)
	
	inspectedItem.scale = Vector3.ONE * 0.1
	obj.visible = false

func stop_inspect():
	if inspectedItem:
		if inspectedItem.is_in_group("Key"):
			hasKey = true
		elif inspectedItem.is_in_group("Screwdriver"):
			hasScrewDri = true
	
	if inspectSource and inspectSource.has_method("on_inspect_confirmed"):
		inspectSource.on_inspect_confirmed(self)

	inspecting = false
	set_physics_process(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	inspectContainer.visible = false
	if inspectedItem:
		inspectedItem.queue_free()
		inspectedItem = null
	inspectSource = null

func reveal_reticle():
	reticle.visible = true

func hide_reticle():
	reticle.visible = false
