extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var camera = get_node("Camera2D")
onready var animationplayer = get_tree().get_root().get_node("Level_1/AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Pause_Button_pressed():
	start_pause_mode()

func start_pause_mode():
	pass