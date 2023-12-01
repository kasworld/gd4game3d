extends Node3D

const SPEED_LIMIT :float = 100
var life_start :float
var dest_node3d :Node3D

var velocity :Vector3
var bounce_area :AABB
var radius :float

func init(ba :AABB, p :Vector3, dst :Node3D)->void:
	life_start = Time.get_unix_time_from_system()
	dest_node3d = dst

	bounce_area = ba
	position = p
	velocity = Vector3( (randf()-0.5)*SPEED_LIMIT,(randf()-0.5)*SPEED_LIMIT,(randf()-0.5)*SPEED_LIMIT)

func _process(delta: float) -> void:
	$Camera3D.look_at(dest_node3d.position)

func _physics_process(delta: float) -> void:
	position += velocity * delta
	var bn = Bounce.bounce3d(position,velocity,bounce_area,radius)
	position = bn.position
	velocity = bn.velocity
