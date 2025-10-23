class_name AudioManager extends Node

# Sound effects here
#static var _absorb_sound: Resource = preload('')

static var _playback: AudioStreamPlaybackPolyphonic


func _enter_tree() -> void:
	# Create an audio player
	var player = AudioStreamPlayer.new()
	add_child(player)

	# Create a polyphonic stream so we can play sounds directly from it
	var stream = AudioStreamPolyphonic.new()
	stream.polyphony = 32
	player.stream = stream
	player.play()

	# Get the polyphonic _playback stream to play sounds
	_playback = player.get_stream_playback()

	get_tree().node_added.connect(_on_node_added)


func _on_node_added(node: Node) -> void:
	# Here we can connect to signals to the sound effect functions
	pass


# Sound effect functions may look like this
#func _play_soundname() -> void:
#	pass
