extends Node3D

@onready var Bonnie = $Bonnie
@onready var Freddy = $Freddy
@onready var Foxy = $Foxy
@onready var GUI = $Player_GUI

var Bonnie_Chasing_Speed: float = 5.0
var Freddy_Chasing_Speed: float = 5.0
var Foxy_Chasing_Speed: float = 5.0
var Player_Speed: float = 10.0
var frozen: bool = false

func _ready() -> void:
	Bonnie.process_mode = Node.PROCESS_MODE_DISABLED
	Freddy.process_mode = Node.PROCESS_MODE_DISABLED
	Foxy.process_mode = Node.PROCESS_MODE_DISABLED
	night4()


func night1(): #Bonnie (5)
	Player_Speed = 7
	Bonnie.process_mode = Node.PROCESS_MODE_INHERIT
	Bonnie_Chasing_Speed = 5.0

func night2(): #Freddy (7)
	Player_Speed = 9
	Freddy.process_mode = Node.PROCESS_MODE_INHERIT
	Freddy_Chasing_Speed = 7.0 
	
func night3(): #Bonnie (7) Freddy (7)
	Player_Speed = 9
	Bonnie.process_mode = Node.PROCESS_MODE_INHERIT
	Freddy.process_mode = Node.PROCESS_MODE_INHERIT
	Bonnie_Chasing_Speed = 8.0
	Freddy_Chasing_Speed = 8.0
	
func night4(): #Bonnie (7) Freddy (7) Foxy (7)
	Player_Speed = 9
	Bonnie.process_mode = Node.PROCESS_MODE_INHERIT
	Freddy.process_mode = Node.PROCESS_MODE_INHERIT
	Foxy.process_mode = Node.PROCESS_MODE_INHERIT
	Bonnie_Chasing_Speed = 7.0
	Freddy_Chasing_Speed = 7.0
	Foxy_Chasing_Speed = 7.0

func night5(): #Bonnie (11) Freddy (11) Foxy (12)
	Player_Speed = 13
	Bonnie.process_mode = Node.PROCESS_MODE_INHERIT
	Freddy.process_mode = Node.PROCESS_MODE_INHERIT
	Foxy.process_mode = Node.PROCESS_MODE_INHERIT
	Bonnie_Chasing_Speed = 10.0
	Freddy_Chasing_Speed = 10.0
	Foxy_Chasing_Speed = 12.0

func night_over():
	Bonnie.process_mode = Node.PROCESS_MODE_DISABLED
	Freddy.process_mode = Node.PROCESS_MODE_DISABLED
	Foxy.process_mode = Node.PROCESS_MODE_DISABLED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
