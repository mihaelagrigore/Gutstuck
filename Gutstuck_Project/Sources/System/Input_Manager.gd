extends Control

class_name Input_Manager

signal move_bacteria

# get reference to scene camera
export (NodePath) var cameraPath
# create ColorRect node
var colorRect = ColorRect.new()
var dragging = false

# initialisation of initialPos (where player start clicking) and currentPos (current mouse position)
var initialPos = Vector2(0,0)
var currentPos = Vector2(0,0)

var rightClicPos = Vector2(0,0)

# parameter to configure the color of the selection box : red, green, blue, transparency (between 0 and 1)
export var box_color = Color(1,1,1,1)

var bacterias = []


var camera
var selectableObjects = []
var selectedObjects = []


func _ready():
	#queue_free()
	if cameraPath != null:
		camera = get_node(cameraPath)
	else:
		print("no camera path")
	set_process_input(true)
	add_child(colorRect)
	colorRect.color = box_color


func _process(delta): # problem of "input fired twice" solve thanks to https://github.com/godotengine/godot/issues/24944
	CreateBox()
	Action()


func CreateBox():
	if(Input.is_action_just_pressed("Main_Command")):
		if !bacterias.empty():
			DeselectObjects()
		print("action just pressed")
		initialPos = get_global_mouse_position()
		currentPos = get_global_mouse_position()
		print(str('is_action_just_pressed: ', initialPos))
		colorRect.set_begin(Vector2(min(initialPos.x, currentPos.x), min(initialPos.y, currentPos.y)))
		colorRect.set_end(Vector2(max(initialPos.x, currentPos.x), max(initialPos.y, currentPos.y)))
		colorRect.set_begin(initialPos)
	elif(Input.is_action_pressed("Main_Command")):
		currentPos = get_global_mouse_position()
		print(str('is_action_pressed: ', currentPos))
		colorRect.set_begin(Vector2(min(initialPos.x, currentPos.x), min(initialPos.y, currentPos.y)))
		colorRect.set_end(Vector2(max(initialPos.x, currentPos.x), max(initialPos.y, currentPos.y)))
	elif(Input.is_action_just_released("Main_Command")):
		print(str('is_action_just_released: ', currentPos))
		SelectObjects()
		colorRect.set_begin(Vector2(0,0))
		colorRect.set_end(Vector2(0,0))
		initialPos = Vector2(0,0)
		currentPos = Vector2(0,0)


func Action():
	# Handling right click (Second_Command) to send bacteria at mouse position
	if(Input.is_action_just_pressed("Second_Command")):
		rightClicPos = Vector2(get_global_mouse_position().x,get_global_mouse_position().y)
		SendBacterias(rightClicPos)


# https://www.youtube.com/watch?v=JFQXI3to0b4
func SelectObjects():
	var selfRect = colorRect.get_rect()
	var selfRectSize = selfRect.size.x + selfRect.size.y
	if (!selfRectSize): #it was a single click
		#check if the mouse click position overlap with any bacteria's body
		print("single click")
	else: #it was a mouse dragging
		var temp_bacterias_selected = []
		for bacteria in get_tree().get_nodes_in_group("Bacteria"):
			if(selfRect.has_point(bacteria.position)):
				temp_bacterias_selected.push_back(bacteria)
		if !temp_bacterias_selected.empty():
			for bacteria in temp_bacterias_selected:
				#bacteria.connect("die", self, "_on_die")
				bacteria.substate_set(bacteria.STATE_SELECTED)
				bacterias.push_back(bacteria)
				
func DeselectObjects():
	print(str(bacterias.size(), " bacteria"))
	for bacteria in bacterias:
		bacteria.substate_set(bacteria.STATE_UNSELECTED)
	bacterias.clear()

func _on_die(victim):
	print("die signal")
	if (bacterias.find(victim) >=0):
		print("found the victim. let's erase it")
		bacterias.erase(victim)

func SendBacterias(position):
	for bacteria in bacterias:
		print("sending bacteria to position")
		bacteria.target = position
		bacteria.state_set(bacteria.STATE_MOVING) 
		#emit_signal("move_bacteria")