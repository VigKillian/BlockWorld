extends Node3D

@export var rotation_speed : float = 1.5
@export var move_speed : float = 5.0
@export var max_pitch : float = 80.0
@export var min_pitch : float = -80.0

var pitch_node : Node3D
var camera : Camera3D

func _ready() -> void:
	pitch_node = $CameraPitch
	camera = pitch_node.get_node("Camera3D")

func _process(delta: float) -> void:
	if Input.is_action_pressed("camera_left"):
		rotate_y(rotation_speed * delta)
	if Input.is_action_pressed("camera_right"):
		rotate_y(-rotation_speed * delta)

	var pitch_deg = pitch_node.rotation_degrees.x
	if Input.is_action_pressed("camera_up") and pitch_deg > min_pitch:
		pitch_node.rotate_x(rotation_speed * delta)
	if Input.is_action_pressed("camera_down") and pitch_deg < max_pitch:
		pitch_node.rotate_x(-rotation_speed * delta)

	var forward = -camera.global_transform.basis.z.normalized()
	var right = camera.global_transform.basis.x.normalized()
	var up = camera.global_transform.basis.y.normalized()

	if Input.is_action_pressed("camera_move_front"):
		global_position += forward * move_speed * delta
	if Input.is_action_pressed("camera_move_back"):
		global_position -= forward * move_speed * delta
	if Input.is_action_pressed("camera_move_left"):
		global_position -= right * move_speed * delta
	if Input.is_action_pressed("camera_move_right"):
		global_position += right * move_speed * delta
	if Input.is_action_pressed("camera_move_up"):
		global_position += up * move_speed * delta
	if Input.is_action_pressed("camera_move_down"):
		global_position -= up * move_speed * delta
