class_name Ball extends Node3D

var velocity :Vector3
var bounce_area :AABB
var radius :float = 0.5
var speed_max :float
var speed_min :float
var sphere_count :int
var sphere_list = []
var sphere_cursor :int
var color_mat_list = []
var current_mat :Material
var current_rot :Vector3
var current_rot_accel :Vector3

func init(ba :AABB, count :int, comats :Array, t:int)->void:
	color_mat_list = comats
	bounce_area = ba
	sphere_count = count
	speed_max = radius * 300
	speed_min = radius * 120
	velocity = Vector3( (randf()-0.5)*speed_max,(randf()-0.5)*speed_max,(randf()-0.5)*speed_max)
	current_mat = color_mat_list.pick_random()
	current_rot_accel = Vector3(rand_rad(),rand_rad(),rand_rad())
	for i in sphere_count:
		var sp = MeshInstance3D.new()
		match t%4:
			0:
				sp.mesh = new_sphere(radius,current_mat)
			1:
				sp.mesh = new_text(radius,current_mat)
			2:
				sp.mesh = new_box(radius,current_mat)
			3:
				sp.mesh = new_torus(radius,current_mat)
		add_child(sp)
		sphere_list.append(sp)

func new_sphere(r :float, mat :Material)->Mesh:
	var mesh = SphereMesh.new()
	mesh.radius = r
	#mesh.radial_segments = 100
	#mesh.rings = 100
	mesh.material = mat
	return mesh

func new_box(r :float, mat :Material)->Mesh:
	var mesh = BoxMesh.new()
	mesh.size = Vector3(r,r,r)
	mesh.material = mat
	return mesh

func new_text(r :float, mat :Material)->Mesh:
	var mesh = TextMesh.new()
	mesh.font_size = r*500
	mesh.text = "A"
	mesh.material = mat
	return mesh

func new_torus(r :float, mat :Material)->Mesh:
	var mesh = TorusMesh.new()
	mesh.inner_radius = r/2
	mesh.outer_radius = r
	mesh.material = mat
	return mesh

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
	var bounced = false
	for i in 3:
		# change vel on bounce
		if bn.bounced[i] != 0 :
			velocity[i] = -random_positive(speed_max/2)*bn.bounced[i]
			bounced = true

	if bounced :
		current_mat = color_mat_list.pick_random()
		current_rot_accel = Vector3(rand_rad(),rand_rad(),rand_rad())
	sp.mesh.material = current_mat
	current_rot += current_rot_accel
	sp.rotation = current_rot

	if velocity.length() > speed_max:
		velocity = velocity.normalized() * speed_max
	if velocity.length() < speed_min:
		velocity = velocity.normalized() * speed_min

func rand_rad()->float:
	return randf_range(-PI,PI)/10

func random_positive(w :float)->float:
	return randf_range(w/10,w)

func _physics_process(delta: float) -> void:
	move(delta)
