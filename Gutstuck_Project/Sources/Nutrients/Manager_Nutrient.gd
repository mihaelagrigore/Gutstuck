extends Node

var F_Nutrient = load("res://Sources/Nutrients/F_Nutrients/F_Nutrient.tscn")
var P_Nutrient = load("res://Sources/Nutrients/P_Nutrients/P_Nutrient.tscn")

var msk_range = 5
var msk_population_size = 10

var Spawn_Nutrient
var spawn_position_size = 100


func _ready():
	$Spawn_Timer.start()
	pass


func personal_init():
	for i in range(msk_range):
		var temp_nutrient = F_Nutrient.instance()
		choose_spawn_location(temp_nutrient)
		add_child(temp_nutrient)
		
	for i in range(msk_range):
		var temp_nutrient = P_Nutrient.instance()
		choose_spawn_location(temp_nutrient)
		add_child(temp_nutrient)
	
func _process(delta):
	pass

func choose_spawn_location(temp_nutrient: Nutrient):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var temp_spawn_location_index = rng.randi_range(0, Spawn_Nutrient.get_children().size()-1)
	var temp_spawn_location_object = Spawn_Nutrient.get_child(temp_spawn_location_index)
	temp_nutrient.position = Vector2(rng.randf_range(temp_spawn_location_object.position.x, temp_spawn_location_object.position.x + spawn_position_size), rng.randf_range(temp_spawn_location_object.position.y, temp_spawn_location_object.position.y + spawn_position_size))
	

func _on_Spawn_Timer_timeout() -> void:
	if get_child_count() < msk_population_size:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var nutrient_type = rng.randi_range(0,1)
		print(str("Random number is: ", nutrient_type))
		
		match nutrient_type:
			0:
				var temp_nutrient = F_Nutrient.instance()
				choose_spawn_location(temp_nutrient)
				add_child(temp_nutrient)
			1:
				var temp_nutrient = P_Nutrient.instance()
				choose_spawn_location(temp_nutrient)
				add_child(temp_nutrient)