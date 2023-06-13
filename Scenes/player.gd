class_name Player
extends Node2D

signal arrived

@export var travel_time: float = 1.0

@export_group("Nodes")
@export var sprite : Sprite2D
@export var anim : AnimationPlayer


var current_vertex : Vertex = null :
	set(value):
		current_vertex = value
		#initial placement
		if current_vertex == null:
			global_position = value.global_position
		else:
			move_to(current_vertex)


func _ready():
	anim.animation_started.connect(_on_animation_started)
	anim.play("idle")

func move_to(new_vertex:Vertex):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", new_vertex.global_position, travel_time)
	anim.play("move")
	
	await tween.finished
	arrived.emit()
	anim.play("idle")


func _on_animation_started(anim_name):
	if anim_name == "RESET":
		return
	anim.play("RESET")
	anim.animation_started.disconnect(_on_animation_started)
	await anim.animation_finished
	anim.play(anim_name)
	anim.animation_started.connect(_on_animation_started)
