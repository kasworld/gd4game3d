class_name Ball extends Node3D

const SPEED_LIMIT :float = 100
var alive :bool
var life_start :float

var velocity :Vector3
var bounce_area :AABB
var radius :float


func init(ba :AABB, p :Vector3)->void:
	alive = true
	life_start = Time.get_unix_time_from_system()

	bounce_area = ba
	position = p
	radius = $Sphere.radius
	velocity = Vector3( (randf()-0.5)*SPEED_LIMIT,(randf()-0.5)*SPEED_LIMIT,(randf()-0.5)*SPEED_LIMIT)

func _physics_process(delta: float) -> void:
	position += velocity * delta
	var bn = Bounce.bounce3d(position,velocity,bounce_area,radius)
	position = bn.position
	velocity = bn.velocity
