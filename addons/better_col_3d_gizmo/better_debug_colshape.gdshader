shader_type spatial;
render_mode blend_mix, depth_test_disabled, cull_back, unshaded, shadows_disabled, wireframe;

uniform vec4 color: source_color = vec4(0.8, 0.1, 0.8, 0.1);

void fragment() {
	ALBEDO = color.rgb;
	ALPHA = color.a;
}