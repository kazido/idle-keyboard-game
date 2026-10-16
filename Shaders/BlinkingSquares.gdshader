shader_type canvas_item;

uniform vec2 bubbleReslution = vec2(24.0, 13.5); //Make sure this matches the aspect ratio so you get perfect squares (default is 16:9)
uniform float bubbleDuration = 0.2; //What percentage of the time bubbles are visisble
uniform float cycleSpeed = 0.05; //How fast the shader cycles through bubles (1 = all bubbles in 1 sec, 0.05 = all bubles in 20 sec)
uniform float scrollSpeed = 0.05; //How fast the bubles float upwards

uniform sampler2D noiseTexture : repeat_enable, filter_nearest; //Texture that drives the bubbles. For best results, use Simplex with no FBM (this gives a constant amount of bubles at any given time)
uniform sampler2D bubbleTexture : filter_linear; //Greyscale image, samples bubbleColor based on alpha
uniform sampler2D bubbleColor : filter_linear; //Gradient Texture 1D
uniform sampler2D vineteGradient : filter_linear; //Gradient Texture 2D

void fragment() {
	vec2 qUV = floor((UV + vec2(0.0, TIME * scrollSpeed)) * bubbleReslution) / bubbleReslution;
	vec2 localUV = fract((UV + vec2(0.0, TIME * scrollSpeed)) * bubbleReslution); //for sampling the tex
	
	float noiseVal = texture(noiseTexture, qUV).r;
	float loopTime = fract(TIME * cycleSpeed);
	
	//circular loop
	float minDis = min(min(distance(loopTime, noiseVal), distance(loopTime - 1.0, noiseVal)), distance(loopTime + 1.0, noiseVal));
	float blinkVal = smoothstep(1.0 - bubbleDuration, 1.0, 1.0 - minDis);
	
	//make the textures go up a bit more as they fade (and start lower as well). Normalized by bubble duration so bubles dont leave the bbox
	localUV.y += minDis / (bubbleDuration * 12.0);
	//To Clip Space, scale, then back
	localUV = (localUV - 0.5) * 2.0;
	localUV /= blinkVal;
	localUV = (localUV + 1.0) * 0.5;
	
	//construct final output
	vec4 finalSquare = texture(bubbleColor, vec2(texture(bubbleTexture, localUV).a, 1.0)); //alpha based lookup for bubbleColor
	finalSquare.a *= blinkVal; //fade based on lifetime
	
	float disToCenter = distance(UV, vec2(0.5, 0.5)); //fade based on distance to center
	finalSquare.a -= smoothstep(0.3, 0.7, distance(UV, vec2(0.5, 0.5)));
	finalSquare.a = clamp(finalSquare.a, 0.0, 1.0);
	
	COLOR = texture(vineteGradient, UV);
	COLOR.rgb += (finalSquare.rgb * finalSquare.a);
}
