shader_type canvas_item;

uniform float cursor_pos : hint_range(0.0, 1.0);
uniform float cursor_width = 0.02;

uniform vec2 success_range = vec2(0.4, 0.6);

uniform vec4 bar_color : source_color = vec4(0.2, 0.2, 0.2, 1.0);
uniform vec4 success_color : source_color = vec4(0.2, 0.8, 0.2, 1.0);
uniform vec4 cursor_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	float x = UV.x;

	
	vec4 color = bar_color;

	
	if (x >= success_range.x && x <= success_range.y) {
		color = success_color;
	}

	
	float dist = abs(x - cursor_pos);
	if (dist < cursor_width) {
		color = cursor_color;
	}

	COLOR = color;
}