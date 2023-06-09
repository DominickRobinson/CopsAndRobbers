@tool
class_name Player
extends Node2D

signal departed
signal arrived



@export var travel_time: float = 1.0
@export var current_vertex : Vertex = null

@export var skin : Texture2D
@export_enum("person", "cop", "cop-m", "cop-f", "robber", 
				"zombie", "zombie-m", "zombie-f") var character : String = "person"

@export_group("Nodes")
@export var sprite : Sprite2D
@export var anim : AnimationPlayer
@export var label : Label

var moving = false

var movement_tween : Tween

func _ready():
	
	anim.animation_started.connect(_on_animation_started)
	anim.play("idle")
	
	if skin != null:
		sprite.texture = skin


func _unhandled_input(event):
	if moving and Input.is_action_just_pressed("select"):
		movement_tween.set_speed_scale(2)
		await movement_tween.finished
		movement_tween.set_speed_scale(1)

func move_to(new_vertex:Vertex):
	if moving: return
	moving = true
	if is_instance_valid(current_vertex):
		current_vertex.occupents.erase(self)
	
	current_vertex = new_vertex
	
	movement_tween = get_tree().create_tween()
	movement_tween.tween_property(self, "global_position", new_vertex.global_position, travel_time)
	anim.play("move")
	departed.emit()
	
	await movement_tween.finished
	anim.play("idle")
	current_vertex.occupents.append(self)
	
	arrived.emit()
	moving = false


func _on_animation_started(anim_name):
	if anim_name == "RESET":
		return
	anim.play("RESET")
	anim.animation_started.disconnect(_on_animation_started)
	await anim.animation_finished
	anim.play(anim_name)
	anim.animation_started.connect(_on_animation_started)


func play_final_animation(anim_name):
	anim.play("RESET")
	anim.animation_started.disconnect(_on_animation_started)
	await anim.animation_finished
	anim.play(anim_name)
	return true
