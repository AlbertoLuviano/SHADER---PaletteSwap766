extends Node

export var swapColors : PoolColorArray
onready var shaderMat = get_node("/root/World/MsPacMan766").get_material()

#used only for tutorial purposes
onready var testTexture = get_node("/root/World/ArrayTextureSample")
onready var colorPick = get_node("/root/World/UI/Red/ColorPick")
onready var colorPickIndex = get_node("/root/World/UI/Red/LineEdit")
onready var colorSelection = get_node("/root/World/UI/CurrentColor")
onready var selectionColors = [get_node("/root/World/UI/MsPacManRefColors/HSort/Color01"),\
								get_node("/root/World/UI/MsPacManRefColors/HSort/Color02"),\
								get_node("/root/World/UI/MsPacManRefColors/HSort/Color03"),\
								get_node("/root/World/UI/MsPacManRefColors/HSort/Color04"),\
								get_node("/root/World/UI/MegaManRefColors/HSort/Color01"),\
								get_node("/root/World/UI/MegaManRefColors/HSort/Color02"),\
								get_node("/root/World/UI/MegaManRefColors/HSort/Color03"),\
								get_node("/root/World/UI/MegaManRefColors/HSort/Color04"),\
								get_node("/root/World/UI/MegaManRefColors/HSort/Color05"),\
								get_node("/root/World/UI/MegaManRefColors/HSort/Color06"),\
								get_node("/root/World/UI/MegaManRefColors/HSort/Color07"),\
								get_node("/root/World/UI/SamusRefColors/HSort/Color01"),\
								get_node("/root/World/UI/SamusRefColors/HSort/Color02"),\
								get_node("/root/World/UI/SamusRefColors/HSort/Color03"),\
								get_node("/root/World/UI/SamusRefColors/HSort/Color04"),\
								get_node("/root/World/UI/SamusRefColors/HSort/Color05"),\
								get_node("/root/World/UI/SamusRefColors/HSort/Color06"),\
								get_node("/root/World/UI/SamusRefColors/HSort/Color07"),\
								get_node("/root/World/UI/SamusRefColors/HSort/Color08"),\
								get_node("/root/World/UI/SamusRefColors/HSort/Color09"),\
								get_node("/root/World/UI/SamusRefColors/HSort/Color10"),\
								get_node("/root/World/UI/SamusRefColors/HSort/Color11"),\
								get_node("/root/World/UI/SamusRefColors/HSort/Color12")]

var image : Image
var texture : ImageTexture

#used only for tutorial purposes
var currentColorIndex : int = 0
var currentSelection : int = 0
var checkColors = [0, 1, 2, 3, 257, 258, 259, 260, 261, 262, 263, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524]

func _ready():
	image = Image.new()
	texture = ImageTexture.new()
	image.create(256, 3, false, Image.FORMAT_RGB8)
	_updateSwapShader()

func _updateSwapShader(): # This is the code that makes it all work 
	image.lock()
	
	for pixelX in range(256):
		for pixelY in range(3):
			if swapColors[pixelX + pixelY * 256] == Color(0,0,0):
				continue
#			print(swapColors[pixelX + pixelY * 256])
			image.set_pixel(pixelX, pixelY, swapColors[pixelX + pixelY * 256])
	
	image.unlock()
	texture.create_from_image(image, 2)
	
#	Help needed - Optimization chance. Instead of creating a whole new texture everytime it will be better to partially update the texture.
#	VisualServer.texture_set_data_partial(texture.get_rid(), image, 2, 0, 1, 1, 0, 0, 0, 0) 
	
	testTexture.texture = texture # it's safe to disable or erase this line of code.
	
	shaderMat.set_shader_param("swapArray", texture)

# function used for the tutorial
func _swapColorChanged(value : float, valueChannel : int):
	match valueChannel:
		0:
			colorPick.color = Color(value, colorPick.color.g , colorPick.color.b)
		1:
			colorPick.color = Color(colorPick.color.r, value, colorPick.color.b)
		2:
			colorPick.color = Color(colorPick.color.r, colorPick.color.g, value)
	
	swapColors[currentColorIndex] = colorPick.color
	if checkColors.has(currentColorIndex):
		selectionColors[currentSelection].color = colorPick.color
	_updateSwapShader()

# function used for the tutorial
func _changePickColor(newCurrentColorIndex  : int, recPos : Vector2, recSize : Vector2, newCurrentSelectionColor : int): 
	currentColorIndex = newCurrentColorIndex
	colorSelection.rect_position = recPos
	colorSelection.rect_size = recSize
	currentSelection = newCurrentSelectionColor
	colorPickIndex.text = str(currentColorIndex)

# function used for the tutorial
func _changeCurrentColorIndex(new_text : String):
	colorPickIndex.text = str(clamp(int(new_text), 0, 767))
	currentColorIndex = int(clamp(int(new_text), 0, 767))
	if checkColors.has(currentColorIndex):
		match currentColorIndex:
			0, 1, 2, 3:
				currentSelection = currentColorIndex
			257, 258, 259, 260, 261, 262, 263:
				currentSelection = currentColorIndex - 253
			513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524:
				currentSelection = currentColorIndex - 502
