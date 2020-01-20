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

func _process(delta):
	pass

func personal_init():
	var rng = RandomNumberGenerator.new()
	for i in range(msk_range): #fiber bacterias
		var temp_bacteria = F_Bacteria.instance()
		choose_spawn_location(temp_bacteria, Vector2())
		add_child(temp_bacteria)
		
	for i in range(msk_range): #generalist bacterias
		var temp_bacteria = G_Bacteria.instance()
		choose_spawn_location(temp_bacteria, Vector2())
		add_child(temp_bacteria)
	
	for i in range(msk_range): #protein bacterias
		var temp_bacteria = P_Bacteria.instance()
		choose_spawn_location(temp_bacteria, Vector2())
		add_child(temp_bacteria)

func choose_spawn_location(temp_bacteria: Bacteria, position: Vector2):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if (!position): #for bacteria spawned @game start or @random times
		var temp_spawn_location_index = rng.randi_range(0, Spawn_Location_Container.get_children().size()-1)
		var temp_spawn_location_object = Spawn_Location_Container.get_child(temp_spawn_location_index)
		temp_bacteria.position = Vector2(rng.randf_range(temp_spawn_location_object.position.x, temp_spawn_location_object.position.x + spawn_position_size), rng.randf_range(temp_spawn_location_object.position.y, temp_spawn_location_object.position.y + spawn_position_size))
	else:			#for bacteria spwaned by duplication
		var temp_x_origin = position.x - spawn_position_size/2
		var temp_y_origin = position.y - spawn_position_size/2
		temp_bacteria.position = Vector2(rng.randf_range(temp_x_origin, temp_x_origin + spawn_position_size), rng.randf_range(temp_y_origin, temp_y_origin + spawn_position_size))
		pass
			
	temp_bacteria.connect( "duplicate", self, "_on_bacteria_division" )
	temp_bacteria.connect( "die", input_manager, "_on_die" )

	
func _on_bacteria_division(mother: Bacteria):
	var motherPosition = mother.position
	print(str("mother position: ", motherPosition))
	
	var child_bacteria
	
	#instantiate the right bacteria type
	if mother.is_in_group("F_Bacteria"): 
	 	child_bacteria = F_Bacteria.instance()
	elif mother.is_in_group("P_Bacteria"): 
		child_bacteria = P_Bacteria.instance()
	else: 
		child_bacteria = G_Bacteria.instance()
	
	#choose spawing location for the child	
	choose_spawn_location(child_bacteria, motherPosition)
	
	#set attributes for post-partum mother
	mother.energy_level = mother.INITIAL_ENERGY
	mother.update_energy_bar(mother.energy_level)
	mother.get_node("Energy").text = str(mother.energy_level)
	mother.state_set(mother.STATE_CHILL)
	
	#set attributes for new child 
	child_bacteria.energy_level = child_bacteria.INITIAL_ENERGY
	#child_bacteria.update_energy_bar(child_bacteria.energy_level)
	child_bacteria.get_node("EnergyLevel").value = child_bacteria.energy_level
	child_bacteria.get_node("Energy").text = str(child_bacteria.energy_level)
	child_bacteria.state_set(mother.STATE_CHILL)
	
	add_child(child_bacteria)
	
	

	