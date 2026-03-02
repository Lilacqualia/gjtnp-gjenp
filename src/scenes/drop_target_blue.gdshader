shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR = vec4(COLOR.g, COLOR.g, COLOR.r, COLOR.q);
}
