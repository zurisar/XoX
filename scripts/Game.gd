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

var gameState
enum GAME_STATE { ON, WINX, WIN0, DRAW, PAUSE}
var gameTurn
var winCombination = []

var lineLenght
enum BUTTON_STATE { NONE, X, NULL} # Use NULL because can't use 0
var buttonsState = {}
var buttonsCord = {}
var drawCondition = false

# Called when the node enters the scene tree for the first time.
func _ready():
	button_texture_normal = preload("res://graphics/generic_button_square_outline.png")
	button_texture_x = preload("res://graphics/keyboard_x_outline.png")
	button_texture_0 = preload("res://graphics/keyboard_0_outline.png")
	start_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func start_game():
	gameState = GAME_STATE.PAUSE # gameState will be ON after field will created
	# Reset vatiables
	gameTurn = 0
	buttonsState.clear()
	buttonsCord.clear()
	winCombination.clear()
	drawCondition = false
	#
	print("Starting game with field size: ", gameField_Size)
	lineLenght = int(sqrt(gameField_Size))
	if(gameField_Size % lineLenght == 0):
		create_game_field(gameField_Size)
		update_TurnLabel()
	else:
		push_error("Неправильное кол-во клеток! Используй 4/9/16 и т.п.")
	pass

func create_game_field(size):
	var i = 1
	print("Create game field " + str(lineLenght) + " x " + str(lineLenght))
	grid.columns = lineLenght
	# Test array[array] buttons
	# p - button number, q - line number
	var p = 0
	var q = 0
	while i <= size: # Because size is sum of all filds, call while while i = size
		while q <= lineLenght - 1:
			while p <= lineLenght - 1:
				var btn = create_button(i)
				var btn_cord_array = [q, p]
				#var btn_array = [btn, btn_cord_array]
				#var btn_array = [q, p]
				#gameArray.append(btn_array)
				p += 1
				i += 1
			q += 1
			p = 0
	#print (gameArray)
	
	
	for b in get_node("GameField/VBox/Grid").get_children():
		#print(b.get_name())
		b.toggled.connect(self._on_button_toggle.bind(b))
	gameState = GAME_STATE.ON

func create_button(i):
	var btn = TextureButton.new()
	btn.name = str("Btn_", i)
	btn.texture_normal = button_texture_normal
	btn.toggle_mode = true
	buttonsState[btn.get_name()] = BUTTON_STATE.NONE
	grid.add_child(btn)
	print("Created btn: ", i)
	return btn

func _on_button_toggle(button_pressed, btn):
	if(gameState == GAME_STATE.ON):
		if(button_pressed):
			if(Global.turn):
				btn.texture_pressed = button_texture_x
				buttonsState[btn.get_name()] = BUTTON_STATE.X
				Global.turn = false
			else:
				btn.texture_pressed = button_texture_0
				buttonsState[btn.get_name()] = BUTTON_STATE.NULL
				Global.turn = true
			btn.texture_disabled = btn.texture_pressed
			btn.disabled = true
			gameTurn += 1
			checkWin(btn)
			update_TurnLabel()
			#print(gameArray[0])
		else:
			print("Что-то пошло сильно не так...")
			pass
	else:
		print("Игра еще не началась или уже закончилась...")
		end_game(winCombination)
		pass

func update_TurnLabel(): #Update label text, take information from condition
	if(Global.turn):
		turnLabel.text = "Ход X"
	else:
		turnLabel.text = "Ход 0"
	if(gameState == GAME_STATE.DRAW):
		turnLabel.text = "Ничья"
	elif(gameState == GAME_STATE.WINX):
		turnLabel.text = "Победа X"
	elif(gameState == GAME_STATE.WIN0):
		turnLabel.text = "Победа 0"

func checkWin(btn):
	# For first time use dummy win conditions
	if(buttonsState["Btn_1"] == BUTTON_STATE.X && buttonsState["Btn_2"] == BUTTON_STATE.X && buttonsState["Btn_3"] == BUTTON_STATE.X or 
	buttonsState["Btn_4"] == BUTTON_STATE.X && buttonsState["Btn_5"] == BUTTON_STATE.X && buttonsState["Btn_6"] == BUTTON_STATE.X or 
	buttonsState["Btn_7"] == BUTTON_STATE.X && buttonsState["Btn_8"] == BUTTON_STATE.X && buttonsState["Btn_9"] == BUTTON_STATE.X or 
	buttonsState["Btn_1"] == BUTTON_STATE.X && buttonsState["Btn_4"] == BUTTON_STATE.X && buttonsState["Btn_7"] == BUTTON_STATE.X or 
	buttonsState["Btn_2"] == BUTTON_STATE.X && buttonsState["Btn_5"] == BUTTON_STATE.X && buttonsState["Btn_8"] == BUTTON_STATE.X or 
	buttonsState["Btn_3"] == BUTTON_STATE.X && buttonsState["Btn_6"] == BUTTON_STATE.X && buttonsState["Btn_9"] == BUTTON_STATE.X or 
	buttonsState["Btn_1"] == BUTTON_STATE.X && buttonsState["Btn_5"] == BUTTON_STATE.X && buttonsState["Btn_9"] == BUTTON_STATE.X or 
	buttonsState["Btn_3"] == BUTTON_STATE.X && buttonsState["Btn_5"] == BUTTON_STATE.X && buttonsState["Btn_7"] == BUTTON_STATE.X):
		print("X")
		gameState = GAME_STATE.WINX
	elif(buttonsState["Btn_1"] == BUTTON_STATE.NULL && buttonsState["Btn_2"] == BUTTON_STATE.NULL && buttonsState["Btn_3"] == BUTTON_STATE.NULL or 
	buttonsState["Btn_4"] == BUTTON_STATE.NULL && buttonsState["Btn_5"] == BUTTON_STATE.NULL && buttonsState["Btn_6"] == BUTTON_STATE.NULL or 
	buttonsState["Btn_7"] == BUTTON_STATE.NULL && buttonsState["Btn_8"] == BUTTON_STATE.NULL && buttonsState["Btn_9"] == BUTTON_STATE.NULL or 
	buttonsState["Btn_1"] == BUTTON_STATE.NULL && buttonsState["Btn_4"] == BUTTON_STATE.NULL && buttonsState["Btn_7"] == BUTTON_STATE.NULL or 
	buttonsState["Btn_2"] == BUTTON_STATE.NULL && buttonsState["Btn_5"] == BUTTON_STATE.NULL && buttonsState["Btn_8"] == BUTTON_STATE.NULL or 
	buttonsState["Btn_3"] == BUTTON_STATE.NULL && buttonsState["Btn_6"] == BUTTON_STATE.NULL && buttonsState["Btn_9"] == BUTTON_STATE.NULL or 
	buttonsState["Btn_1"] == BUTTON_STATE.NULL && buttonsState["Btn_5"] == BUTTON_STATE.NULL && buttonsState["Btn_9"] == BUTTON_STATE.NULL or 
	buttonsState["Btn_3"] == BUTTON_STATE.NULL && buttonsState["Btn_5"] == BUTTON_STATE.NULL && buttonsState["Btn_7"] == BUTTON_STATE.NULL):
		print("0")
		gameState = GAME_STATE.WIN0
	else:
		if(gameTurn == gameField_Size):
			print("DRAW")
			gameState = GAME_STATE.DRAW
	update_TurnLabel()
	
func checkWinNew():
	# fieldLine / 2 - определяем длину проверки вокруг последнего хода
	# if not < 0 отрезаем проверку ниже 0
	pass
func end_game(winCombination):
	if(winCombination != null):
		pass
	else:
		pass
	pass
