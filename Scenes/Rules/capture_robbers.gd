extends Node





func _ready():
	await get_parent().game_start
	
	for c in get_parent().cops:
		c.arrived.connect(capture_robbers)
	for r in get_parent().robbers:
		r.arrived.connect(capture_robbers)

func capture_robbers():
	for c in get_parent().cops:
		await c.capture_robbers()

