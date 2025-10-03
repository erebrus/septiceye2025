shader_type canvas_item;

uniform vec3 target_color: source_color = vec3(1.0);
uniform float shift_amount: hint_range(0.0, 360.0, 1.0) = 0.0;


// Convert RGB color to HSV color space
// Input: vec3 with components in range [0, 1]
// Output: vec3 with h in [0, 360], s and v in [0, 1]
vec3 rgb2hsv(vec3 rgb) {
	float r = rgb.r;
	float g = rgb.g;
	float b = rgb.b;
	
	float max_val = max(r, max(g, b));
	float min_val = min(r, min(g, b));
	float delta = max_val - min_val;
	
	float h = 0.0;
	float s = 0.0;
	float v = max_val;
	
	if (delta > 0.0001) {
		s = delta / max_val;
		
		if (abs(r - max_val) < 0.0001)      h = (g - b) / delta;
		else if (abs(g - max_val) < 0.0001) h = 2.0 + (b - r) / delta;
		else                                h = 4.0 + (r - g) / delta;
		
		h *= 60.0;
		if (h < 0.0) h += 360.0;
	}
	
	return vec3(h, s, v);
}

// Convert HSV color to RGB color space
// Input: vec3 with h in [0, 360], s and v in [0, 1]
// Output: vec3 with components in range [0, 1]
vec3 hsv2rgb(vec3 hsv) {
	float h = hsv.x;
	float s = hsv.y;
	float v = hsv.z;
	
	float c = v * s;
	float x = c * (1.0 - abs(mod(h / 60.0, 2.0) - 1.0));
	float m = v - c;
	
	vec3 rgb;
	
	if (h < 60.0)       rgb = vec3(c, x, 0.0);
	else if (h < 120.0) rgb = vec3(x, c, 0.0);
	else if (h < 180.0) rgb = vec3(0.0, c, x);
	else if (h < 240.0) rgb = vec3(0.0, x, c);
	else if (h < 300.0) rgb = vec3(x, 0.0, c);
	else                rgb = vec3(c, 0.0, x);
	
	rgb += m;
	return rgb;
}

float interpolate(float v1, float v2, float first_amount) {
	return v1 * first_amount + v2 * (1.0 - first_amount);
}

float interpolate_360(float v1, float v2, float first_amount) {
	if (abs(v1 - v2) < 180.0) {
		return v1 * first_amount + v2 * (1.0 - first_amount);
	}
	else {
		if (v1 < v2) v1 += 360.0;
		else v2 += 360.0;
		
		return mod(v1 * first_amount + v2 * (1.0 - first_amount), 360.0);
	}
}


float mix1(float v1, float v2, float progress) {
	if (v2 < v1) return v1 * (1.0 - progress) + v2 * progress;
}

float mix2(float v1, float v2) {
	return clamp(v1+v2, 0.0, 1.0);
}

float mix3(float v1, float v2) {
	return (v1 + v2) * 0.5;
}

float mix4(float v1, float v2) {
	return 1.0 - clamp(2.0 - v1 - 0.2 * v2, 0.0, 1.0);
}

float mix5(float v1, float v2) {
	float direction = v1 - 0.5;
	
	return clamp(v2 + 0.2 * direction, 0.0, 1.0);
}

void fragment() {
	vec3 hsv_color = rgb2hsv(COLOR.rgb);
	vec3 hsv_target = rgb2hsv(target_color);
	hsv_color.x = interpolate_360(hsv_color.x, hsv_target.x, 0.1);
	hsv_color.y = mix5(hsv_color.y, hsv_target.y);
	hsv_color.z = mix5(hsv_color.z, hsv_target.z);
	
	COLOR.rgb = hsv2rgb(hsv_color);
}
