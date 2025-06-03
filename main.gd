extends Node3D

var meshtrail_scene = preload("res://mesh_trail/mesh_trail.tscn")
var line2d_scene = preload("res://move_line2d/move_line_2d.tscn")

var b_box :AABB
#var MeshTrailTypeList = PlayingCard.make_deck()
var MeshTrailTypeList = ["♠","♣","♥","♦" ,"★","☆","♩","♪","♬"]
#var MeshTrailTypeList = [0,1,2,3,4,5,"♠","♣","♥","♦"]

func _ready() -> void:
	var bound_size = Vector3(100,100,100)
	$DirectionalLight3D.position = bound_size *0.45
	$DirectionalLight3D.look_at(Vector3.ZERO)
	b_box = AABB( -bound_size/2, bound_size)

	for mt in MeshTrailTypeList:
		var ball = meshtrail_scene.instantiate().with_color_OnBounce().set_random_color_fn(random_color3).init( bounce, 0.5, randi_range(1,10), mt, Vector3.ZERO)
		$MeshTrailContainer.add_child(ball)
	for mt in MeshTrailTypeList:
		var ball = meshtrail_scene.instantiate().with_color_MeshGradient().set_random_color_fn(random_color3).init( bounce, 0.5, randi_range(10,100), mt, Vector3.ZERO)
		$MeshTrailContainer.add_child(ball)
	#for mt in MeshTrailTypeList:
		#var ball = meshtrail_scene.instantiate().with_color_ByPosition(b_box).init( bounce, 0.5, randi_range(1,10), mt, Vector3.ZERO)
		#$MeshTrailContainer.add_child(ball)

	$MovingCamera.init( b_box, Vector3.ZERO, $MeshTrailContainer.get_child(0) )
	make_line2d(Vector2(b_box.size.x,b_box.size.y), Vector3(b_box.get_center().x, b_box.get_center().y, b_box.position.z),     PlaneMesh.FACE_Z, false)
	make_line2d(Vector2(b_box.size.x,b_box.size.y), Vector3(b_box.get_center().x, b_box.get_center().y, b_box.end.z),          PlaneMesh.FACE_Z, true)
	make_line2d(Vector2(b_box.size.x,b_box.size.z), Vector3(b_box.get_center().x, b_box.position.y,     b_box.get_center().z), PlaneMesh.FACE_Y, false)
	make_line2d(Vector2(b_box.size.x,b_box.size.z), Vector3(b_box.get_center().x, b_box.end.y,          b_box.get_center().z), PlaneMesh.FACE_Y, true)
	make_line2d(Vector2(b_box.size.y,b_box.size.z), Vector3(b_box.position.x,     b_box.get_center().y, b_box.get_center().z), PlaneMesh.FACE_X, false)
	make_line2d(Vector2(b_box.size.y,b_box.size.z), Vector3(b_box.end.x,          b_box.get_center().y, b_box.get_center().z), PlaneMesh.FACE_X, true)

func bounce(_oldpos:Vector3, pos :Vector3, radius :float) -> Dictionary:
	return Bounce2.v3f(pos, b_box, radius)

var color_list_light = NamedColorList.make_light_color_list()
var color_list_dark = NamedColorList.make_dark_color_list()
func random_color1() -> Color:
	return NamedColorList.color_list.pick_random()[0]
func random_color2() -> Color:
	return color_list_light.pick_random()[0]
func random_color3() -> Color:
	return color_list_dark.pick_random()[0]

var line2d_list :Array
func make_line2d(sz :Vector2, p :Vector3, face :PlaneMesh.Orientation ,flip :bool)->MeshInstance3D:
	var mesh = PlaneMesh.new()
	mesh.size = sz
	mesh.orientation = face
	mesh.flip_faces = flip
	var size_pixel = Vector2i(2048,2048)
	var l2d = line2d_scene.instantiate().init_with_random(300, 4, 1, size_pixel)
	l2d.start()
	var sv = SubViewport.new()
	sv.size = size_pixel
	sv.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	sv.render_target_clear_mode = SubViewport.CLEAR_MODE_ALWAYS
	#sv.transparent_bg = true
	sv.add_child(l2d)
	add_child(sv)
	var sp = MeshInstance3D.new()
	sp.mesh = mesh
	sp.position = p
	sp.material_override = StandardMaterial3D.new()
	#sp.material_override.transparency = StandardMaterial3D.TRANSPARENCY_ALPHA
	sp.material_override.albedo_texture = sv.get_texture()
	add_child(sp)
	line2d_list.append(sp)
	return sp

func _process(delta: float) -> void:
	$LabelInfo.text = "MeshTrail %d\n(%.1f,%.1f,%.1f)\n%.1fFPS" % [
		$MeshTrailContainer.get_child_count(),
		$MovingCamera.position.x, $MovingCamera.position.y, $MovingCamera.position.z,
		1.0/delta]

var key2fn = {
	KEY_ESCAPE:_on_button_esc_pressed,
}

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var fn = key2fn.get(event.keycode)
		if fn != null:
			fn.call()
	elif event is InputEventMouseButton and event.is_pressed():
		pass

func _on_button_esc_pressed() -> void:
	get_tree().quit()
