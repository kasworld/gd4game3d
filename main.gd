extends Node3D

func _ready() -> void:
	$Ball.init( AABB( $BoundBox.position -$BoundBox.size/2, $BoundBox.size), Vector3.ZERO )

func _process(delta: float) -> void:
	$Camera3D.look_at($Ball.position)
