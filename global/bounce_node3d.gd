class_name BounceNode3D extends Node3D

var velocity :Vector3
var area :AABB
var radius :float

func bounce()->Vector3i:
	var bounce :Vector3i
	for i in 3:
		if position[i] < area.position[i] + radius :
			position[i] = area.position[i] + radius
			velocity[i] = abs(velocity[i])
			bounce[i] = -1
		elif position[i] > area.end[i] - radius:
			position[i] = area.end[i] - radius
			velocity[i] = -abs(velocity[i])
			bounce[i] = 1
	return bounce
