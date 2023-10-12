class_name StarContainer
extends HBoxContainer

@onready var star1 = $Star1
@onready var star2 = $Star2
@onready var star3 = $Star3

func _ready():
	hide_star(star1)
	hide_star(star2)
	hide_star(star3)


func hide_star(star:Control):
	star.modulate = Color(1,1,1,0)


func show_star(star:Control):
	var tween = create_tween() as Tween
	tween.tween_property(star, "modulate", Color(1,1,1,1), 0.5)
	await tween.finished
	return true

func show_stars(num:int):
	if num >= 1:
		await show_star(star1)
	if num >= 2:
		await show_star(star2)
	if num >= 3:
		await show_star(star3)
	return true
