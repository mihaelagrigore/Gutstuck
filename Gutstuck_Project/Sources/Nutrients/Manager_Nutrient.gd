extends Node

var F_Nutrient = load("res://Sources/Nutrients/F_Nutrients/F_Nutrient.tscn")
var P_Nutrient = load("res://Sources/Nutrients/P_Nutrients/P_Nutrient.tscn")

var msk_range = 5
var Spawn_Nutrient
var spawn_position_size = 100

func _ready():
	pass


func personal_init():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var extra = 300

	for i in range(msk_range):
		var temp_nutrients = F_Nutrient.instance()
		add_child(temp_nutrients)
		
		var temp_spawn_location_index = rng.randi_range(0, Spawn_Nutrient.get_children().size()-1)
		var temp_spawn_location_object = Spawn_Nutrient.get_child(temp_spawn_location_index)
		temp_nutrients.position = Vector2(rng.randf_range(temp_spawn_location_object.position.x, temp_spawn_location_object.position.x + spawn_position_size), rng.randf_range(temp_spawn_location_object.position.y, temp_spawn_location_object.position.y + spawn_position_size))
	
	for i in range(msk_range):
		var temp_nutrients = P_Nutrient.instance()
		add_child(temp_nutrients)
		
		var temp_spawn_location_index = rng.randi_range(0, Spawn_Nutrient.get_children().size()-1)
		var temp_spawn_location_object = Spawn_Nutrient.get_child(temp_spawn_location_index)
		temp_nutrients.position = Vector2(rng.randf_range(temp_spawn_location_object.position.x, temp_spawn_location_object.position.x + spawn_position_size), rng.randf_range(temp_spawn_location_object.position.y, temp_spawn_location_object.position.y + spawn_position_size))
		
	
func _process(delta):
	var Group_F_Nutrients=get_tree().get_nodes_in_group("F_Nutrients");
	var Group_P_Nutrients=get_tree().get_nodes_in_group("P_Nutrients");
	#if bacteria_state is STATE_REPLICATING, duplicate node
