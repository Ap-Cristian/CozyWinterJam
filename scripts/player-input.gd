extends CharacterBody3D

const SPEED = 20.0
const JUMP_VELOCITY = 4.5
const DEV = true

@onready var camera = get_parent().get_child(1);

func getMousePos() -> Vector2:
	return get_viewport().get_mouse_position()
	
func mouseToWorldCoords() -> void:
	var mousePos = getMousePos()

func _unhandled_input(event: InputEvent) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	#if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		#self.rotate_y(-event.relative.x * 0.01)
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
 
	var space_state = get_world_3d().direct_space_state
	var mousePos = getMousePos()
	var rayOrigin = camera.project_ray_origin(mousePos)
	var rayEnd = rayOrigin + camera.project_ray_normal(mousePos) * 2000
	var intersection = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(rayOrigin, rayEnd))

	if not intersection.is_empty():
		var pos = intersection.position
		$".".look_at(Vector3(pos.x, pos.y, pos.z), Vector3(0,1,0))
