extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var F_Bacteria = load("res://Sources/Bacteria/F_Bacteria/F_Bacteria.tscn")
var G_Bacteria = load("res://Sources/Bacteria/G_Bacteria/G_Bacteria.tscn")
var P_Bacteria = load("res://Sources/Bacteria/P_Bacteria/P_Bacteria.tscn")

var msk_range = 10

var spawn_position_size = 100

var input_manager
var Spawn_Location_Container

func _ready():
	pass

func personal_init():
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	for i in range(msk_range):
		rng.randomize()
		var temp_bacteria = F_Bacteria.instance()
		var temp_spawn_location_index = rng.randi_range(0, Spawn_Location_Container.get_children().size()-1)
		var temp_spawn_location_object = Spawn_Location_Container.get_child(temp_spawn_location_index)
		add_child(temp_bacteria)
		temp_bacteria.position = Vector2(rng.randf_range(temp_spawn_location_object.position.x, temp_spawn_location_object.position.x + spawn_position_size), rng.randf_range(temp_spawn_location_object.position.y, temp_spawn_location_object.position.y + spawn_position_size))
		
		temp_bacteria.connect( "duplicate", self, "_on_bacteria_division" )
		temp_bacteria.connect( "die", input_manager, "_on_die" )
	for i in range(msk_range):
		rng.randomize()
		var temp_bacteria = G_Bacteria.instance()
		var temp_spawn_location_index = rng.randi_range(0, Spawn_Location_Container.get_children().size()-1)
		var temp_spawn_location_object = Spawn_Location_Container.get_child(temp_spawn_location_index)
		add_child(temp_bacteria)
		temp_bacteria.position = Vector2(rng.randf_range(temp_spawn_location_object.position.x, temp_spawn_location_object.position.x + spawn_position_size), rng.randf_range(temp_spawn_location_object.position.y, temp_spawn_location_object.position.y + spawn_position_size))
		
		temp_bacteria.connect( "duplicate", self, "_on_bacteria_division" )
		temp_bacteria.connect( "die", input_manager, "_on_die" )
	for i in range(msk_range):
		rng.randomize()
		var temp_bacteria = P_Bacteria.instance()
		var temp_spawn_location_index = rng.randi_range(0, Spawn_Location_Container.get_children().size()-1)
		var temp_spawn_location_object = Spawn_Location_Container.get_child(temp_spawn_location_index)
		add_child(temp_bacteria)
		temp_bacteria.position = Vector2(rng.randf_range(temp_spawn_location_object.position.x, temp_spawn_location_object.position.x + spawn_position_size), rng.randf_range(temp_spawn_location_object.position.y, temp_spawn_location_object.position.y + spawn_position_size))
		
		temp_bacteria.connect( "duplicate", self, "_on_bacteria_division" )
		temp_bacteria.connect( "die", input_manager, "_on_die" )


func _process(delta):
	var Group_F_Bacteria=get_tree().get_nodes_in_group("F_Bacteria");
#	print(str("found: ", Group_F_Bacteria));
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
	
func _on_bacteria_division(mother: Bacteria):
	var motherPosition = mother.position
	print(str("mother position: ", motherPosition))
	pass
	