extends CanvasLayer


@onready var anim = $AnimationPlayer

func _ready():
	fade_in(0.0001)
	
	
	$ColorRect/Node2D/Control2/Robber/AnimationPlayer.play("run")
	$ColorRect/Node2D/Control/Cop/AnimationPlayer.play("run")
	$ColorRect/Node2D/AnimationPlayer.play("default")

func fade_in(time = 0.5):
	anim.speed_scale = 1/time
	anim.play("fade_in")
#	print("Fading in...")
	await anim.animation_finished
#	print("Faded in!")
	return true

func fade_out(time = 0.5):
	anim.speed_scale = 1/time
	anim.play("fade_out")
#	print("Fading out...")
	await anim.animation_finished
#	print("Faded out!")
	return true
