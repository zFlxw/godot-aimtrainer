extends RayCast3D

func _physics_process(delta):
	if is_colliding():
		var collider := get_collider()
		if !(collider.is_in_group("Gridbox")):
			return

		if Input.is_action_just_pressed("shoot"):
			collider.hit()
