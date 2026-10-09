extends CanvasLayer

@onready var Player_GUI = $"../Player_GUI"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	Player_GUI.unpause()


func _on_options_pressed() -> void:
	Player_GUI.options()


func _on_main_menu_pressed() -> void:
	get_tree().quit()
