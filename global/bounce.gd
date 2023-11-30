extends Node

func bounce(pos :Vector3, vel :Vector3, bound :AABB, radius :float)->Dictionary:
	var bounce :Vector3i
	for i in 3:
		if pos[i] < bound.position[i] + radius :
			pos[i] = bound.position[i] + radius
			vel[i] = abs(vel[i])
			bounce[i] = -1
		elif pos[i] > bound.end[i] - radius:
			pos[i] = bound.end[i] - radius
			vel[i] = -abs(vel[i])
			bounce[i] = 1
	return {
		position = pos,
		velocity = vel,
		bounce = bounce,
	}
