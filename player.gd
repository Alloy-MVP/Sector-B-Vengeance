extends CharacterBody3D

@onready var Camera_Bobbing = $Camera_Bobbing
@onready var Flashlight = $Player_Camera/Flashlight
@onready var Bonnie = $"../Bonnie"

var SPEED = 5.0
const JUMP_VELOCITY = 4.5
var SPRINTING: bool = false

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_flashlight"):
		Flashlight.visible = not Flashlight.visible


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_pressed("sprint"):
			SPRINTING = true
	else:
		SPRINTING = false
	
	var input_dir = Input.get_vector("left", "right", "forwards", "backwards")
	
	if SPRINTING and input_dir.y < 0:
		SPEED = $"..".Player_Speed
	else:
		SPEED = $"..".Player_Speed - 2
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		if not Camera_Bobbing.is_playing():
			Camera_Bobbing.play("View_Bobbing")
		
		if Input.is_action_pressed("sprint"):
			Camera_Bobbing.speed_scale = 1.7
		else:
			Camera_Bobbing.speed_scale = 1
		
	else:
		Camera_Bobbing.stop()
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
