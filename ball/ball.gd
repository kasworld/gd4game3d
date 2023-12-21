class_name Ball extends Node3D

const SPEED_LIMIT :float = 100
var velocity :Vector3
var bounce_area :AABB
var radius :float
var sphere_count :int
var sphere_list = []
var sphere_cursor :int

func init(ba :AABB, count :int, mesh :Mesh)->void:
	bounce_area = ba
	sphere_count = count
	radius = mesh.radius
	velocity = Vector3( (randf()-0.5)*SPEED_LIMIT,(randf()-0.5)*SPEED_LIMIT,(randf()-0.5)*SPEED_LIMIT)
	for i in sphere_count:
		var sp = MeshInstance3D.new()
		sp.mesh = mesh
		add_child(sp)
		sphere_list.append(sp)

func move(delta :float)->void:
	var old_sphere = sphere_list[sphere_cursor%sphere_count]
	sphere_cursor +=1
	sphere_list[sphere_cursor%sphere_count].position = old_sphere.position
	move_sphere(delta, sphere_list[sphere_cursor%sphere_count])

func move_sphere(delta: float, sp :Node3D) -> void:
	sp.position += velocity * delta
	var bn = Bounce.bounce3d(sp.position,velocity,bounce_area,radius)
	sp.position = bn.position
	velocity = bn.velocity
	for i in 3:
		# change vel on bounce
		if bn.bounced[i] != 0 :
			velocity[i] = -random_positive(bounce_area.size[i]/2)*bn.bounced[i]

func random_positive(w :float)->float:
	return randf_range(w/10,w)

func _physics_process(delta: float) -> void:
	move(delta)
