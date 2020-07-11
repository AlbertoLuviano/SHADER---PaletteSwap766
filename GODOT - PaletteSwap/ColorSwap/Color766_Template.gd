extends Node #change this to the node type the script is attached to.

export var swapColors : PoolColorArray
onready var shaderMat = get_node("NodePath").get_material()

var virtualImage : Image
var shaderTexture : ImageTexture

func _ready():
	virtualImage = Image.new()
	shaderTexture = ImageTexture.new()
	virtualImage.create(256, 3, false, Image.FORMAT_RGB8)
	_updateSwapShader()

func _updateSwapShader():
	virtualImage.lock()
	
	for pixelX in range(256):
		for pixelY in range(3):
			if swapColors[pixelX + pixelY * 256] == Color(0,0,0):
				continue
			virtualImage.set_pixel(pixelX, pixelY, swapColors[pixelX + pixelY * 256])
	
	virtualImage.unlock()
	shaderTexture.create_from_image(virtualImage, 0)
	
#	Help needed - Optimization chance. Instead of creating a whole new texture everytime it would be better to partially update the texture.
#	VisualServer.texture_set_data_partial(shaderTexture.get_rid(), virtualImage, 2, 0, 1, 1, 0, 0, 0, 0) 
	
	shaderMat.set_shader_param("swapArray", shaderTexture)
