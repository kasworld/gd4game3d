extends Node3D

var ball_scene = preload("res://ball/ball.tscn")

const BALL_COUNT = 10
const TAIL_COUNT = 50
const RADIUS = 0.5
var ball_list = []
var b_box :AABB
func _ready() -> void:
	$DirectionalLight3D.position = $BoundBox.size *0.45
	$DirectionalLight3D.look_at(Vector3.ZERO)
	b_box = AABB( $BoundBox.position -$BoundBox.size/2, $BoundBox.size)
	add_ball(TAIL_COUNT, NamedColorList.color_list.pick_random()[0])
	$MovingCamera.init( b_box, Vector3.ZERO, ball_list[0] )

func add_ball(tc :int, co :Color)->void:
	var ball = ball_scene.instantiate()
	ball.init( b_box, tc, new_mesh(RADIUS, co) )
	ball_list.append(ball)
	add_child(ball)

func new_mesh(r :float, co: Color)->Mesh:
	var mesh = SphereMesh.new()
	mesh.radius = r
	#mesh.radial_segments = 100
	#mesh.rings = 100
	mesh.material = new_mat(co)
	return mesh

func new_mat(co: Color)->Material:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = co
	mat.metallic = 1
	mat.clearcoat = true
	return mat

func _process(delta: float) -> void:
	if ball_list.size() < BALL_COUNT:
		add_ball(TAIL_COUNT,  NamedColorList.color_list.pick_random()[0])

	$LabelInfo.text = "Ball %d\n(%.1f,%.1f,%.1f)\n%.1fFPS" % [
		ball_list.size(),
		$MovingCamera.position.x, $MovingCamera.position.y, $MovingCamera.position.z,
		1.0/delta]
