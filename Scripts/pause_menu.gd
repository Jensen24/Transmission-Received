extends Control

signal resume_game

func _on_resume_pressed() -> void:
	emit_signal("resume_game")

func _on_quit_pressed() -> void:
	get_tree().quit()
