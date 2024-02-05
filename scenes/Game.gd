extends Node2D

@onready var vbox = $GameField/HBox/VBox
@onready var grid = $GameField/HBox/Grid
@onready var turnLabel = $GameField/HBox/VBox/TurnLabel
#var btn_1
var button_texture_normal # Normal (not clicked texture)
var button_texture_x
var button_texture_0

# Called when the node enters the scene tree for the first time.
func _ready():
	button_texture_normal = preload("res://graphics/generic_button_square_outline.png")
	button_texture_x = preload("res://graphics/keyboard_x_outline.png")
	button_texture_0 = preload("res://graphics/keyboard_0_outline.png")
	create_button()
	update_TurnLabel()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func create_button(qty = 8): # 8 = 9 buttons, coz of 0-8
	var i = 0
	while i <= qty:
		var btn = TextureButton.new()
		btn.name = str("Btn_", i)
		#btn.text = str(" X ( ", i, " )")
		btn.texture_normal = button_texture_normal
		btn.toggle_mode = true
		grid.add_child(btn)
		print("Created btn: ", i)
		i += 1
	#btn_1.pressed.connect(self._button_pressed(btn_1))
	#btn_1.connect("_pressed", self, "_button_pressed")
	#btn_1.connect()
	for b in get_node("GameField/HBox/Grid").get_children():
		print(b.get_name())
		#b.connect("_on_button_pressed", self)
		b.toggled.connect(self._on_button_toggle.bind(b))
		

func _on_button_toggle(button_pressed, btn):
	if(button_pressed):
		print("Pressed: " + btn.get_name())
		if(Global.turn):
			btn.texture_pressed = button_texture_x
			Global.turn = false
		else:
			btn.texture_pressed = button_texture_0
			Global.turn = true
		btn.texture_disabled = btn.texture_pressed
		btn.disabled = true
		update_TurnLabel()
		
	else:
		print("Released: " + btn.get_name())
		
func update_TurnLabel():
	if(Global.turn):
		turnLabel.text = "Ход X"
	else:
		turnLabel.text = "Ход 0"
