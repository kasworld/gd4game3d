extends Node3D

var balltrail_scene = preload("res://ball_trail/ball_trail.tscn")
var balltrail2_scene = preload("res://ball_trail_2/ball_trail_2.tscn")
var line2d_scene = preload("res://move_line2d/move_line_2d.tscn")

const BALL_COUNT = 14
const TAIL_COUNT = 50
var ball_list = []
var b_box :AABB

func _ready() -> void:
	var bound_size = Vector3(100,100,100)
	$DirectionalLight3D.position = bound_size *0.45
	$DirectionalLight3D.look_at(Vector3.ZERO)
	b_box = AABB( -bound_size/2, bound_size)

	add_ball(TAIL_COUNT)
	$MovingCamera.init( b_box, Vector3.ZERO, ball_list[0] )

	make_line2d(Vector2(bound_size.x,bound_size.y),Vector3(0,0,-bound_size.z/2), PlaneMesh.FACE_Z, false)
	make_line2d(Vector2(bound_size.x,bound_size.y),Vector3(0,0,bound_size.z/2), PlaneMesh.FACE_Z, true)

	make_line2d(Vector2(bound_size.x,bound_size.z),Vector3(0,-bound_size.z/2,0), PlaneMesh.FACE_Y, false)
	make_line2d(Vector2(bound_size.x,bound_size.z),Vector3(0,bound_size.z/2,0), PlaneMesh.FACE_Y, true)

	make_line2d(Vector2(bound_size.y,bound_size.z),Vector3(-bound_size.z/2,0,0), PlaneMesh.FACE_X, false)
	make_line2d(Vector2(bound_size.y,bound_size.z),Vector3(bound_size.z/2,0,0), PlaneMesh.FACE_X, true)

func add_ball(tc :int)->void:
	var ball = balltrail2_scene.instantiate()
	ball.init( b_box,0.5, tc, ball_list.size())
	ball_list.append(ball)
	add_child(ball)

var line2d_list :Array
func make_line2d(sz :Vector2, p :Vector3, face :PlaneMesh.Orientation ,flip :bool)->MeshInstance3D:
	var mesh = PlaneMesh.new()
	mesh.size = sz
	mesh.orientation = face
	mesh.flip_faces = flip
	var size_pixel = Vector2i(2048,2048)
	var l2d = line2d_scene.instantiate()
	l2d.init(300,4,size_pixel)
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
	if ball_list.size() < BALL_COUNT:
		add_ball(TAIL_COUNT)

	$LabelInfo.text = "Ball %dx%d\n(%.1f,%.1f,%.1f)\n%.1fFPS" % [
		ball_list.size(),TAIL_COUNT,
		$MovingCamera.position.x, $MovingCamera.position.y, $MovingCamera.position.z,
		1.0/delta]
