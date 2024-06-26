extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var game_manager = %GameManager
@onready var cooldown = $cooldown

var SPEED = 6
var inRange = false
var Looking = false
signal despawn
func _physics_process(delta):
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	if inRange and !Looking:
		velocity = velocity.move_toward(new_velocity, .25)
		move_and_slide()
		look_at(nav_agent.target_position, Vector3.UP)
	
func update_target_location(target_location):
	if inRange:
		if !Looking:
			nav_agent.target_position = target_location
		

func _on_navigation_agent_3d_target_reached():
	print("you died")


func _on_area_3d_body_entered(body):
	inRange=true
	print("someone is following you")


func _on_area_3d_body_exited(body):
	inRange=false
	queue_free()
	get_tree().call_group("Player","look_meter_stop")
	despawn.emit()
	print("you escaped...")


func _on_visible_on_screen_notifier_3d_screen_exited():
	Looking = false
	get_tree().call_group("Player","look_meter_stop")
	var random = RandomNumberGenerator.new()
	if cooldown.is_stopped():
		if random.randf()>0.3:
			teleport()
		

func _on_visible_on_screen_notifier_3d_screen_entered():
	Looking = true
	get_tree().call_group("Player","look_meter_start")
	
func teleport():
	cooldown.start()
	var directionRand = RandomNumberGenerator.new()
	var valueRand = RandomNumberGenerator.new()
	if directionRand.randf()>0.5:
		#lewo
		global_translate(Vector3(-randi_range(3,5),0,-2))
	else:
		#prawo
		global_translate(Vector3(randi_range(3,5),0,-2))
		
