extends Node2D

var gameField_Size = Global.gameField_Size
var winLine = Global.winLine

@onready var field = $GameField
@onready var vbox = $GameField/VBox
@onready var grid = $GameField/VBox/Grid
@onready var turnLabel = $GameField/VBox/TurnLabel

var button_texture_normal # Normal (not clicked texture)
var button_texture_x
var button_texture_0

var lineLenght
enum BUTTON_STATE { NONE, X, NULL} # Use NULL because can't use 0
var gameField = {}
var gameArray = []
var drawCondition = false

# Called when the node enters the scene tree for the first time.
func _ready():
	button_texture_normal = preload("res://graphics/generic_button_square_outline.png")
	button_texture_x = preload("res://graphics/keyboard_x_outline.png")
	button_texture_0 = preload("res://graphics/keyboard_0_outline.png")
	lineLenght = int(sqrt(gameField_Size))
	if(gameField_Size % lineLenght == 0):
		create_game_field(gameField_Size)
		update_TurnLabel()
	else:
		push_error("Неправильное кол-во клеток! Используй 4/9/16 и т.п.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func create_game_field(size):
	var i = 1
	print("Create game field " + str(lineLenght) + " x " + str(lineLenght))
	grid.columns = lineLenght
#	while i < size:
#		for k in lineLenght:
#			
#			pass
#		pass
	while i <= size:
		create_button(i)
		i += 1
	for b in get_node("GameField/VBox/Grid").get_children():
		#print(b.get_name())
		b.toggled.connect(self._on_button_toggle.bind(b))

func create_button(i):
	var btn = TextureButton.new()
	btn.name = str("Btn_", i)
	btn.texture_normal = button_texture_normal
	btn.toggle_mode = true
	gameField[btn.get_name()] = BUTTON_STATE.NONE
	grid.add_child(btn)
	print("Created btn: ", i)
#	var line
#	if i <= lineLenght:
#		line = 1
#	elif i > lineLenght and i <= lineLenght * 2:
#		line = 2
#	else:
#		line = 3
	
#	var a = [i % lineLenght, line]
#	gameArray.append(a)
#	print(gameArray)

func _on_button_toggle(button_pressed, btn):
	if(button_pressed):
		print("Pressed: " + btn.get_name())
		if(Global.turn):
			btn.texture_pressed = button_texture_x
			gameField[btn.get_name()] = BUTTON_STATE.X
			Global.turn = false
		else:
			btn.texture_pressed = button_texture_0
			gameField[btn.get_name()] = BUTTON_STATE.NULL
			Global.turn = true
		btn.texture_disabled = btn.texture_pressed
		btn.disabled = true
		checkWin(btn)
		update_TurnLabel()
	else:
		print("Released: " + btn.get_name())

func update_TurnLabel():
	if(Global.turn):
		turnLabel.text = "Ход X"
	else:
		turnLabel.text = "Ход 0"

func checkWin(btn):
	# For first time use dummy win conditions
	if(gameField["Btn_1"] == BUTTON_STATE.X && gameField["Btn_2"] == BUTTON_STATE.X && gameField["Btn_3"] == BUTTON_STATE.X or 
	gameField["Btn_4"] == BUTTON_STATE.X && gameField["Btn_5"] == BUTTON_STATE.X && gameField["Btn_6"] == BUTTON_STATE.X or 
	gameField["Btn_7"] == BUTTON_STATE.X && gameField["Btn_8"] == BUTTON_STATE.X && gameField["Btn_9"] == BUTTON_STATE.X or 
	gameField["Btn_1"] == BUTTON_STATE.X && gameField["Btn_4"] == BUTTON_STATE.X && gameField["Btn_7"] == BUTTON_STATE.X or 
	gameField["Btn_2"] == BUTTON_STATE.X && gameField["Btn_5"] == BUTTON_STATE.X && gameField["Btn_8"] == BUTTON_STATE.X or 
	gameField["Btn_3"] == BUTTON_STATE.X && gameField["Btn_6"] == BUTTON_STATE.X && gameField["Btn_9"] == BUTTON_STATE.X or 
	gameField["Btn_1"] == BUTTON_STATE.X && gameField["Btn_5"] == BUTTON_STATE.X && gameField["Btn_9"] == BUTTON_STATE.X or 
	gameField["Btn_3"] == BUTTON_STATE.X && gameField["Btn_5"] == BUTTON_STATE.X && gameField["Btn_7"] == BUTTON_STATE.X):
		print("X")
	elif(gameField["Btn_1"] == BUTTON_STATE.NULL && gameField["Btn_2"] == BUTTON_STATE.NULL && gameField["Btn_3"] == BUTTON_STATE.NULL or 
	gameField["Btn_4"] == BUTTON_STATE.NULL && gameField["Btn_5"] == BUTTON_STATE.NULL && gameField["Btn_6"] == BUTTON_STATE.NULL or 
	gameField["Btn_7"] == BUTTON_STATE.NULL && gameField["Btn_8"] == BUTTON_STATE.NULL && gameField["Btn_9"] == BUTTON_STATE.NULL or 
	gameField["Btn_1"] == BUTTON_STATE.NULL && gameField["Btn_4"] == BUTTON_STATE.NULL && gameField["Btn_7"] == BUTTON_STATE.NULL or 
	gameField["Btn_2"] == BUTTON_STATE.NULL && gameField["Btn_5"] == BUTTON_STATE.NULL && gameField["Btn_8"] == BUTTON_STATE.NULL or 
	gameField["Btn_3"] == BUTTON_STATE.NULL && gameField["Btn_6"] == BUTTON_STATE.NULL && gameField["Btn_9"] == BUTTON_STATE.NULL or 
	gameField["Btn_1"] == BUTTON_STATE.NULL && gameField["Btn_5"] == BUTTON_STATE.NULL && gameField["Btn_9"] == BUTTON_STATE.NULL or 
	gameField["Btn_3"] == BUTTON_STATE.NULL && gameField["Btn_5"] == BUTTON_STATE.NULL && gameField["Btn_7"] == BUTTON_STATE.NULL):
		print("0")
	else:
		var i = 0
		for b in gameField:
			if(gameField[b] == BUTTON_STATE.NONE):
				i += 1
