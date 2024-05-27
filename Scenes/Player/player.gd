extends CharacterBody2D

@export var max_speed: float
@export var max_hp:int
@export var fire_rate:float
@export var bullet_holder:Node2D

@onready var timer = $Timer
@onready var marker_2d = $Marker2D
@onready var explode = $Explode
@onready var main_sprites = $MainSprites

@onready var bullet_scene = preload("res://Scenes/Bullet/bullet.tscn")


var can_shoot:bool
var speed:float
var dir:Vector2
var offset:float = 16
var is_dead: bool

func _ready():
	is_dead = false
	explode.hide()
	speed = max_speed
	timer.wait_time = fire_rate
	can_shoot = true
	
func _physics_process(delta):
	get_input()
	clamp_position()
	
	velocity = speed * dir
	
	move_and_slide()
	

func get_input() ->void:
	
	dir = Vector2(Input.get_axis("left","right"),Input.get_axis("up","down")).normalized()
	
	if Input.is_action_just_pressed("shoot") && can_shoot:
		shoot()
		timer.start()
		can_shoot = false
		
func shoot() ->void:
	var bullet_instance = bullet_scene.instantiate() as Node2D
	bullet_instance.set_dmg(1.0)
	bullet_instance.global_position = marker_2d.global_position
	if bullet_holder != null:
		bullet_holder.add_child(bullet_instance)


func _on_timer_timeout():
	can_shoot = true

func clamp_position():
	var screen_size = get_viewport_rect().size
	position = Vector2(clamp(position.x,offset,screen_size.x-offset),clamp(position.y,offset,screen_size.y-offset))


func die() ->void:
	if !is_dead:
		explode.show()
		explode.play("Explode")
		main_sprites.hide()
		set_physics_process(false)
		is_dead = true
		SignalManager.player_died.emit()
		#print game over
		#restart


func _on_explode_animation_finished():
	explode.hide()
