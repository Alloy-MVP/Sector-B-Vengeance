extends CharacterBody3D

@onready var Pathfinding = $NavigationAgent3D
@onready var player = $"../Player"
@onready var animatronic_camera = $Head/Camera3D
@onready var navigation_region = $"../Map/NavigationRegion3D"
@onready var animatronic_raycast = $Head/RayCast3D

var SPEED = 5.0
var roaming_SPEED = 3.0
var update_speed: bool = false
var pathfinding_update_time = 0.5
var update_pathfinding_timer = 0.1
var chase_delay = 0.1
var seen_time = 0.0
var player_lost_time = 0.0
var time_until_player_lost = 5.0
var chasing: bool = false
var roaming: bool = true
var target_path: bool = false
var raycast_timer = 0.0
var raycast_update_time = 0.05
var stuck_timer = 0.0
var position_update: Vector3 = Vector3(0, 0, 0)

func _ready() -> void:
	# Pathfinding after everything is loaded
	Pathfinding.target_position = self.global_position

func player_location(delta: float):
	# Timer that determines the time gap between pathfinding being updated
	update_pathfinding_timer -= delta
	if update_pathfinding_timer <= 0.0:
		if player:
			Pathfinding.target_position = player.global_position
		update_pathfinding_timer = pathfinding_update_time

func chase(delta: float):
	player_location(delta)
	
	var current_position = global_position
	var target_position = Pathfinding.get_next_path_position()
	var direction = (target_position - current_position).normalized()
	
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

func roam():
	# Only selecting a new path if the current one is finished
	if Pathfinding.is_navigation_finished() and not target_path:
		target_path = true
		var map = get_world_3d().navigation_map
		var random_point = NavigationServer3D.map_get_random_point(map, 1, false)
		Pathfinding.target_position = random_point
	
	# Currently pathfinding
	if not Pathfinding.is_navigation_finished():
		target_path = false
	
	var current_position = global_position
	var target_position = Pathfinding.get_next_path_position()
	var direction = (target_position - current_position).normalized()
	
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED

func animatronic_looking_at_player_check(delta):
	raycast_update_time -= delta
	if raycast_update_time <= raycast_timer:
		animatronic_raycast.look_at(player.global_position, Vector3.UP)
		animatronic_raycast.force_raycast_update()
		raycast_update_time = 0.05
	if animatronic_camera.is_position_in_frustum(player.global_position) and animatronic_raycast.is_colliding() and animatronic_raycast.get_collider() == player:
		if roaming:
			seen_time += delta
			if seen_time >= chase_delay:
				chasing = true
				SPEED = $"..".Bonnie_Chasing_Speed
				roaming = false
				seen_time = 0.0
		elif chasing:
			player_lost_time = 0.0
	else:
		if roaming:
			seen_time = 0.0
		elif chasing:
			player_lost_time += delta
			if player_lost_time >= time_until_player_lost:
				chasing = false
				roaming = true
				SPEED = roaming_SPEED
				player_lost_time = 0.0
				
				var map = get_world_3d().navigation_map
				var random_point = NavigationServer3D.map_get_random_point(map, 1, false)
				Pathfinding.target_position = random_point

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"): # Master control between modes
		chasing = !chasing
		roaming = !roaming

func _physics_process(delta: float) -> void:
	animatronic_looking_at_player_check(delta)
	stuck_timer += delta
	if stuck_timer >= 3.0:
		var current_position = Vector3(global_position.x, 0, global_position.z)
		var initial_position = Vector3(position_update.x, 0, position_update.z)
		if current_position.distance_to(initial_position) < 0.1:
			roaming = true
			chasing = false
			var map = get_world_3d().navigation_map
			var random_point = NavigationServer3D.map_get_random_point(map, 1, false)
			Pathfinding.target_position = random_point
		stuck_timer = 0.0
		position_update = global_position
		
	if chasing:
		chase(delta)

	if roaming:
		roam()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
	
	var direction_facing = Vector3(velocity.x, 0, velocity.z)
	if direction_facing.length_squared() > 0.01:
		var face_direction = global_transform.looking_at(global_position + direction_facing, Vector3.UP)
		global_transform = global_transform.interpolate_with(face_direction, 10.0 * delta)
