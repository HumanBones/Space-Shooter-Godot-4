extends Area2D

@export var max_speed: float

var speed:float
var dmg:float
var dir:Vector2
var velocity: Vector2


func _ready():
	speed = max_speed
	dir = Vector2.UP
	
func _physics_process(delta):
	if dir != null:
		velocity = dir * speed * delta
		position += velocity
	
func set_speed(_speed:float) ->void:
	speed = _speed
	
func set_dmg(_dmg:float) ->void:
	dmg = _dmg
	
func set_dir(_dir:Vector2) ->void:
	dir = _dir


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
