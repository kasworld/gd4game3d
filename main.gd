extends Node3D

func _ready() -> void:
	$DirectionalLight3D.look_at(Vector3.ZERO)
	var b_box = AABB( $BoundBox.position -$BoundBox.size/2, $BoundBox.size)
	$Ball.init( b_box, Vector3.ZERO )
	$MovingCamera.init( b_box, Vector3.ZERO, $Ball )

