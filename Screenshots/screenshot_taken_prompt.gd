extends CanvasLayer


@onready var anim = $AnimationPlayer

func _ready():
	anim.play("screenshot_taken")
	
	await anim.animation_finished
	
	queue_free()
