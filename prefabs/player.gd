class_name Player extends CharacterBody3D

const SETTINGS_PATH := "user://settings.tres"

@export var mouse_smoothing_frames := 5
var recent_mouse_movements := []

@export var camera: Camera3D

@onready var head := $Head

@onready var settings_ui := %Settings
@onready var sens_slider = %Sens
@onready var sens_label = %"Sens label"

var mouse_delta: Vector2
var mouse_move_handled := true
var settings: Settings

var temp_sens: float

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if ResourceLoader.exists(SETTINGS_PATH):
		settings = ResourceLoader.load(SETTINGS_PATH)
	else:
		settings = ResourceLoader.load("res://resources/default_settings.tres")

	temp_sens = settings.mouse_sens_x
	sens_slider.value = temp_sens
	sens_label.text = "Sensitivity (%s)" % str(temp_sens)

func _process(delta):
	if mouse_move_handled:
		return

	if settings.enable_mouse_smoothing:
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

	if event.is_action_pressed("menu"):
		if settings_ui.visible:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

		settings_ui.visible = !settings_ui.visible

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_delta = event.relative
		mouse_move_handled = false


func update_mouse_look(mouse_motion: Vector2, delta: float):
	head.rotate_y(deg_to_rad(-mouse_motion.x * settings.mouse_sens_x / 100))
	camera.rotate_x(deg_to_rad(-mouse_motion.y * settings.mouse_sens_y / 100))
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-85.0), deg_to_rad(90.0))


func get_average_mouse_movement() -> Vector2:
	var avg_motion: Vector2 = Vector2.ZERO
	for motion in recent_mouse_movements:
		avg_motion += motion
	return avg_motion / recent_mouse_movements.size()

func _on_sens_value_changed(value):
	temp_sens = value # Replace with function body.
	sens_label.text = "Sensitivity (%s)" % str(value)


func _on_button_pressed():
	if temp_sens != settings.mouse_sens_x:
		settings.mouse_sens_x = temp_sens
		settings.mouse_sens_y = temp_sens

		ResourceSaver.save(settings, SETTINGS_PATH)
