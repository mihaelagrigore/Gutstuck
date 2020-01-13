extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var F_Bacteria = load("res://Sources/Bacteria/F_Bacteria/F_Bacteria.tscn")
var G_Bacteria = load("res://Sources/Bacteria/G_Bacteria/G_Bacteria.tscn")
var P_Bacteria = load("res://Sources/Bacteria/P_Bacteria/P_Bacteria.tscn")

var msk_range = 10
# Called when the node enters the scene tree for the first time.
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
