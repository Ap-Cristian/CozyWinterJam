extends CharacterBody3D
 
const SPEED = 800.0
const JUMP_VELOCITY = 4.5
const DEV = true

var can_bop_up_and_down = false;

@onready var camera = $"Camera3D";
@onready var fire = $"../../Fire";

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion and not fire.are_we_dead_uwu():
			camera.rotation.x = clampf(camera.rotation.x - event.relative.y * 0.01, -1.5, 1.5);
			self.rotate_y(-event.relative.x * 0.01);
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if is_on_floor():
		can_bop_up_and_down = true;
	else:
		velocity += get_gravity() * delta
		
	if fire.are_we_dead_uwu():
		return;

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * (delta * SPEED);
		velocity.z = direction.z * (delta * SPEED);
		if position.y < -4.6:
			if can_bop_up_and_down:
				velocity.y = 30 * delta;
		else:
			can_bop_up_and_down = false;
	else:
		velocity.x = move_toward(velocity.x, 0, delta * (SPEED / 5))
		velocity.z = move_toward(velocity.z, 0, delta * (SPEED / 5))

	move_and_slide()
 
