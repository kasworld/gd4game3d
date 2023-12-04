extends Node3D

var ball_scene = preload("res://ball/ball.tscn")

const BALL_COUNT = 10
var ball_list = []
var b_box :AABB
func _ready() -> void:
	$DirectionalLight3D.look_at(Vector3.ZERO)
	b_box = AABB( $BoundBox.position -$BoundBox.size/2, $BoundBox.size)
	add_ball()
	$MovingCamera.init( b_box, Vector3.ZERO, ball_list[0] )

func add_ball()->void:
	var ball = ball_scene.instantiate()
	ball.init( b_box, Vector3.ZERO )
	ball_list.append(ball)
	add_child(ball)

func _process(delta: float) -> void:
	if ball_list.size() < BALL_COUNT:
		add_ball()

	$LabelInfo.text = "Ball %d\n(%.1f,%.1f,%.1f)" % [
		ball_list.size(),
		$MovingCamera.position.x, $MovingCamera.position.y, $MovingCamera.position.z]
