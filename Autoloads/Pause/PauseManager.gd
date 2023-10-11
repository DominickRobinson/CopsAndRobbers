extends CanvasLayer

var paused = false

@onready var anim = $AnimationPlayer
@export var pause_menu : Control

func _ready():
	anim.speed_scale = 1000
	unpause()
	anim.speed_scale = 5

func pause():
	pause_menu.show()
	paused = true
	anim.play("fade_in")
	await anim.animation_changed

func unpause():
	anim.play("fade_out")
	await anim.animation_finished
	paused = false
	pause_menu.hide()

func toggle_pause():
	if paused:
		unpause()
	else:
		pause()
