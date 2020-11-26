extends Node


var paused = false

onready var tiles = [
[preload("res://tiles/blueGrid.tscn"), preload("res://menu/icons/temp/blue_grad.png"), "Blue Cube"],
[preload("res://tiles/greenGrid.tscn"), preload("res://menu/icons/temp/green_grad.png"), "Green Cube"], 
[preload("res://tiles/redGrid.tscn"), preload("res://menu/icons/temp/red_oval.png"), "Red Oval"],
[preload("res://tiles/greyGrid.tscn"), preload("res://menu/icons/temp/grey_grad.png"), "Grey Cat"],
[preload("res://tiles/blueGrid.tscn"), preload("res://menu/icons/temp/blue_grad.png"), "Blue George"],
[preload("res://tiles/greenGrid.tscn"), preload("res://menu/icons/temp/green_grad.png"), "Green George"], 
[preload("res://tiles/greyGrid.tscn"), preload("res://menu/icons/temp/grey_grad.png"), "Grey George"],
[preload("res://tiles/redGrid.tscn"), preload("res://menu/icons/temp/red_oval.png"), "Red George"],
[preload("res://tiles/blueGrid.tscn"), preload("res://menu/icons/temp/blue_grad.png"), "Blue Cat"],
[preload("res://tiles/greenGrid.tscn"), preload("res://menu/icons/temp/green_grad.png"), "Green Cat"], 
[preload("res://tiles/greyGrid.tscn"), preload("res://menu/icons/temp/grey_grad.png"), "Grey Cat"],
[preload("res://tiles/redGrid.tscn"), preload("res://menu/icons/temp/red_oval.png"), "Red Cat"],
[preload("res://tiles/blueGrid.tscn"), preload("res://menu/icons/temp/blue_grad.png"), "Blue Sphere"],
[preload("res://tiles/greenGrid.tscn"), preload("res://menu/icons/temp/green_grad.png"), "Green Sphere"], 
[preload("res://tiles/greyGrid.tscn"), preload("res://menu/icons/temp/grey_grad.png"), "Grey Sphere"],
[preload("res://tiles/redGrid.tscn"), preload("res://menu/icons/temp/red_oval.png"), "Red Sphere"],
[preload("res://tiles/blueGrid.tscn"), preload("res://menu/icons/temp/blue_grad.png"), "Blue Jordan"],
[preload("res://tiles/greenGrid.tscn"), preload("res://menu/icons/temp/green_grad.png"), "Green Jordan"], 
[preload("res://tiles/greyGrid.tscn"), preload("res://menu/icons/temp/grey_grad.png"), "Grey Jordan"],
[preload("res://tiles/redGrid.tscn"), preload("res://menu/icons/temp/red_oval.png"), "Red Jordan"],
[preload("res://tiles/blueGrid.tscn"), preload("res://menu/icons/temp/blue_grad.png"), "Blue Queen"],
[preload("res://tiles/greenGrid.tscn"), preload("res://menu/icons/temp/green_grad.png"), "Green Queen"], 
[preload("res://tiles/greyGrid.tscn"), preload("res://menu/icons/temp/grey_grad.png"), "Grey Queen"],
[preload("res://tiles/redGrid.tscn"), preload("res://menu/icons/temp/red_oval.png"), "Red Queen"],
[preload("res://tiles/blueGrid.tscn"), preload("res://menu/icons/temp/blue_grad.png"), "Blue Jayden"],
[preload("res://tiles/greenGrid.tscn"), preload("res://menu/icons/temp/green_grad.png"), "Green Jayden"], 
[preload("res://tiles/greyGrid.tscn"), preload("res://menu/icons/temp/grey_grad.png"), "Grey Jayden"],
[preload("res://tiles/redGrid.tscn"), preload("res://menu/icons/temp/red_oval.png"), "Red Jayden"],
[preload("res://tiles/blueGrid.tscn"), preload("res://menu/icons/temp/blue_grad.png"), "Blue Lemonade"],
[preload("res://tiles/greenGrid.tscn"), preload("res://menu/icons/temp/green_grad.png"), "Green Lemonade"], 
[preload("res://tiles/greyGrid.tscn"), preload("res://menu/icons/temp/grey_grad.png"), "Grey Lemonade"],
[preload("res://tiles/redGrid.tscn"), preload("res://menu/icons/temp/red_oval.png"), "Red Lemonade"],
[preload("res://tiles/blueGrid.tscn"), preload("res://menu/icons/temp/blue_grad.png"), "Blue Ice"],
[preload("res://tiles/greenGrid.tscn"), preload("res://menu/icons/temp/green_grad.png"), "Green Ice"], 
[preload("res://tiles/greyGrid.tscn"), preload("res://menu/icons/temp/grey_grad.png"), "Grey Ice"],
[preload("res://tiles/redGrid.tscn"), preload("res://menu/icons/temp/red_oval.png"), "Red Ice"],
[preload("res://tiles/blueGrid.tscn"), preload("res://menu/icons/temp/blue_grad.png"), "Blue Candy"]]

var hotbar = [0, 1, 2, 3]
