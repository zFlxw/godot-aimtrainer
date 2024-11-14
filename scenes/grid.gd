extends Node3D

@export var default_material: StandardMaterial3D

var current_target_idx: int
var current_target: Node3D

func _ready():
	for child in get_children():
		child.hit_event.connect(check_hit)

	choose_child()

func choose_child():
	if current_target:
		current_target.material = default_material
		current_target = null

	current_target_idx = randi_range(0, get_child_count()-1)
	var child := get_child(current_target_idx)
	if not child.material:
		child.material = StandardMaterial3D.new()

	child.material.albedo_color = Color.DEEP_PINK
	current_target = child

func check_hit(index):
	if index == current_target_idx:
		Globals.update_score()
		choose_child()
	else:
		print("Hit wrong target")
