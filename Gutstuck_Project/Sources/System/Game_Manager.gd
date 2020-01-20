extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var camera = get_node("Camera2D")
var firstTimePlayButtonPressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("sequence 1")
	get_node("Bacteria_Manager").input_manager = get_node("Input_Manager")
	get_node("Bacteria_Manager").Spawn_Location_Container = get_node("Spawn_Location_Container")
	get_node("Manager_Nutrients").Spawn_Nutrient = get_node("Spawn_Nutrient")
	get_node("Input_Manager").Bacteria_Manager_Reference = get_node("Bacteria_Manager")
	get_node("Manager_Nutrients").Spawn_Bacteria = get_node("Spawn_Location_Container")
	get_node("Menu").game_manager = self
	get_node("Menu").personal_init()
	get_node("Bacteria_Manager").personal_init()
	get_node("Manager_Nutrients").personal_init()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Pause_Button_pressed():
	start_pause_mode()
	camera_to_top()

func camera_to_bottom():
	$AnimationPlayer.play("Camera_to_bottom")
	get_node("Menu/Popup").hide_all_children()

func camera_to_top():
	$AnimationPlayer.play("Camera_to_top")

func exit_pause_mode():
	get_tree().paused = false

func start_pause_mode():
	get_tree().paused = true

func intro_explanation_hide():
	if !firstTimePlayButtonPressed && has_node("Menu/Real_Intro_Explanation"):
		get_node("Menu/Real_Intro_Explanation").hide()
		get_node("Menu/ScrollContainer").show()
		firstTimePlayButtonPressed = true