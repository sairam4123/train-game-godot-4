shader_type spatial;

void vertex() {
	mat2 rot = mat2(vec2(cos(TIME), sin(TIME)), vec2(-sin(TIME), cos(TIME)));
	VERTEX.xy = rot * VERTEX.xy;
}
