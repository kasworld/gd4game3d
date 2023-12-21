class_name Ball extends Node3D

var velocity :Vector3
var bounce_area :AABB
var radius :float
var speed_max :float
var speed_min :float
var sphere_count :int
var sphere_list = []
var sphere_cursor :int

func init(ba :AABB, count :int, mesh :Mesh)->void:
	bounce_area = ba
	sphere_count = count
	radius = mesh.radius
	speed_max = radius * 300
	speed_min = radius * 120
	velocity = Vector3( (randf()-0.5)*speed_max,(randf()-0.5)*speed_max,(randf()-0.5)*speed_max)
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
			velocity[i] = -random_positive(speed_max/2)*bn.bounced[i]

	if velocity.length() > speed_max:
		velocity = velocity.normalized() * speed_max
	if velocity.length() < speed_min:
		velocity = velocity.normalized() * speed_min

func random_positive(w :float)->float:
	return randf_range(w/10,w)

func _physics_process(delta: float) -> void:
	move(delta)
