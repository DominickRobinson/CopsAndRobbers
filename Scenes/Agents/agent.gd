@tool
class_name Agent
extends Node2D

signal departed
signal arrived

signal caught

@export var show_on_start : bool = false


@export_enum("Cop", "Robber") var mode : String = "Cop"

@export var arsonist : bool = false

var travel_time: float = 0.5
var current_vertex : Vertex = null



@export_group("Nodes")
@export var sprite : Sprite2D
@export var anim : AnimationPlayer
@export var label : Label


var moving = false
var captured = false

var movement_tween : Tween


func _ready():
	
	if show_on_start: show()
	else: hide()
	
	match mode:
		"Cop":
			add_to_group("Cops")
		"Robber":
			add_to_group("Robbers")
	
	label.text = name
	
#	anim.animation_started.connect(_on_animation_started)
	if not show_on_start:
		play_anim("idle")
	


func _unhandled_input(event):
	if moving and Input.is_action_just_pressed("select"):
		movement_tween.set_speed_scale(2)
		await movement_tween.finished
		movement_tween.set_speed_scale(1)


func get_captured():
	play_anim("captured")
	
	#checking for final kill
	var robbers = get_tree().get_nodes_in_group("Robbers")

	var all_on_final_vtx = false
	var final_vtx : Vertex = null
	var count = 0
	for r in robbers: 
#		r = r as Robber
		if final_vtx == null: 
			final_vtx = r.current_vertex
			all_on_final_vtx = true
		elif final_vtx != r.current_vertex: 
			all_on_final_vtx = false
		if not r.captured: count += 1
	
	if all_on_final_vtx or count == 1: anim.speed_scale = 0.4
	
	await anim.animation_finished
#	await anim.animation_finished
	captured = true
	caught.emit()


func capture(robber:Agent):
	play_anim("capture")
	
	robber.get_captured()
	
	await robber.caught
	
	return true


func capture_robbers():
	if not is_instance_valid(current_vertex): return
	
	for o in current_vertex.get_occupents():
		if o.is_robber():
			if not o.captured:
				await capture(o)
	
	return true

func check_for_robbers(include_captured:bool=false):
	if not is_instance_valid(current_vertex): return
	
	for o in current_vertex.get_occupents():
		if o.is_robber():
			if include_captured or not o.captured:
				return true
	
	return false

func move_to(new_vertex:Vertex):
	var old_vtx = current_vertex
	
	if moving: return
	moving = true
	if is_instance_valid(current_vertex) and new_vertex != current_vertex:
		current_vertex.occupents.erase(self)
	
	current_vertex = new_vertex
	
	movement_tween = get_tree().create_tween()
	if visible:
		movement_tween.tween_property(self, "global_position", new_vertex.global_position, travel_time)
	else:
		movement_tween.tween_property(self, "global_position", new_vertex.global_position, 0)
	play_anim("move")
	departed.emit()
	
	if arsonist and is_instance_valid(old_vtx) and old_vtx.get_occupents().size() == 0:
		old_vtx.burn()
	
	#check whether to burn previously occupied vertex
	var audio_player = SoundManager.play_sound("sound_footsteps")
	await movement_tween.finished
	audio_player.stop()
	reset_animation()
	
	if not (self in current_vertex.occupents): 
		current_vertex.occupents.append(self)
	
	if new_vertex.has_cop():
		await capture_robbers()
	
	if new_vertex.is_top and is_robber():
		await anim.animation_finished
	
	arrived.emit()
	
	if not visible: show()
	moving = false
	
	


	


#func _on_animation_started(anim_name):
#	if anim_name == "RESET":
#		return
#	anim.play("RESET")
#	anim.animation_started.disconnect(_on_animation_started)
#	await anim.animation_finished
#	anim.play(anim_name)
#	anim.animation_started.connect(_on_animation_started)

func reset_animation():
	anim.play("RESET")

func play_anim(anim_name):
	reset_animation()
	anim.play(anim_name)


func play_idle():
	play_anim("idle")

func stop_animation():
	anim.stop()

func laugh():
	anim.play("laugh")
	SoundManager.play_sound("sound_laugh")
	await anim.animation_finished
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

func set_sprite(texture:Texture2D):
	sprite.texture = texture
