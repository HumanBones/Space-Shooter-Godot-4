extends Area2D

@export var max_speed: float
@export var min_speed: float 
@export var max_hits: int
@export var max_amount: int

const METEOR = preload("res://Scenes/Asteroids/meteor.tscn")

@onready var explode = $Explode

var holder:Node2D
var particles: GPUParticles2D

var min_scale:float = 0.3
var direction = [Vector2.LEFT,Vector2.RIGHT,Vector2.UP,Vector2.DOWN]
var cur_dir: Vector2
var speed:float
var hits:int
var is_small:bool

func _ready():
	holder = get_tree().get_nodes_in_group("holder")[0]
	particles = get_tree().get_nodes_in_group("particles")[0]
	speed = max_speed
	hits = max_hits
	cur_dir = rand_direction()
	if is_small:
		speed = rand_speed()
		scale = Vector2(rand_scale(),rand_scale())
		
func _physics_process(delta):
	var velocity = 0
	global_position += speed * cur_dir * delta
	print(velocity)

func rand_direction() -> Vector2:
	return direction.pick_random()

func rand_speed() -> float:
	var _rand_speed = randf_range(min_speed,max_speed)
	return _rand_speed

func rand_scale() ->float:
	var _rand_scale = randf_range(min_scale,scale.x)
	return _rand_scale

func set_small() ->void:
	is_small = true

func die() ->void:
	explode.play()
	spawn_particle()
	var amount = randi_range(2,max_amount)
	for n in amount:
		call_deferred("spawn_small")
	call_deferred("queue_free")

func spawn_small() ->void:
	var small_instance = METEOR.instantiate() as Node2D
	small_instance.set_small()
	small_instance.position = global_position
	if holder != null:
		holder.add_child(small_instance)


func _on_area_entered(area):
	area.queue_free()
	die()

func spawn_particle() ->void:
	if particles != null:
		var particle_instance = particles.instantiate() as Node2D
		particle_instance.position = global_position
		if holder !=null:
			holder.add_child(particle_instance)
	
