extends Node

var F_Nutrient = load("res://Sources/Nutrients/F_Nutrients/F_Nutrient.tscn")
var P_Nutrient = load("res://Sources/Nutrients/P_Nutrients/P_Nutrient.tscn")

var msk_range = 5

func _ready():
	var rng = RandomNumberGenerator.new()
	var extra = 300

	for i in range(msk_range):
		var temp_nutrients = F_Nutrient.instance()
		add_child(temp_nutrients)
		temp_nutrients.position = Vector2(rng.randf_range(-extra, extra),rng.randf_range(-extra, extra))
	for i in range(msk_range):
		var temp_nutrients = P_Nutrient.instance()
		add_child(temp_nutrients)
		temp_nutrients.position = Vector2(rng.randf_range(-extra, extra),rng.randf_range(-extra, extra))
	
func _process(delta):
	var Group_F_Nutrients=get_tree().get_nodes_in_group("F_Nutrients");
	var Group_P_Nutrients=get_tree().get_nodes_in_group("P_Nutrients");
	#if bacteria_state is STATE_REPLICATING, duplicate node
