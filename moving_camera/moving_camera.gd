extends Node3D

const SPEED_LIMIT :float = 50
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
	radius = 15
	velocity = Vector3( (randf()-0.5)*SPEED_LIMIT,(randf()-0.5)*SPEED_LIMIT,(randf()-0.5)*SPEED_LIMIT)

func _process(delta: float) -> void:
	$Camera3D.look_at(dest_node3d.position)

	position += velocity * delta
	var bn = Bounce2.v3f(position, bounce_area, radius)
	for i in 3:
		# change vel on bounce
		if bn.bounced[i] != 0 :
			velocity[i] = -bn.bounced[i] * abs(velocity[i])
	position = bn.pos
