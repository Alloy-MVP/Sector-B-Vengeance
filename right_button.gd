extends StaticBody3D

@onready var Right_Door = $"../Right Door"
@onready var right_door_position: Vector3 = Right_Door.position
@onready var player_camera = $"../../../Player/Player_Camera"

var open_door: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interact()

func interact():
	var right_door_tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	var right_door_slide: Vector3
	if open_door:
		right_door_slide = right_door_position + Vector3(0, 4, 0)
	else:
		right_door_slide = right_door_position
	
	right_door_tween.tween_property(Right_Door, "position", right_door_slide, 0.6)
	await right_door_tween.finished
	
	if not open_door:
		player_camera.door_shake()
	open_door = not open_door


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
