extends Camera2D

@export var random_stren:float
@export var shake_fade:float

var rng = RandomNumberGenerator.new()
var shake_stren:float = 0.0

func _ready():
	SignalManager.asteroid_destroyed.connect(apply_shake)

func _process(delta):
	if shake_stren >0:
		shake_stren = lerpf(shake_stren,0,shake_fade * delta)
		offset = random_offset()

func apply_shake() ->void:
	shake_stren = random_stren
	

func random_offset() ->Vector2:
	return Vector2(rng.randf_range(-shake_stren,shake_stren),rng.randf_range(-shake_stren,shake_stren))
