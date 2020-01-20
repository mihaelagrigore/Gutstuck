extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var text_introduction = get_node("Game_Manager/Text_introduction")

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	get_tree().paused = true

func _ready():
	toogle_first_explanation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_pressed():
	print()
	get_tree().paused = false
	toogle_first_explanation()


func toogle_first_explanation():
	text_introduction.visible = !text_introduction.visible