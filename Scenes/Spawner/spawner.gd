extends Node2D

signal asteroid_spawned

@export var asteroid_scene : PackedScene
@export var spawn_rate:float

@onready var timer = $Timer

var holder: Node2D


func get_screen_size() ->Vector2:
	var new_vec = get_viewport_rect().size
	return new_vec


func _ready():
	timer.wait_time = spawn_rate
	holder = get_tree().get_nodes_in_group("holder")[0]
	if holder == null:
		print("error")
		return
	if asteroid_scene == null:
		print("error no asteroid scene")
		return
	
func spaw_asteroids() ->void:
	if asteroid_scene == null:
		return
	var asteroid_instance = asteroid_scene.instantiate() as Node2D
	asteroid_instance.position = random_pos(get_screen_size())
	asteroid_instance.set_small(false)
	holder.add_child(asteroid_instance)
	asteroid_spawned.emit()

func random_pos(_range:Vector2) ->Vector2:
	var new_size = Vector2(randf_range(0,_range.x), randf_range(0,_range.y))
	return new_size


func _on_timer_timeout():
	spaw_asteroids()
