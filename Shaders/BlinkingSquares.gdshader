shader_type canvas_item;

uniform vec4 base_color : source_color = vec4(0.25, 0.6, 1.0, 1.0);  // the one color you set
uniform float bg_brightness = 0.35;     // vignette center brightness (fraction of base_color)
uniform float bg_edge_brightness = 0.05; // vignette edge brightness
uniform float bubble_whiten = 0.5;      // how far the brightest part of a bubble pushes toward white

uniform vec2 bubbleReslution = vec2(24.0, 13.5);
uniform float bubbleDuration = 0.2;
uniform float cycleSpeed = 0.05;
uniform float scrollSpeed = 0.05;

uniform sampler2D noiseTexture : repeat_enable, filter_nearest;
uniform sampler2D bubbleTexture : filter_linear;

void fragment() {
	vec2 qUV = floor((UV + vec2(0.0, TIME * scrollSpeed)) * bubbleReslution) / bubbleReslution;
	vec2 localUV = fract((UV + vec2(0.0, TIME * scrollSpeed)) * bubbleReslution);

	float noiseVal = texture(noiseTexture, qUV).r;
	float loopTime = fract(TIME * cycleSpeed);

	float minDis = min(min(distance(loopTime, noiseVal), distance(loopTime - 1.0, noiseVal)), distance(loopTime + 1.0, noiseVal));
	float blinkVal = smoothstep(1.0 - bubbleDuration, 1.0, 1.0 - minDis);

	localUV.y += minDis / (bubbleDuration * 12.0);
	localUV = (localUV - 0.5) * 2.0;
	localUV /= blinkVal;
	localUV = (localUV + 1.0) * 0.5;

	// Bubble color: replaces the bubbleColor gradient lookup.
	// The bubble texture's alpha (0..1) walks from a dark shade to a bright shade of base_color.
	float t = texture(bubbleTexture, localUV).a;
	vec3 dark = base_color.rgb * 0.5;
	vec3 bright = mix(base_color.rgb, vec3(1.0), bubble_whiten);
	vec4 finalSquare = vec4(mix(dark, bright, t), t);

	finalSquare.a *= blinkVal;
	finalSquare.a -= smoothstep(0.3, 0.7, distance(UV, vec2(0.5)));
	finalSquare.a = clamp(finalSquare.a, 0.0, 1.0);

	// Background: replaces the vineteGradient texture
	float v = smoothstep(0.0, 0.75, distance(UV, vec2(0.5)));
	COLOR = vec4(base_color.rgb * mix(bg_brightness, bg_edge_brightness, v), 1.0);

	COLOR.rgb += finalSquare.rgb * finalSquare.a;
}