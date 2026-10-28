extends StaticBody3D

@onready var Left_Door = $"../Left Door"
@onready var left_door_position: Vector3 = Left_Door.position
@onready var player_camera = $"../../../Player/Player_Camera"

var open_door: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interact()

func interact():
	var left_door_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	var left_door_slide: Vector3
	if open_door:
		left_door_slide = left_door_position + Vector3(0, 4, 0)
	else:
		left_door_slide = left_door_position
	
	left_door_tween.tween_property(Left_Door, "position", left_door_slide, 0.6)
	await left_door_tween.finished
	
	if not open_door:
		player_camera.door_shake()
	open_door = not open_door

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
