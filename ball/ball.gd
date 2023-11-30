class_name Ball extends BounceNode3D

const SPEED_LIMIT :float = 100
var alive :bool
var life_start :float

func init(ba :AABB, p :Vector3)->void:
	area = ba
	alive = true
	life_start = Time.get_unix_time_from_system()
	position = p
	radius = $Sphere.radius
	velocity = Vector3( (randf()-0.5)*SPEED_LIMIT,(randf()-0.5)*SPEED_LIMIT,(randf()-0.5)*SPEED_LIMIT)

func _physics_process(delta: float) -> void:
	position += velocity * delta
	bounce()
