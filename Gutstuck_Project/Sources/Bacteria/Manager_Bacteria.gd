extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var F_Bacteria = load("res://Sources/Bacteria/F_Bacteria/F_Bacteria.tscn")
var G_Bacteria = load("res://Sources/Bacteria/G_Bacteria/G_Bacteria.tscn")
var P_Bacteria = load("res://Sources/Bacteria/P_Bacteria/P_Bacteria.tscn")

var msk_range = 10

func _ready():
	var rng = RandomNumberGenerator.new()

	for i in range(msk_range):
		var temp_bacteria = F_Bacteria.instance()
		add_child(temp_bacteria)
		temp_bacteria.position = Vector2(rng.randf_range(-300.0, 300.0),rng.randf_range(-300.0, 300.0))
	for i in range(msk_range):
		var temp_bacteria = G_Bacteria.instance()
		add_child(temp_bacteria)
		temp_bacteria.position = Vector2(rng.randf_range(-300.0, 300.0),rng.randf_range(-300.0, 300.0))
	for i in range(msk_range):
		var temp_bacteria = P_Bacteria.instance()
		add_child(temp_bacteria)
		temp_bacteria.position = Vector2(rng.randf_range(-300.0, 300.0),rng.randf_range(-300.0, 300.0))


func _process(delta):
	var Group_F_Bacteria=get_tree().get_nodes_in_group("F_Bacteria");
	print(str("found: ", Group_F_Bacteria));
	var Group_G_Bacteria=get_tree().get_nodes_in_group("G_Bacteria");
	var Group_P_Bacteria=get_tree().get_nodes_in_group("P_Bacteria");
	#if bacteria_state is STATE_REPLICATING, duplicate node
	for bacteria in Group_F_Bacteria:
		if bacteria.state==4:
			var temp_position=bacteria.position
			var temp_bacteria = F_Bacteria.instance()
			add_child(temp_bacteria)
			temp_bacteria.position = temp_position
	pass