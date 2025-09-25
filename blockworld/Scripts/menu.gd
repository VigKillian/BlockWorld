extends Control

const scene3D : PackedScene = preload("res://Scenes/BlockScene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_lancer_pressed() -> void:
	get_tree().change_scene_to_packed(scene3D)

func _on_quitter_pressed() -> void:
	get_tree().quit()
