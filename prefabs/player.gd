extends CharacterBody3D

@export_group("Sensitivity")
@export var mouse_sensitivity_x := 5.0
@export var mouse_sensitivity_y := 5.0
@export var enable_mouse_smoothing := true
@export var mouse_smoothing_frames := 5
var recent_mouse_movements := []

@export var camera: Camera3D
@onready var head := $Head

var mouse_delta: Vector2
var mouse_move_handled := true

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta):
	if mouse_move_handled:
		return

	if enable_mouse_smoothing:
		recent_mouse_movements.append(mouse_delta)
		if recent_mouse_movements.size() > mouse_smoothing_frames:
			recent_mouse_movements.pop_front()

		update_mouse_look(get_average_mouse_movement(), get_process_delta_time())
	else:
		update_mouse_look(mouse_delta, get_process_delta_time())

	mouse_move_handled = true


func _unhandled_input(event):
	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

	if event.is_action_pressed("quit"):
		get_tree().quit()

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_delta = event.relative
		mouse_move_handled = false


func update_mouse_look(mouse_motion: Vector2, delta: float):
	head.rotate_y(deg_to_rad(-mouse_motion.x * mouse_sensitivity_x / 100))
	camera.rotate_x(deg_to_rad(-mouse_motion.y * mouse_sensitivity_y / 100))
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-85.0), deg_to_rad(90.0))


func get_average_mouse_movement() -> Vector2:
	var avg_motion: Vector2 = Vector2.ZERO
	for motion in recent_mouse_movements:
		avg_motion += motion
	return avg_motion / recent_mouse_movements.size()
