extends CanvasLayer

@onready var fps = $Player_GUI_Control/FPS
@onready var Pause_GUI = $"../Pause_GUI"

var paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = true

func options_to_pause():
	Options.visible = false
	self.visible = true
	Options.in_options = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if Options.visible:
			Options.visible = false
			Pause_GUI.visible = true
			paused = false
		if paused:
			unpause()
		else:
			pause()

func pause():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if self.visible:
		self.visible = false
	Pause_GUI.visible = true
	get_tree().paused = true
	paused = true

func unpause():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if not self.visible:
		self.visible = true
	Pause_GUI.visible = false
	get_tree().paused = false
	paused = false

func options():
	if paused == true:
		Options.visible = true
		Pause_GUI.visible = false
		Options.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fps.text = "FPS: " + str(Engine.get_frames_per_second())
