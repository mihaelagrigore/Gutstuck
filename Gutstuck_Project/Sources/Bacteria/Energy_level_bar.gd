extends TextureProgress
onready var energy_level_bar = $Energy_level_bar


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_energy_bar(value: int):
	energy_level_bar.value=value
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
