extends Spatial

var goTo = Vector3()
var boxDistance = 2
var shift = false
var cntr = false
var selectedTile = 0

var renderDis = 24
var camLoc = Vector2()
var preLoc = Vector2(1000000, 1000000)

var terrain_entities = []
var original_entities = []
var original_ids = []

onready var currentBlock = $currentBlock
onready var tile = $currentBlock/tile

# SQLite module
const SQLite = preload("res://lib/gdsqlite.gdns");
# Create gdsqlite instance
var db = SQLite.new();

var saved_hotbar = []

var hidden = false

var savedDB = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$GUI/tileSelection/xCoordInput.placeholder_text = str(int($Camera.translation.x))
	$GUI/tileSelection/yCoordInput.placeholder_text = str(int($Camera.translation.y))
	$GUI/tileSelection/zCoordInput.placeholder_text = str(int($Camera.translation.z))
	camLoc = Vector2($Camera.translation.x, $Camera.translation.z)
	# Open item database
	db.open("user://terrain.db");
	
	var query = 'CREATE TABLE IF NOT EXISTS "terrainData" ("ID" INTEGER UNIQUE, "posX" INTEGER, "posY" INTEGER, "posZ" INTEGER, "rotation" TEXT, "invert" INTEGER, "tileID" INTEGER, PRIMARY KEY("ID" AUTOINCREMENT));'
	db.query(query)
	
	var items = get_items(camLoc)
	
	for item in items:
		original_ids.append(item["ID"])
		var Bposition = Vector3(item["posX"], item["posY"], item["posZ"])
		var Bscale = Vector3(1, 1, 1)
		
		if item["invert"] == 1:
			Bscale = Vector3(-1, -1, -1)
		
		var currentNum = str("")
		var rotValues = []
		
		for l in str(item["rotation"]):
			if l == ",":
				rotValues.append(float(currentNum))
				currentNum = str("")
			else:
				currentNum += l
		
		var Brot = Vector3(rotValues[0], rotValues[1], rotValues[2])
		
		var tile2create = GV.tiles[item["tileID"]][0].instance()
		
		self.add_child(tile2create)
		tile2create.translate(Bposition)
		tile2create.rotation_degrees = Brot
		tile2create.scale = Bscale
		terrain_entities.append(tile2create)
		original_entities.append(tile2create)
	
	$GUI/tileSelection/renderInput.placeholder_text = str(renderDis)
	$GUI/tileSelection/spaceInput.placeholder_text = str(boxDistance)
	reload_tile()

func get_items(loc = Vector2()):
	var disLoc = Vector2(round((camLoc.x - preLoc.x)*10)/10, round((camLoc.y - preLoc.y)*10)/10)
	var maX = 0
	var miX = 0
	var maY = 0
	var miY = 0
	
	if sqrt(pow(disLoc.x, 2)) > renderDis or true:
		maX = camLoc.x + renderDis
		miX = camLoc.x - renderDis
	elif disLoc.x > 0:
		maX = camLoc.x + renderDis
		miX = preLoc.x + renderDis
	elif disLoc.x < 0:
		maX = preLoc.x - renderDis
		miX = camLoc.x - renderDis
	else:
		maX = PI
		miX = PI
	
	if sqrt(pow(disLoc.y, 2)) > renderDis or true:
		maY = camLoc.y + renderDis
		miY = camLoc.y - renderDis
	elif disLoc.y > 0:
		maY = camLoc.y + renderDis
		miY = preLoc.y + renderDis
	elif disLoc.y < 0:
		maX = preLoc.y - renderDis
		miX = camLoc.y - renderDis
	else:
		maY = PI
		miY = PI
	
	preLoc = camLoc
	return db.fetch_array_with_args("SELECT * FROM terrainData WHERE terrainData.posX >= ? and terrainData.posX <= ? and terrainData.posZ >= ? and terrainData.posZ <= ?;", [miX, maX, miY, maY]);

func update_hotbar():
	if len(GV.hotbar) > 0:
		$GUI/hotbar/slot1/icon.texture = GV.tiles[GV.hotbar[0]][1]
		$GUI/tileSelection/hotbar/slot1.icon = GV.tiles[GV.hotbar[0]][1]
		if len(GV.hotbar) > 1:
			$GUI/hotbar/slot2/icon.texture = GV.tiles[GV.hotbar[1]][1]
			$GUI/tileSelection/hotbar/slot2.icon = GV.tiles[GV.hotbar[1]][1]
			if len(GV.hotbar) > 2:
				$GUI/hotbar/slot3/icon.texture = GV.tiles[GV.hotbar[2]][1]
				$GUI/tileSelection/hotbar/slot3.icon = GV.tiles[GV.hotbar[2]][1]
				if len(GV.hotbar) > 3:
					$GUI/hotbar/slot4/icon.texture = GV.tiles[GV.hotbar[3]][1]
					$GUI/tileSelection/hotbar/slot4.icon = GV.tiles[GV.hotbar[3]][1]
					if len(GV.hotbar) > 4:
						$GUI/hotbar/slot5/icon.texture = GV.tiles[GV.hotbar[4]][1]
						$GUI/tileSelection/hotbar/slot5.icon = GV.tiles[GV.hotbar[4]][1]
						if len(GV.hotbar) > 5:
							$GUI/hotbar/slot6/icon.texture = GV.tiles[GV.hotbar[5]][1]
							$GUI/tileSelection/hotbar/slot6.icon = GV.tiles[GV.hotbar[5]][1]
							if len(GV.hotbar) > 6:
								$GUI/hotbar/slot7/icon.texture = GV.tiles[GV.hotbar[6]][1]
								$GUI/tileSelection/hotbar/slot7.icon = GV.tiles[GV.hotbar[6]][1]
								if len(GV.hotbar) > 7:
									$GUI/hotbar/slot8/icon.texture = GV.tiles[GV.hotbar[7]][1]
									$GUI/tileSelection/hotbar/slot8.icon = GV.tiles[GV.hotbar[7]][1]
									if len(GV.hotbar) > 8:
										$GUI/hotbar/slot9/icon.texture = GV.tiles[GV.hotbar[8]][1]
										$GUI/tileSelection/hotbar/slot9.icon = GV.tiles[GV.hotbar[8]][1]
										if len(GV.hotbar) > 9:
											$GUI/hotbar/slot0/icon.texture = GV.tiles[GV.hotbar[9]][1]
											$GUI/tileSelection/hotbar/slot0.icon = GV.tiles[GV.hotbar[9]][1]

func update_items(items):
	var tempID = []
	for item in items:
		if !(item["ID"] in original_ids):
			var Bposition = Vector3(item["posX"], item["posY"], item["posZ"])
			var Bscale = Vector3(1, 1, 1)
			
			if item["invert"] == 1:
				Bscale = Vector3(-1, -1, -1)
			
			var currentNum = str("")
			var rotValues = []
			
			for l in str(item["rotation"]):
				if l == ",":
					rotValues.append(float(currentNum))
					currentNum = str("")
				else:
					currentNum += l
			
			var Brot = Vector3(rotValues[0], rotValues[1], rotValues[2])
			var tile2create = GV.tiles[item["tileID"]][0].instance()
			
			self.add_child(tile2create)
			tile2create.translate(Bposition)
			tile2create.rotation_degrees = Brot
			tile2create.scale = Bscale
			terrain_entities.append(tile2create)
			original_entities.append(tile2create)
		tempID.append(item["ID"])
	
	var camPRenderX = camLoc.x + renderDis
	var camMRenderX = camLoc.x - renderDis
	var camPRenderY = camLoc.y + renderDis
	var camMRenderY = camLoc.y - renderDis
	
	for entity in terrain_entities:
		if str(entity) != "[Deleted Object]":
			if (entity.translation.x > camPRenderX or entity.translation.x < camMRenderX) or (entity.translation.z > camPRenderY or entity.translation.z < camMRenderY):
				terrain_entities.erase(entity)
		else:
			terrain_entities.erase(entity)
			
	for entity in original_entities:
		if str(entity) != "[Deleted Object]":
			if (entity.translation.x > camPRenderX or entity.translation.x < camMRenderX) or (entity.translation.z > camPRenderY or entity.translation.z < camMRenderY):
				entity.queue_free()
				original_entities.erase(entity)
		else:
			original_entities.erase(entity)
	
	original_ids = tempID
 
func _process(delta):
	if pow(camLoc.x - $Camera.translation.x, 2) > 2 or pow(camLoc.y - $Camera.translation.z, 2) > 2:
		camLoc = Vector2($Camera.translation.x, $Camera.translation.z)
		update_items(get_items(camLoc))
		$GUI/tileSelection/xCoordInput.placeholder_text = str(int($Camera.translation.x))
		$GUI/tileSelection/yCoordInput.placeholder_text = str(int($Camera.translation.y))
		$GUI/tileSelection/zCoordInput.placeholder_text = str(int($Camera.translation.z))
		#$y_collider.global_translate(Vector3(camLoc.x - $y_collider.translation.x, 0, camLoc.y - $y_collider.translation.z))
	
	if GV.hotbar != saved_hotbar:
		update_hotbar()
	if Input.is_action_just_pressed("menu"):
		if GV.paused:
			GV.paused = false
		else:
			GV.paused = true
			$GUI/tileSelection/renderInput.text = ""
			$GUI/tileSelection/spaceInput.text = ""
			$GUI/tileSelection/xCoordInput.text = ""
			$GUI/tileSelection/yCoordInput.text = ""
			$GUI/tileSelection/zCoordInput.text = ""
	if Input.is_action_just_pressed("hide"):
		if hidden: 
			hidden = false
			tile.visible = true
		else:
			hidden = true
			tile.visible = false
	if GV.paused:
		if !$GUI/tileSelection.visible:
			$GUI/tileSelection.visible = true
	else:
		if $GUI/tileSelection.visible:
			$GUI/tileSelection.visible = false
		if Input.is_action_just_pressed("slot1") and len(GV.hotbar) > 0:
			selectedTile = 0
			reload_tile()
		elif Input.is_action_just_pressed("slot2") and len(GV.hotbar) > 1:
			selectedTile = 1
			reload_tile()
		elif Input.is_action_just_pressed("slot3") and len(GV.hotbar) > 2:
			selectedTile = 2
			reload_tile()
		elif Input.is_action_just_pressed("slot4") and len(GV.hotbar) > 3:
			selectedTile = 3
			reload_tile()
		elif Input.is_action_just_pressed("slot5") and len(GV.hotbar) > 4:
			selectedTile = 4
			reload_tile()
		elif Input.is_action_just_pressed("slot6") and len(GV.hotbar) > 5:
			selectedTile = 5
			reload_tile()
		elif Input.is_action_just_pressed("slot7") and len(GV.hotbar) > 6:
			selectedTile = 6
			reload_tile()
		elif Input.is_action_just_pressed("slot8") and len(GV.hotbar) > 7:
			selectedTile = 7
			reload_tile()
		elif Input.is_action_just_pressed("slot9") and len(GV.hotbar) > 8:
			selectedTile = 8
			reload_tile()
		elif Input.is_action_just_pressed("slot0") and len(GV.hotbar) > 9:
			selectedTile = 9
			reload_tile()
		
		shift = Input.is_action_pressed("shift")
		cntr = Input.is_action_pressed("tab")
	
		if Input.is_action_just_released("scroll_up") and shift:
			$y_collider.translate(Vector3(0, boxDistance, 0))
		if Input.is_action_just_released("scroll_down") and shift:
			$y_collider.translate(Vector3(0, -boxDistance, 0))
		
		if Input.is_action_just_pressed("rotate_x") and !hidden:
			if shift:
				tile.rotate_x(deg2rad(-90))
			else:
				tile.rotate_x(deg2rad(90))
			
		if Input.is_action_just_pressed("rotate_y") and !hidden:
			if shift:
				tile.rotate_y(deg2rad(-90))
			else:
				tile.rotate_y(deg2rad(90))
			
		if Input.is_action_just_pressed("rotate_z") and !hidden:
			if shift:
				tile.rotate_z(deg2rad(-90))
			else:
				tile.rotate_z(deg2rad(90))
	
		if Input.is_action_just_pressed("invert") and !hidden:
			if tile.scale.z == -1:
				tile.scale = Vector3(1, 1, 1)
			else:
				tile.scale = Vector3(-1, -1, -1)
			
		goTo = $Camera.goTo
		goTo.x = round(goTo.x / boxDistance) * boxDistance
		goTo.y = round(goTo.y / boxDistance) * boxDistance
		goTo.z = round(goTo.z / boxDistance) * boxDistance
	
		if goTo != currentBlock.translation:
			currentBlock.translate(goTo - currentBlock.translation)
	
		if Input.is_action_just_pressed("place") and !hidden:
			if cntr:
				break_tile()
			else:
				place_tile()
		
	if Input.is_action_pressed("exit"):
		db.close()
		get_tree().quit()

func reload_tile():
	var Bposition = currentBlock.translation
	var Brot = tile.rotation_degrees
	var Bscale = tile.scale
	
	tile.queue_free()
	tile = GV.tiles[GV.hotbar[selectedTile]][0].instance()
	
	tile = GV.tiles[GV.hotbar[selectedTile]][0].instance()
	currentBlock.add_child(tile)
	tile.rotation_degrees = Brot
	tile.scale = Bscale
	
	match selectedTile:
		0:
			$GUI/hotbar/slotSelections.play("slot1")
		1:
			$GUI/hotbar/slotSelections.play("slot2")
		2:
			$GUI/hotbar/slotSelections.play("slot3")
		3:
			$GUI/hotbar/slotSelections.play("slot4")
		4:
			$GUI/hotbar/slotSelections.play("slot5")
		5:
			$GUI/hotbar/slotSelections.play("slot6")
		6:
			$GUI/hotbar/slotSelections.play("slot7")
		7:
			$GUI/hotbar/slotSelections.play("slot8")
		8:
			$GUI/hotbar/slotSelections.play("slot9")
		9:
			$GUI/hotbar/slotSelections.play("slot0")
	
	$GUI/hotbar/name.text = GV.tiles[GV.hotbar[selectedTile]][2]

func place_tile():
	var Bposition = currentBlock.translation
	var Brot = tile.rotation_degrees
	var Bscale = tile.scale
	
	tile.queue_free()
	tile = GV.tiles[GV.hotbar[selectedTile]][0].instance()
	
	self.add_child(tile)
	tile.translate(Bposition)
	tile.rotation_degrees = Brot
	tile.scale = Bscale
	terrain_entities.append(tile)
	tile = GV.tiles[GV.hotbar[selectedTile]][0].instance()
	currentBlock.add_child(tile)
	tile.rotation_degrees = Brot
	tile.scale = Bscale
	save()

func break_tile():
	var Bpos = currentBlock.translation
	for tl in terrain_entities:
		if tl.translation.x == Bpos.x and tl.translation.z == Bpos.z:
			tl.queue_free()
			terrain_entities.erase(tl)
	db.query_with_args("DELETE FROM terrainData WHERE terrainData.posX = ? and terrainData.posZ = ?;", [Bpos.x, Bpos.z])

func save():
	var add = []
	var amt = len(terrain_entities)

	for x in original_entities:
		if x in terrain_entities:
			amt -= 1 
	
	for item in terrain_entities:
		if !(item in original_entities):
			add.append(item)
	
	for item in add:
		var x = item.translation.x
		var y = item.translation.y
		var z = item.translation.z
		
		var Rx = item.rotation_degrees.x
		var Ry = item.rotation_degrees.y
		var Rz = item.rotation_degrees.z
		
		var rot = str(Rx) + "," + str(Ry) + "," + str(Rz) + ","
		
		var invert = 0
		if item.scale.x == -1:
			invert = 1
		
		var tileID = item.tile
		
		db.query_with_args("INSERT INTO terrainData (posX, posY, posZ, rotation, invert, tileID) VALUES (?,?,?,?,?,?);", [x, y, z, rot, invert, tileID])
	
	original_entities = []
	for item in terrain_entities: original_entities.append(item);
	
	var items = get_items(Vector2($Camera.translation.x, $Camera.translation.z));
	
	original_ids = []
	for item in items: original_ids.append(item["ID"]);

func _on_spaceInput_text_entered(new_text):
	var dec = false
	var error = false
	for x in new_text:
		if !(x in "0123456789"):
			if x == "." and !dec:
				dec = true
			else:
				error = true
	if !error:
		boxDistance = float(new_text)
	$GUI/tileSelection/spaceInput.text = ""
	$GUI/tileSelection/spaceInput.placeholder_text = str(boxDistance)

func _on_renderInput_text_entered(new_text):
	var dec = false
	var error = false
	for x in new_text:
		if !(x in "0123456789"):
			if x == "." and !dec:
				dec = true
			else:
				error = true
	if !error:
		renderDis = int(new_text)
	
	$GUI/tileSelection/renderInput.text = ""
	$GUI/tileSelection/renderInput.placeholder_text = str(renderDis)

func _on_zCoordInput_text_entered(new_text):
	var dec = false
	var error = false
	for x in new_text:
		if !(x in "-0123456789"):
			if x == "." and !dec:
				dec = true
			else:
				error = true
	if !error:
		$Camera.global_translate(Vector3(0, 0, int(new_text) - $Camera.translation.z))
	
	$GUI/tileSelection/zCoordInput.text = ""
	$GUI/tileSelection/zCoordInput.placeholder_text = str($Camera.translation.z)

func _on_yCoordInput_text_entered(new_text):
	var dec = false
	var error = false
	for x in new_text:
		if !(x in "-0123456789"):
			if x == "." and !dec:
				dec = true
			else:
				error = true
	if !error:
		$Camera.global_translate(Vector3(0, int(new_text) - $Camera.translation.y, 0))
	
	$GUI/tileSelection/yCoordInput.text = ""
	$GUI/tileSelection/yCoordInput.placeholder_text = str($Camera.translation.y)

func _on_xCoordInput_text_entered(new_text):
	var dec = false
	var error = false
	for x in new_text:
		if !(x in "-0123456789"):
			if x == "." and !dec:
				dec = true
			else:
				error = true
	if !error:
		$Camera.global_translate(Vector3(int(new_text) - $Camera.translation.x, 0, 0))
	
	$GUI/tileSelection/xCoordInput.text = ""
	$GUI/tileSelection/xCoordInput.placeholder_text = str($Camera.translation.x)
