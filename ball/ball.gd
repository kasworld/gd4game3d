class_name Ball extends Node3D

const SPEED_LIMIT :float = 100
var velocity :Vector3
var bounce_area :AABB
var bounce_radius :float
var alive :bool
var life_start :float

func init(ba :AABB, p :Vector3)->void:
	bounce_area = ba
	alive = true
	life_start = Time.get_unix_time_from_system()
	position = p
	bounce_radius = $Sphere.radius
	velocity = Vector3( (randf()-0.5)*SPEED_LIMIT,(randf()-0.5)*SPEED_LIMIT,(randf()-0.5)*SPEED_LIMIT)

func _physics_process(delta: float) -> void:
	position += velocity * delta
	var bn = Bounce.bounce(position,velocity,bounce_area,bounce_radius)
	position = bn.position
	velocity = bn.velocity
