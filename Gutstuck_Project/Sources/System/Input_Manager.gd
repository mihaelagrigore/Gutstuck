extends Control

# get reference to scene camera
export (NodePath) var cameraPath
# create ColorRect node
var colorRect = ColorRect.new()

# initialisation of initialPos (where player start clicking) and currentPos (current mouse position)
var initialPos = Vector2(0,0)
var currentPos = Vector2(0,0)

# parameter to configure the color of the selection box : red, green, blue, transparency (between 0 and 1)
export var box_color = Color(1,1,1,0.1)


var camera
var selectableObjects = []
var selectedObjects = []


func _ready():
	if cameraPath != null:
		camera = get_node(cameraPath)
	else:
		print("no camera path")
	set_process_input(true)
	add_child(colorRect)
	colorRect.color = box_color

func _input(event):
	CreateBox()


func CreateBox():
	if(Input.is_action_just_pressed("Main_Command")):
		initialPos = get_global_mouse_position()
		#currentPos = get_global_mouse_position()
		colorRect.set_begin(initialPos)
	elif(Input.is_action_pressed("Main_Command")):
		currentPos = get_global_mouse_position()
		colorRect.set_begin(Vector2(min(initialPos.x, currentPos.x), min(initialPos.y, currentPos.y)))
		colorRect.set_end(Vector2(max(initialPos.x, currentPos.x), max(initialPos.y, currentPos.y)))
	elif(Input.is_action_just_released("Main_Command")):
		#SelectObjects()
		colorRect.set_begin(Vector2(0,0))
		colorRect.set_end(Vector2(0,0))
		initialPos = Vector2(0,0)
		currentPos = Vector2(0,0)


func SelectObjects():
	var selfRect = colorRect.get_rect()
	print(selfRect)
	for f_bacteria in get_tree().get_nodes_in_group("F_Bacteria"):
		f_bacteria.emit_signal("select", selfRect.has_point(f_bacteria.get_pos()))