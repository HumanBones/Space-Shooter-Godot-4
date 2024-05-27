extends Area2D

@export var max_speed: float
@export var min_speed: float 
@export var max_hits: int
@export var max_amount: int

var meteor = load("res://Scenes/Asteroids/meteor.tscn")
const EXPLODE_PARTICLES = preload("res://Scenes/Particles/explode_particles.tscn")
const EXPLODE = preload("res://Scenes/SFX/explode.tscn")

var screen_size:Vector2
var holder:Node2D
var offset:float = 32.0

var min_scale:float = 0.2
var direction = [Vector2.LEFT,Vector2.RIGHT,Vector2.UP,Vector2.DOWN]
var cur_dir: Vector2
var speed:float
var hits:int
var is_small:bool

func _ready():
	screen_size = get_screen_size()
	holder = get_tree().get_nodes_in_group("holder")[0]
	speed = max_speed
	hits = max_hits
	cur_dir = rand_direction()
	if is_small:
		speed = rand_speed()
		var _scale = rand_scale()
		scale = Vector2(_scale,_scale)
		
func _physics_process(delta):
	loop_around()
	var velocity = speed * cur_dir * delta
	position += velocity
	

func rand_direction() -> Vector2:
	return Vector2(randf_range(0,1),randf_range(0,1))

func rand_speed() -> float:
	var _rand_speed = randf_range(min_speed,max_speed)
	return _rand_speed

func rand_scale() ->float:
	var _rand_scale = randf_range(min_scale,scale.x-min_scale)
	return _rand_scale

func set_small(_small:bool) ->void:
	is_small = _small

func die() ->void:
	spawn_sfx()
	spawn_particle()
	SignalManager.asteroid_destroyed.emit()
	if !is_small:
		loop_spawn()
	call_deferred("queue_free")

func spawn_small() ->void:
	var small_instance = meteor.instantiate() as Node2D
	small_instance.set_small(true)
	small_instance.position = global_position
	if holder != null:
		holder.add_child(small_instance)


func _on_area_entered(area):
	area.queue_free()
	die()

func spawn_particle() ->void:
	var particle_instance = EXPLODE_PARTICLES.instantiate() as Node2D
	particle_instance.position = global_position
	particle_instance.one_shot = true
	if holder != null:
		holder.add_child(particle_instance)
	

func get_screen_size() ->Vector2:
	var size = get_viewport_rect().size
	return size

func loop_around() ->void:
	if position.x > (screen_size.x + offset):
		position.x = 0
	if position.x < 0:
		position.x = screen_size.x - offset
	
	if position.y > (screen_size.y + offset):
		position.y = 0
	if position.y < 0:
		position.y = screen_size.y - offset

func loop_spawn() ->void:
	var amount = randi_range(2,max_amount)
	for i in amount:
		call_deferred("spawn_small")

func spawn_sfx() ->void:
	var explode_instance = EXPLODE.instantiate() as Node2D
	explode_instance.global_position = position
	holder.add_child(explode_instance)


func _on_body_entered(body):
	if body.has_method("die"):
		body.die()
