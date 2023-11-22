extends Button


func pause():
	PauseManager.pause()

func toggle(p:bool):
	if p:
		PauseManager.pause()
	else:
		PauseManager.unpause()
