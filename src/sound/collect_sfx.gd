extends AudioStreamPlayer


func _on_finished() -> void:
	stop()
	queue_free()
