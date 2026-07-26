extends Node

@export var initial_bgm: AudioStream
@export var sfx_library: Dictionary[String, AudioStream]

const MUSIC_BUS := "Music"
const SFX_BUS := "SFX"

var background_music: AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if initial_bgm: play_background_music(initial_bgm, -10.0)

func play_background_music(stream: AudioStream, volume: float = 0.0) -> void:
	if not stream: return
	
	if background_music:
		if stream == background_music.stream: return

		background_music.queue_free()
		background_music = null

	var stream_player = _create_stream_player(stream, MUSIC_BUS)
	stream_player.volume_db = volume
	stream_player.play()
	background_music = stream_player

	stream_player.tree_exited.connect(
		func():
			if background_music == stream_player:
				background_music = null
	)

func play_sfx(sfx_name: String, volume: float = 0.0, pitch_range: Vector2 = Vector2(1.0, 1.0)) -> AudioStreamPlayer:
	var audio_stream: AudioStream = sfx_library.get(sfx_name)
	if not audio_stream: return null

	var stream_player = _create_stream_player(audio_stream, SFX_BUS)
	stream_player.volume_db = volume
	stream_player.pitch_scale = randf_range(pitch_range.x, pitch_range.y)
	stream_player.play()
	return stream_player

func set_background_volume(value: float) -> void:
	var volume = remap(value, 0, 100, -30, 1)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(MUSIC_BUS), volume)

func set_sfx_volume(value: float) -> void:
	var volume = remap(value, 0, 100, -30, 1)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(SFX_BUS), volume)

func stop_sfx(stream_player: AudioStreamPlayer) -> void:
	if not is_instance_valid(stream_player): return
	stream_player.stop()
	stream_player.queue_free()

func _create_stream_player(stream: AudioStream, bus: String) -> AudioStreamPlayer:
	var stream_player = AudioStreamPlayer.new()
	stream_player.stream = stream
	stream_player.bus = bus
	stream_player.finished.connect(stream_player.queue_free)
	add_child(stream_player)
	return stream_player
