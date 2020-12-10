extends Spatial

var info_text = """Physics Demo Room

Right Controller uses GrabType == HingeJoint
Left Controller uses GrabType == Velocity + Reparent Mesh
"""

var renderDis = 24
var camLoc = Vector2()
var curCamLoc = Vector3()
var preLoc = Vector2(1000000, 1000000)

var terrain_entities = []
var original_entities = []
var original_ids = []

var savedDB = []

const SQLite = preload("res://lib/gdsqlite.gdns");
# Create gdsqlite instance
var db = SQLite.new();
# Variables
var item_list = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	db.open("res://terrain.db");
	
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
	
func _physics_process(_dt):
	if (vr.button_just_pressed(vr.BUTTON.ENTER)): # switch back to main menu
		vr.switch_scene("res://demo_scenes/UIDemoScene.tscn");
	
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
	#return db.fetch_array("SELECT * FROM terrainData WHERE terrainData.posX >= -100 and terrainData.posX <= 100 and terrainData.posZ >= -100 and terrainData.posZ <= 100;");
	return db.fetch_array_with_args("SELECT * FROM terrainData WHERE terrainData.posX >= ? and terrainData.posX <= ? and terrainData.posZ >= ? and terrainData.posZ <= ?;", [miX, maX, miY, maY]);

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
	if pow(camLoc.x - curCamLoc.x, 2) > 2 or pow(camLoc.y - curCamLoc.z, 2) > 2:
		camLoc = Vector2(curCamLoc.x, curCamLoc.z)
		update_items(get_items(camLoc))

