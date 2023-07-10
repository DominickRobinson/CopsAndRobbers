extends PanelContainer

@export var graph : Graph
@onready var begin_button : Button = $BeginButton

@onready var title_label : Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/TitleLabel
@onready var author_label : Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/AuthorLabel
@onready var description_label : Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/DescriptionLabel

func _ready():
	
	hide()
	
	begin_button.pressed.connect(_on_button_pressed)
	
	await graph.created
	
	if graph.title != "":
		title_label.text = graph.title
		author_label.text = "by " + graph.author
		description_label.text = graph.description
		show()


func _on_button_pressed():
	hide()

