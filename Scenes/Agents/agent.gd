@tool
class_name Agent
extends Node2D

signal departed
signal arrived

signal caught


@export_enum("Cop", "Robber") var mode : String = "Cop"

@export var is_arsonist : bool = false

@export var travel_time: float = 1.0
@export var current_vertex : Vertex = null



@export_enum("person", "cop", "cop-m", "cop-f", "robber", 
				"zombie", "zombie-m", "zombie-f") var skin : String = "person"

@export_group("Skins")
@export var person_skin : Texture2D
@export var cop_skin : Texture2D
@export var cop_m_skin : Texture2D
@export var cop_f_skin : Texture2D
@export var robber_skin : Texture2D
@export var zombie_skin : Texture2D
@export var zombie_m_skin : Texture2D
@export var zombie_f_skin : Texture2D


@export_group("Nodes")
@export var sprite : Sprite2D
@export var anim : AnimationPlayer
@export var label : Label

var moving = false
var captured = false

var movement_tween : Tween


func _ready():
	match mode:
		"Cop":
			add_to_group("Cops")
		"Robber":
			add_to_group("Robbers")
	
	match skin:
		"person":
			sprite.texture = person_skin
		"cop":
			sprite.texture = cop_skin
		"cop-m":
			sprite.texture = cop_m_skin	
		"cop-f":
			sprite.texture = cop_f_skin
		"robber":
			sprite.texture = robber_skin
		"zombie":
			sprite.texture = zombie_skin
		"zombie-m":
			sprite.texture = zombie_m_skin
		"zombie-f":
			sprite.texture = zombie_f_skin
	
#	print(self.name, ": ", get_groups())
	
	anim.animation_started.connect(_on_animation_started)
	anim.play("idle")

	


func _unhandled_input(event):
	if moving and Input.is_action_just_pressed("select"):
		movement_tween.set_speed_scale(2)
		await movement_tween.finished
		movement_tween.set_speed_scale(1)


func get_captured():
	captured = true
	caught.emit()
	play_final_animation("captured")


func capture(robber:Agent):
	play_final_animation("capture")
	
#	await anim.animation_finished
	
	robber.get_captured()
	
#	await robber.caught
	

func check_for_robbers():
	if not is_instance_valid(current_vertex): return
	
	for o in current_vertex.get_occupents():
#		print(o.name, ": ", o.is_robber())
		if o.is_robber():
			if not o.captured:
				capture(o)


func move_to(new_vertex:Vertex):
	
	var old_vtx = current_vertex
	
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
	
	#check whether to burn previously occupied vertex
	if is_arsonist and is_instance_valid(old_vtx) and old_vtx.get_occupents().size() == 0:
		old_vtx.burn()
	
#	print("Just moved... ", self.name, ": ", get_groups())


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


func is_cop():
	return (mode == "Cop")

func is_robber():
	return (mode == "Robber")

func get_neighbors():
	if is_instance_valid(current_vertex):
		return current_vertex.get_neighbors()
	else:
		return []

func get_vertex():
	return current_vertex
