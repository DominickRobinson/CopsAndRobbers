extends Node





func _ready():
	await get_parent().game_start
	
	for c in get_parent().cops:
		c.arrived.connect(check_for_robbers)
	for r in get_parent().robbers:
		r.arrived.connect(check_for_robbers)

func check_for_robbers():
	for c in get_parent().cops:
		await c.check_for_robbers()

