extends CanvasLayer


@onready var fov_label = $Control/TabContainer/Video/FOV/Label
@onready var brightness_label = $Control/TabContainer/Video/Brightness/Label
@onready var downscaling_label = $Control/TabContainer/Graphics/Downscaling/Label
@onready var background_environment = get_tree().get_first_node_in_group("Ambient Lighting")

var config = ConfigFile.new()
var config_path = "user://config.cfg"
var master_config_path = "res://config.cfg"

var fullscreen: bool
var vsync: bool
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
var FOV
var brightness

var fog: bool
var glow: bool
var ambient_occlusion: bool # adds shadows to corners
var downscaling_resolution
var anisotropic_filtering_list = ["Disabled",2,4,8,16]
var selected_af # requires restart!!!



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false
	if not FileAccess.file_exists(config_path):
		DirAccess.copy_absolute(master_config_path, config_path)
	
	config.load(config_path)
	
	fullscreen = config.get_value("VIDEO","fullscreen")
	vsync = config.get_value("VIDEO","vsync")
	selected_resolution = config.get_value("VIDEO","selected_resolution")
	max_framerate = config.get_value("VIDEO","max_framerate")
	FOV = config.get_value("VIDEO","FOV")
	brightness = config.get_value("VIDEO","brightness")
	
	fog = config.get_value("GRAPHICS","fog")
	glow = config.get_value("GRAPHICS","glow")
	ambient_occlusion = config.get_value("GRAPHICS","ambient_occlusion")
	downscaling_resolution = config.get_value("GRAPHICS","downscaling_resolution")
	selected_af = config.get_value("GRAPHICS","selected_af")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass





# Video settings

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

func _on_fov_value_changed(value: float) -> void:
	FOV = value
	var f = str(int(FOV))
	fov_label.text = "FOV: " + f

func _on_brightness_value_changed(value: float) -> void:
	brightness = value
	var bl = str((int(brightness*100)/2))
	brightness_label.text = "Brightness: " + bl + "%"
	
func _on_downscaling_value_changed(value: float) -> void:
	downscaling_resolution = value
	var dl = str(int(downscaling_resolution*100))
	downscaling_label.text = "Resolution: " + dl + "%"





# Graphics settings

func _on_fog_toggled(toggled_on: bool) -> void:
	if toggled_on:
		fog = true
	if not toggled_on:
		fog = false

func _on_glow_toggled(toggled_on: bool) -> void:
	if toggled_on:
		glow = true
	if not toggled_on:
		glow = false
		
func _on_ambient_occlusion_toggled(toggled_on: bool) -> void:
	if toggled_on:
		ambient_occlusion = true
	if not toggled_on:
		ambient_occlusion = false

func _on_anisotropic_filtering_item_selected(index: int) -> void:
	selected_af = anisotropic_filtering_list[index]








func _on_save_pressed() -> void:
	# saves to config file
	config.set_value("VIDEO","fullscreen",fullscreen)
	config.set_value("VIDEO","vsync",vsync)
	config.set_value("VIDEO","selected_resolution",selected_resolution)
	config.set_value("VIDEO","max_framerate",max_framerate)
	config.set_value("VIDEO","FOV",FOV)
	config.set_value("VIDEO","brightness",brightness)
	
	config.set_value("GRAPHICS","fog",fog)
	config.set_value("GRAPHICS","glow",glow)
	config.set_value("GRAPHICS","ambient_occlusion",ambient_occlusion)
	config.set_value("GRAPHICS","downscaling_resolution",downscaling_resolution)
	config.set_value("GRAPHICS","selected_af",selected_af)
	
	config.save(config_path)
	
	
	
	
	
	# Video settings
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
	
	if FOV != null:
		get_tree().get_first_node_in_group("Player Camera").fov = FOV
		FOV = null
		
	if brightness != null:
		background_environment.environment.background_energy_multiplier = brightness
		brightness = null
		
	if downscaling_resolution != null:
		get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR
		get_viewport().scaling_3d_scale = downscaling_resolution
		downscaling_resolution = null
		
	
	# Graphics settings
	if fog:
		background_environment.environment.fog_enabled = true
	if not fog:
		background_environment.environment.fog_enabled = false
		
	if glow:
		background_environment.environment.glow_enabled = true
	if not glow:
		background_environment.environment.glow_enabled = false
	
	if ambient_occlusion:
		background_environment.environment.ssao_enabled = true
	if not ambient_occlusion:
		background_environment.environment.ssao_enabled = false
	
	if selected_af != null:
		ProjectSettings.set_setting("rendering/textures/default_filters/anisotropic_filtering_level", selected_af)
		selected_af = null
