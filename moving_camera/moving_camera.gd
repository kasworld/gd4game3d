extends BounceNode3D

const SPEED_LIMIT :float = 100
var life_start :float
var dest_node3d :Node3D

func init(ba :AABB, p :Vector3, dst :Node3D)->void:
	area = ba
	life_start = Time.get_unix_time_from_system()
	position = p
	velocity = Vector3( (randf()-0.5)*SPEED_LIMIT,(randf()-0.5)*SPEED_LIMIT,(randf()-0.5)*SPEED_LIMIT)
	dest_node3d = dst

func _process(delta: float) -> void:
	$Camera3D.look_at(dest_node3d.position)

func _physics_process(delta: float) -> void:
	position += velocity * delta
	bounce()
