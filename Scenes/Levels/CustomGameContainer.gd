extends Control

@onready var toggle_advanced_button = $ToggleAdvancedButton
var advanced_buttons : Array

func _ready():
	advanced_buttons = get_tree().get_nodes_in_group("AdvancedButtons")
	
	toggle_advanced_button.toggled.connect(_on_toggled)
	
	toggle_advanced_button.toggled.emit(false)

func _on_toggled(toggled):
	for b in advanced_buttons:
		b = b as Control
		b.visible = toggled
	
	if toggled:
		toggle_advanced_button.text = "Hide advanced settings"
	else:
		toggle_advanced_button.text = "Show advanced settings"

