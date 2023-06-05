extends Button


func pause():
	PauseManager.pause()

func toggle(pressed:bool):
	if pressed:
		PauseManager.pause()
	else:
		PauseManager.unpause()
