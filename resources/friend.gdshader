shader_type canvas_item;

uniform float speed = 3.0;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	COLOR = vec4(tex_color.rgb, tex_color.a * sin(TIME * speed));
}

