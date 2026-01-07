extends Node3D
class_name MeshTrailBox

var meshtrail_scene = preload("res://mesh_trail/mesh_trail.tscn")

func init(box_size :Vector3, colortype :int) -> MeshTrailBox:
	bound_aabb = AABB( -box_size/2, box_size)

	var center := bound_aabb.get_center()
	$BounceCameraLight.set_center_pos_far(center, center + Vector3(0, 0, box_size.z*2), box_size.length()*2)
	$WallBox.mesh.size = box_size
	velocity = Vector3( (randf()-0.5)*box_size.length()/3,(randf()-0.5)*box_size.length()/3,(randf()-0.5)*box_size.length()/3)

	var mesh := BoxMesh.new()
	mesh.material = MultiMeshShape.make_color_material(1.0)
	mesh.size = Vector3(mesh_radius*4, mesh_radius/10, mesh_radius/10)
	var inst_count := 1000
	for i in 10:
		var mt :MeshTrail = meshtrail_scene.instantiate(
			).init_with_color_mesh(mesh, inst_count, true, bound_aabb.get_center(),
			).set_speed(20,40)
		match colortype:
			0:
				mt.set_ColorChange_OnBounce()
			1:
				mt.set_ColorChange_MeshGradient()
			2:
				mt.set_ColorChange_ByPosition(bound_aabb)
			3:
				mt.set_ColorChange_ByPositionFn(get_color_ByPosition)
		$MeshTrailContainer.add_child(mt)
	return self

func bounce(_oldpos:Vector3, pos :Vector3, radiusa :float) -> Dictionary:
	return Bounce.v3f(pos, bound_aabb, radiusa)
func get_color_ByPosition(pos :Vector3) -> Color:
	var co :Color
	for i in 3:
		co[i] = (pos[i] - bound_aabb.position[i]) / bound_aabb.size[i]
	co = co.inverted()
	return co

var color_list_light = NamedColorList.make_light_color_list()
var color_list_dark = NamedColorList.make_dark_color_list()
func random_color1() -> Color:
	return NamedColorList.color_list.pick_random()[0]
func random_color2() -> Color:
	return color_list_light.pick_random()[0]
func random_color3() -> Color:
	return color_list_dark.pick_random()[0]

var bound_aabb :AABB
var mesh_radius := 1.5
var velocity :Vector3
func _process(delta: float) -> void:
	for mt in $MeshTrailContainer.get_children():
		mt.move_trail(delta, bounce, mesh_radius, 4*PI,)

	var center := position + bound_aabb.get_center()
	if $BounceCameraLight.is_current_camera():
		velocity = $BounceCameraLight.bounce_within_aabb(delta, bound_aabb, velocity, center, mesh_radius )
