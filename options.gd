extends CanvasLayer


var fullscreen: bool = false
var vsync: bool = true
var resolution_list = [
	Vector2i(800,600),
	Vector2i(1024,600),
	Vector2i(1600,900),
	Vector2i(1440,900),
	Vector2i(1280,720),
	Vector2i(1536,864),
	Vector2i(1366,780),
	Vector2i(1920,1080),
	Vector2i(2560,1440),
	Vector2i(3840,2160)
	]
var selected_resolution
var max_framerate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func Fullscreen_Toggle(fullscreen_toggle: bool) -> void:
	if fullscreen_toggle:
		fullscreen = true
	elif not fullscreen_toggle:
		fullscreen = false

func _on_v_sync_toggled(toggled_on: bool) -> void:
	if toggled_on:
		vsync = true
	elif not toggled_on:
		vsync = false

func _on_resolution_item_selected(index: int) -> void:
	selected_resolution = resolution_list[index]

func _on_max_framerate_value_changed(value: float) -> void:
	max_framerate = value


func _on_save_pressed() -> void:
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if not fullscreen:
		if selected_resolution != null:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(selected_resolution)
			selected_resolution = null
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	
	if vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	if not vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	if max_framerate != null:
		Engine.max_fps = max_framerate
		max_framerate = null
		
		
		
		
		
		
