extends CSGBox3D

signal hit_event(index)

func hit():
	hit_event.emit(get_index())
