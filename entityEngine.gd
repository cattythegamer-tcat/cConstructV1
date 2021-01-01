extends Spatial

#World Loading Variables
var renderDis = 100
var renderUpdate = 2

var terrainTiles = []
var originalTiles = []
var originalIDs = []

#Camera Variables
var camLoc = Vector2()
var curCamLoc = Vector3()

var goTo = Vector3()
var boxDistance = 0.1
var shift = false
var cntr = false
var selectedEntity = 0

onready var entity = $currentEntity/entity

var savedItemHotbar = []
var hidden = false

# SQLite module
const SQLite = preload("res://lib/gdsqlite.gdns");
# Create gdsqlite instance
var db = SQLite.new();

# Called when the node enters the scene tree for the first time.
func _ready():
	#GUI Setup
	$GUI/tileSelection/xCoordInput.placeholder_text = str(int($Camera.translation.x))
	$GUI/tileSelection/yCoordInput.placeholder_text = str(int($Camera.translation.y))
	$GUI/tileSelection/zCoordInput.placeholder_text = str(int($Camera.translation.z))
	
	$GUI/tileSelection/renderInput.placeholder_text = str(renderDis)
	$GUI/tileSelection/spaceInput.placeholder_text = str(boxDistance)
	
	camLoc = Vector2($Camera.translation.x, $Camera.translation.z)
	
	# Open item database
	db.open("user://worldData.db");
	var query = 'CREATE TABLE IF NOT EXISTS "entityData" ("ID" INTEGER UNIQUE, "posX" INTEGER, "posY" INTEGER, "posZ" INTEGER, "rotation" TEXT, "invert" INTEGER, "item" TEXT, PRIMARY KEY("ID" AUTOINCREMENT));'
	db.query(query)
	
	var items = getItems(camLoc)
	
	for item in items:
		originalIDs.append(item["ID"])
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
		terrainTiles.append(tile2create)
		originalTiles.append(tile2create)


func getItems(loc = Vector2()):
	var maX = loc.x + renderDis
	var miX = loc.x - renderDis
	var maY = loc.y + renderDis
	var miY = loc.y - renderDis
	
	return db.fetch_array_with_args("SELECT * FROM terrainData WHERE terrainData.posX >= ? and terrainData.posX <= ? and terrainData.posZ >= ? and terrainData.posZ <= ?;", [miX, maX, miY, maY]);


func updateItems(items):
	var tempID = []
	for item in items:
		if !(item["ID"] in originalIDs):
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
			terrainTiles.append(tile2create)
			originalTiles.append(tile2create)
		tempID.append(item["ID"])
	
	for entity in terrainTiles:
		var eT = entity.translation #To shrink if/else statement
		if eT.x > camLoc.x + renderDis or eT.x < camLoc.x - renderDis or eT.z > camLoc.y + renderDis or eT.z < camLoc.y - renderDis:
			terrainTiles.erase(entity)
			
	for entity in originalTiles:
		var eT = entity.translation
		if eT.x > camLoc.x + renderDis or eT.x < camLoc.x - renderDis or eT.z > camLoc.y + renderDis or eT.z < camLoc.y - renderDis:
			entity.queue_free()
			originalTiles.erase(entity)
	
	originalIDs = tempID


func updateHotbar():
	for slot in range(len(GV.itemHotbar)):
		$GUI/hotbar.get_child(slot).get_child(0).texture = GV.items[GV.itemHotbar[slot]][1]
		$GUI/tileSelection/hotbar.get_child(slot).icon = GV.items[GV.itemHotbar[slot]][1]


func reloadTile():
	var Bposition = $currentEntity.translation
	var Brot = entity.rotation_degrees
	var Bscale = entity.scale
	
	entity.queue_free()
	entity = GV.items[GV.itemHotbar[selectedEntity]][0].instance()
	
	entity = GV.items[GV.itemHotbar[selectedEntity]][0].instance()
	$currentEntity.add_child(entity)
	entity.rotation_degrees = Brot
	entity.scale = Bscale
	
	var animNames = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
	$GUI/hotbar/slotSelections.play("slot" + str(animNames[selectedEntity]))
	
	$GUI/hotbar/name.text = GV.itemHotbar[selectedEntity]


func placeTile():
	var Bposition = $currentEntity.translation
	var Brot = entity.rotation_degrees
	var Bscale = entity.scale
	
	entity.queue_free()
	entity = GV.items[GV.itemHotbar[selectedEntity]][0].instance()
	
	self.add_child(entity)
	entity.translate(Bposition)
	entity.rotation_degrees = Brot
	entity.scale = Bscale
	entity.sleeping = false
	entity.set_collision_layer_bit(0, true)
	entity.set_collision_layer_bit(1, true)
	entity.set_collision_mask_bit(1, true)
	entity = GV.items[GV.itemHotbar[selectedEntity]][0].instance()
	$currentEntity.add_child(entity)
	entity.rotation_degrees = Brot
	entity.scale = Bscale


func _process(delta):
	#FPS CHECK
	if delta >= 0.0111112 or true:
		$GUI/FPS.text = str(Engine.get_frames_per_second())
	
	curCamLoc = $Camera.translation
	
	if pow(camLoc.x - curCamLoc.x, 2) > renderUpdate or pow(camLoc.y - curCamLoc.z, 2) > renderUpdate: #World Update Script
		camLoc = Vector2(curCamLoc.x, curCamLoc.z)
		updateItems(getItems(camLoc))
		$GUI/tileSelection/xCoordInput.placeholder_text = str(int($Camera.translation.x))
		$GUI/tileSelection/yCoordInput.placeholder_text = str(int($Camera.translation.y))
		$GUI/tileSelection/zCoordInput.placeholder_text = str(int($Camera.translation.z))
	
	if GV.itemHotbar != savedItemHotbar:
		updateHotbar()
	
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
	
	if Input.is_action_just_pressed("hide"): #ADD ITEM WHEN ITEM ADD SYSTEM IMPLEMENTED
		if hidden: 
			hidden = false
			entity.visible = true
		else:
			hidden = true
			entity.visible = false
	
	if GV.paused:
		if !$GUI/tileSelection.visible:
			$GUI/tileSelection.visible = true
	else:
		if $GUI/tileSelection.visible:
			$GUI/tileSelection.visible = false
		
		for slot in range(len(GV.itemHotbar)):
			if slot == 9 and Input.is_action_just_pressed("slot0") or Input.is_action_just_pressed("slot" + str(slot + 1)):
				selectedEntity = slot
				reloadTile()
				break

		shift = Input.is_action_pressed("shift")
		cntr = Input.is_action_pressed("tab")
	
		if Input.is_action_just_released("scroll_up") and shift:
			$y_collider.translate(Vector3(0, boxDistance, 0))
		if Input.is_action_just_released("scroll_down") and shift:
			$y_collider.translate(Vector3(0, -boxDistance, 0))
		
		if !hidden:
			if Input.is_action_just_pressed("reset"):
				entity.rotation_degrees = Vector3(0, 0, 0)
				entity.scale = Vector3(1, 1, 1)
			if Input.is_action_pressed("rotate_x"):
				if shift:
					entity.rotate_x(deg2rad(-boxDistance))
				else:
					entity.rotate_x(deg2rad(boxDistance))
				
			if Input.is_action_pressed("rotate_y"):
				if shift:
					entity.rotate_y(deg2rad(-boxDistance))
				else:
					entity.rotate_y(deg2rad(boxDistance))
				
			if Input.is_action_pressed("rotate_z"):
				if shift:
					entity.rotate_z(deg2rad(-boxDistance))
				else:
					entity.rotate_z(deg2rad(boxDistance))
		
			if Input.is_action_just_pressed("invert"):
				if entity.scale.z == -1:
					entity.scale = Vector3(1, 1, 1)
				else:
					entity.scale = Vector3(-1, -1, -1)
				
			goTo = $Camera.goTo
			goTo.x = round(goTo.x / boxDistance) * boxDistance
			goTo.y = round(goTo.y / boxDistance) * boxDistance
			goTo.z = round(goTo.z / boxDistance) * boxDistance
		
			if goTo != $currentEntity.translation:
				$currentEntity.translate(goTo - $currentEntity.translation)
	
			if Input.is_action_just_pressed("place"): #IMPLEMENT ONCE BREAK/PLACE FUNCTIONS ADDED
				if cntr:
					pass
					#break_tile()
				else:
					placeTile()
	
	if Input.is_action_pressed("exit"):
		db.close()
		get_tree().quit()
	

#Different scripts for when commands are entered in the menu
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
