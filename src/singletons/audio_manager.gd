class_name AudioManager extends Node

# Sound effects here
#static var _absorb_sound: Resource = preload('')
static var pickup_sound: Resource = preload('res://assets/audio/PickUp.mp3')

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
	_playback = player.get_stream_playback() as AudioStreamPlaybackPolyphonic

	get_tree().node_added.connect(_on_node_added)


func _on_node_added(node: Node) -> void:
	# Here we can connect to signals to the sound effect functions
	if node.is_in_group("Orbs"):
		print("yay")


# Sound effect functions may look like this
static func play_soundname(theName) -> void:
	if _playback == null:
		return
	if theName == "pickup":
		print("playing")
		_playback.play_stream(pickup_sound, 0.0, 0.0, randf_range(0.9, 1.1))
