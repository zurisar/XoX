extends Node

var playerTurn = Global.turn;

func onChangeTurn():
	if(playerTurn):
		playerTurn = false;
	
	else:
		playerTurn = true;

func _button_pressed(btn):
	print("Button pressed: " + btn.getname())

