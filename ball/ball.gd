class_name Ball extends Node3D

var velocity :Vector3
var bounce_area :AABB
var radius :float = 0.5
var speed_max :float
var speed_min :float
var obj_count :int
var obj_list = []
var obj_cursor :int
var current_mat :Material
var current_rot :Vector3
var current_rot_accel :Vector3

var new_obj_fns = [
	new_sphere,
	new_text,
	new_box,
	new_prism,
	new_torus,
	new_capsule,
	new_cylinder,
]

func init(ba :AABB, count :int, t:int)->void:
	bounce_area = ba
	obj_count = count
	speed_max = radius * 300
	speed_min = radius * 120
	velocity = Vector3( (randf()-0.5)*speed_max,(randf()-0.5)*speed_max,(randf()-0.5)*speed_max)
	current_mat = MatCache.get_color_mat(NamedColorList.color_list.pick_random()[0] )
	current_rot_accel = Vector3(rand_rad(),rand_rad(),rand_rad())
	var new_obj = new_obj_fns[t%new_obj_fns.size()]
	for i in obj_count:
		var sp = MeshInstance3D.new()
		sp.mesh = new_obj.call(radius,current_mat)
		add_child(sp)
		obj_list.append(sp)

func new_sphere(r :float, mat :Material)->Mesh:
	var mesh = SphereMesh.new()
	mesh.radius = r
	#mesh.radial_segments = 100
	#mesh.rings = 100
	mesh.material = mat
	return mesh

func new_box(r :float, mat :Material)->Mesh:
	var mesh = BoxMesh.new()
	mesh.size = Vector3(r,r,r)*1.5
	mesh.material = mat
	return mesh

func new_prism(r :float, mat :Material)->Mesh:
	var mesh = PrismMesh.new()
	mesh.size = Vector3(r,r,r)*1.5
	mesh.material = mat
	return mesh

func new_text(r :float, mat :Material)->Mesh:
	var mesh = TextMesh.new()
	mesh.depth = r/4
	mesh.pixel_size = r / 10
	mesh.font_size = r*50
	mesh.text = "A"
	mesh.material = mat
	return mesh

func new_torus(r :float, mat :Material)->Mesh:
	var mesh = TorusMesh.new()
	mesh.inner_radius = r/2
	mesh.outer_radius = r
	mesh.material = mat
	return mesh

func new_capsule(r :float, mat :Material)->Mesh:
	var mesh = CapsuleMesh.new()
	mesh.height = r*3
	mesh.radius = r*0.75
	mesh.material = mat
	return mesh

func new_cylinder(r :float, mat :Material)->Mesh:
	var mesh = CylinderMesh.new()
	mesh.height = r*2
	mesh.bottom_radius = r
	mesh.top_radius = 0
	mesh.material = mat
	return mesh

func move(delta :float)->void:
	var old_obj = obj_list[obj_cursor%obj_count]
	obj_cursor +=1
	obj_list[obj_cursor%obj_count].position = old_obj.position
	move_sphere(delta, obj_list[obj_cursor%obj_count])

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
		current_mat = MatCache.get_color_mat(NamedColorList.color_list.pick_random()[0] )
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
