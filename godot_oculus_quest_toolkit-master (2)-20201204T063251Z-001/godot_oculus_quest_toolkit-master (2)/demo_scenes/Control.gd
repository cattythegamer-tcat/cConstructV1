extends Control

const SQLite = preload("res://lib/gdsqlite.gdns");
# Create gdsqlite instance
var db = SQLite.new();
# Variables
var item_list = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	db.open("res://items.db");
	
	var pots = db.fetch_array("SELECT * FROM potion ORDER BY id ASC");
	for pot in pots:
		# Create new item from database
		var item = {
			'id': pot['id'],
			'name': pot['name'],
			'price': pot['price'],
			'heals': pot['heals']
		};
		
		# Add to item list
		item_list.append(item);
	$Label.text = str(item_list[0])
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
