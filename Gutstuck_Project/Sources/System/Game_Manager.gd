extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var camera = get_node("Camera2D")
onready var animationplayer = get_tree().get_root().get_node("Level_1/AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	print("sequence 1")
	get_node("Bacteria_Manager").input_manager = get_node("Input_Manager")
	get_node("Bacteria_Manager").Spawn_Location_Container = get_node("Spawn_Location_Container")
	get_node("Manager_Nutrients").Spawn_Nutrient = get_node("Spawn_Nutrient")
	get_node("Bacteria_Manager").personal_init()
	get_node("Manager_Nutrients").personal_init()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Pause_Button_pressed():
	start_pause_mode()

func start_pause_mode():
	pass