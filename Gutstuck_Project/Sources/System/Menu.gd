extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var game_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func personal_init():
	print(game_manager)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MenuButton_pressed(extra_arg_0):
	pass # Replace with function body.


func _on_Play_Button_pressed():
	game_manager.camera_to_bottom()
