extends Control


var selectedTile = false

var tilePortions = [[]]
var savedPortions = [[]]
var page = 0

var portionLocations = []
var searched = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var num = 0
	savedPortions = GV.tiles
	
	for tile in GV.tiles:
		if len(tilePortions[num]) < 20:
			tilePortions[num].append(tile)
		else:
			num += 1
			tilePortions.append([tile])
	
	display(tilePortions[page])
	
	
func display(tiles):
	if page == 0 and len(tilePortions) > 1:
		$buttonInteractions.play("greyTopButton")
	elif page == 0 and len(tilePortions) <= 1:
		$buttonInteractions.play("greyBoth")
	elif page == len(tilePortions) - 1:
		$buttonInteractions.play_backwards("greyTopButton")
	else:
		$buttonInteractions.play_backwards("greyBoth")
		
	
	if len(tiles) > 0:
		$tile1/icon.texture = tiles[0][1]
		$tile1/name.text = tiles[0][2]
		$tile1.visible = true
	else:
		$tile1.visible = false
	
	if len(tiles) > 1:
		$tile2/icon.texture = tiles[1][1]
		$tile2/name.text = tiles[1][2]
		$tile2.visible = true
	else:
		$tile2.visible = false
	
	if len(tiles) > 2:
		$tile3/icon.texture = tiles[2][1]
		$tile3/name.text = tiles[2][2]
		$tile3.visible = true
	else:
		$tile3.visible = false
	
	if len(tiles) > 3:
		$tile4/icon.texture = tiles[3][1]
		$tile4/name.text = tiles[3][2]
		$tile4.visible = true
	else:
		$tile4.visible = false
	
	if len(tiles) > 4:
		$tile5/icon.texture = tiles[4][1]
		$tile5/name.text = tiles[4][2]
		$tile5.visible = true
	else:
		$tile5.visible = false
	
	if len(tiles) > 5:
		$tile6/icon.texture = tiles[5][1]
		$tile6/name.text = tiles[5][2]
		$tile6.visible = true
	else:
		$tile6.visible = false
	
	if len(tiles) > 6:
		$tile7/icon.texture = tiles[6][1]
		$tile7/name.text = tiles[6][2]
		$tile7.visible = true
	else:
		$tile7.visible = false
	
	if len(tiles) > 7:
		$tile8/icon.texture = tiles[7][1]
		$tile8/name.text = tiles[7][2]
		$tile8.visible = true
	else:
		$tile8.visible = false
	
	if len(tiles) > 8:
		$tile9/icon.texture = tiles[8][1]
		$tile9/name.text = tiles[8][2]
		$tile9.visible = true
	else:
		$tile9.visible = false
	
	if len(tiles) > 9:
		$tile10/icon.texture = tiles[9][1]
		$tile10/name.text = tiles[9][2]
		$tile10.visible = true
	else:
		$tile10.visible = false
	
	if len(tiles) > 10:
		$tile11/icon.texture = tiles[10][1]
		$tile11/name.text = tiles[10][2]
		$tile11.visible = true
	else:
		$tile11.visible = false
	
	if len(tiles) > 11:
		$tile12/icon.texture = tiles[11][1]
		$tile12/name.text = tiles[11][2]
		$tile12.visible = true
	else:
		$tile12.visible = false
	
	if len(tiles) > 12:
		$tile13/icon.texture = tiles[12][1]
		$tile13/name.text = tiles[12][2]
		$tile13.visible = true
	else:
		$tile13.visible = false
	
	if len(tiles) > 13:
		$tile14/icon.texture = tiles[13][1]
		$tile14/name.text = tiles[13][2]
		$tile14.visible = true
	else:
		$tile14.visible = false
	
	if len(tiles) > 14:
		$tile15/icon.texture = tiles[14][1]
		$tile15/name.text = tiles[14][2]
		$tile15.visible = true
	else:
		$tile15.visible = false
	
	if len(tiles) > 15:
		$tile16/icon.texture = tiles[15][1]
		$tile16/name.text = tiles[15][2]
		$tile16.visible = true
	else:
		$tile16.visible = false
	
	if len(tiles) > 16:
		$tile17/icon.texture = tiles[16][1]
		$tile17/name.text = tiles[16][2]
		$tile17.visible = true
	else:
		$tile17.visible = false
	
	if len(tiles) > 17:
		$tile18/icon.texture = tiles[17][1]
		$tile18/name.text = tiles[17][2]
		$tile18.visible = true
	else:
		$tile18.visible = false
	
	if len(tiles) > 18:
		$tile19/icon.texture = tiles[18][1]
		$tile19/name.text = tiles[18][2]
		$tile19.visible = true
	else:
		$tile19.visible = false
	
	if len(tiles) > 19:
		$tile20/icon.texture = tiles[19][1]
		$tile20/name.text = tiles[19][2]
		$tile20.visible = true
	else:
		$tile20.visible = false

func down(tile):
	selectedTile = tile + 20 * page

func selectedSlot(slot):
	if !(selectedTile in [false]):
		if len(GV.hotbar) > slot:
			if searched:
				GV.hotbar[slot] = portionLocations[selectedTile]
			else:
				GV.hotbar[slot] = selectedTile
		else:
			if searched:
				GV.hotbar.append(portionLocations[selectedTile])
			else:
				GV.hotbar.append(selectedTile)

func _on_upButton_button_down():
	page -= 1
	display(tilePortions[page])


func _on_downButton_button_down():
	page += 1
	display(tilePortions[page])

func _on_searchInput_text_changed(new_text):
	var tempPortions = []
	portionLocations = []
	if len(new_text) != 0:
		searched = true
		for tile in range(len(savedPortions)):
			if new_text.to_lower() in savedPortions[tile][2].to_lower():
				tempPortions.append(savedPortions[tile])
				portionLocations.append(tile)
	else:
		searched = false
		tempPortions = savedPortions
	
	page = 0
	var num = 0
	tilePortions = [[]]
	
	for tile in tempPortions:
		if len(tilePortions[num]) < 20:
			tilePortions[num].append(tile)
		else:
			num += 1
			tilePortions.append([tile])
	
	display(tilePortions[page])

func tile1Down(): down(0);

func tile2Down(): down(1);

func tile3Down(): down(2);

func tile4Down(): down(3);

func tile5Down(): down(4);

func tile6Down(): down(5);

func tile7Down(): down(6);

func tile8Down(): down(7);

func tile9Down(): down(8);

func tile10Down(): down(9);

func tile11Down(): down(10);

func tile12Down(): down(11);

func tile13Down(): down(12);

func tile14Down(): down(13);

func tile15Down(): down(14);

func tile16Down(): down(15);

func tile17Down(): down(16);

func tile18Down(): down(17);

func tile19Down(): down(18);

func tile20Down(): down(19);

func _on_slot1_button_down(): selectedSlot(0);

func _on_slot2_button_down(): selectedSlot(1);

func _on_slot3_button_down(): selectedSlot(2);

func _on_slot4_button_down(): selectedSlot(3);

func _on_slot5_button_down(): selectedSlot(4);

func _on_slot6_button_down(): selectedSlot(5);

func _on_slot7_button_down(): selectedSlot(6);

func _on_slot8_button_down(): selectedSlot(7);

func _on_slot9_button_down(): selectedSlot(8);

func _on_slot0_button_down(): selectedSlot(9);

