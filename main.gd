extends Node3D

func _ready() -> void:
	$Ball.init( AABB( $BoundBox.position -$BoundBox.size/2, $BoundBox.size), Vector3.ZERO )
	$MovingCamera.init( AABB( $BoundBox.position -$BoundBox.size/2, $BoundBox.size), Vector3.ZERO, $Ball )

