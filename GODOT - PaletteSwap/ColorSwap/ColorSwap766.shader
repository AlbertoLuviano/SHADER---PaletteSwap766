shader_type canvas_item;

uniform sampler2D swapArray;

void fragment(){
	vec4 textureColor = texture(TEXTURE, UV);
	float arrayIndexX = textureColor.r + textureColor.g + textureColor.b;
	
	float redChannel = textureColor.r * sign(textureColor.r);
	float greenChannel = (textureColor.g + 1.0) * sign(textureColor.g);
	float blueChannel = (textureColor.b + 2.0) * sign(textureColor.b);
	float arrayIndexY = (redChannel + greenChannel + blueChannel) / 3.0;
	
	COLOR.rgb = texture(swapArray, vec2(arrayIndexX, arrayIndexY)).rgb;
	COLOR.a = textureColor.a;
}