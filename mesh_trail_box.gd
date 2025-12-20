extends Node3D
class_name MeshTrailBox

var meshtrail_scene = preload("res://mesh_trail/mesh_trail.tscn")

func init(box_size :Vector3) -> void:
	$BounceCameraLight.set_center_pos_far(Vector3.ZERO, Vector3(0, 0, box_size.z*2), box_size.length()*2)
	$WallBox.mesh.size = box_size
	bound_aabb = AABB( -box_size/2, box_size)
	velocity = Vector3( (randf()-0.5)*box_size.length()/3,(randf()-0.5)*box_size.length()/3,(randf()-0.5)*box_size.length()/3)

	var mesh := BoxMesh.new()
	mesh.size = Vector3(mesh_radius*4, mesh_radius/10, mesh_radius/10)
	for i in 100:
		var ball :MeshTrail = meshtrail_scene.instantiate(
			#).set_ColorChange_OnBounce(
			#).set_ColorChange_MeshGradient(
			).set_ColorChange_ByPosition(bound_aabb
			#).set_ColorChange_ByPositionFn(get_color_ByPosition
			).init_with_alpha(mesh, 1000,  1.0 , bound_aabb.get_center(),
			).set_speed(20,40)
		$MeshTrailContainer.add_child(ball)

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
	if $BounceCameraLight.is_current_camera():
		velocity = $BounceCameraLight.bounce_within_aabb(delta, bound_aabb, velocity, Vector3.ZERO, mesh_radius )
	for mt in $MeshTrailContainer.get_children():
		mt.move_trail(delta, bounce, mesh_radius, 4*PI,)
