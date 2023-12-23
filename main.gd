extends Node3D

var ball_scene = preload("res://ball/ball.tscn")

const BALL_COUNT = 14
const TAIL_COUNT = 50
var ball_list = []
var b_box :AABB
var color_mat_list = []

func _ready() -> void:
	$DirectionalLight3D.position = $BoundBox.size *0.45
	$DirectionalLight3D.look_at(Vector3.ZERO)
	b_box = AABB( $BoundBox.position -$BoundBox.size/2, $BoundBox.size)
	for i in NamedColorList.color_list:
		var co = i[0]
		color_mat_list.append(new_mat(co))

	add_ball(TAIL_COUNT)
	$MovingCamera.init( b_box, Vector3.ZERO, ball_list[0] )

func add_ball(tc :int)->void:
	var ball = ball_scene.instantiate()
	ball.init( b_box, tc, color_mat_list , ball_list.size())
	ball_list.append(ball)
	add_child(ball)

func new_mat(co: Color)->Material:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = co
	mat.metallic = 1
	mat.clearcoat = true
	return mat

func _process(delta: float) -> void:
	if ball_list.size() < BALL_COUNT:
		add_ball(TAIL_COUNT)

	$LabelInfo.text = "Ball %dx%d\n(%.1f,%.1f,%.1f)\n%.1fFPS" % [
		ball_list.size(),TAIL_COUNT,
		$MovingCamera.position.x, $MovingCamera.position.y, $MovingCamera.position.z,
		1.0/delta]
