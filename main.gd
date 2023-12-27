extends Node3D

var ball_scene = preload("res://ball/ball.tscn")

const BALL_COUNT = 14
const TAIL_COUNT = 50
var ball_list = []
var b_box :AABB

func _ready() -> void:
	var bound_size = $BoundBox.mesh.size
	$DirectionalLight3D.position = bound_size *0.45
	$DirectionalLight3D.look_at(Vector3.ZERO)
	b_box = AABB( $BoundBox.position -bound_size/2, bound_size)

	add_ball(TAIL_COUNT)
	$MovingCamera.init( b_box, Vector3.ZERO, ball_list[0] )

func add_ball(tc :int)->void:
	var ball = ball_scene.instantiate()
	ball.init( b_box, tc, ball_list.size())
	ball_list.append(ball)
	add_child(ball)

func _process(delta: float) -> void:
	if ball_list.size() < BALL_COUNT:
		add_ball(TAIL_COUNT)

	$LabelInfo.text = "Ball %dx%d\n(%.1f,%.1f,%.1f)\n%.1fFPS" % [
		ball_list.size(),TAIL_COUNT,
		$MovingCamera.position.x, $MovingCamera.position.y, $MovingCamera.position.z,
		1.0/delta]
