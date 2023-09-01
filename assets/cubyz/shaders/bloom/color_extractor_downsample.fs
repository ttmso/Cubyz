#version 430

layout(location=0) out vec4 fragColor;

in vec2 texCoords;

layout(binding = 3) uniform sampler2D color;

vec3 fetch(ivec2 pos) {
	vec4 rgba = texelFetch(color, pos, 0);
	if(rgba.a < 1) return vec3(0); // Prevent t-junctions from transparency from making a huge mess.
	return rgba.rgb/rgba.a;
}

vec3 linearSample(ivec2 start) {
	vec3 outColor = vec3(0);
	outColor += fetch(start);
	outColor += fetch(start + ivec2(0, 1));
	outColor += fetch(start + ivec2(1, 0));
	outColor += fetch(start + ivec2(1, 1));
	return outColor*0.25;
}

void main() {
	vec3 bufferData = linearSample(ivec2(texCoords));
	float bloomFactor = max(max(bufferData.x, max(bufferData.y, bufferData.z)) - 1.0, 0);
	fragColor = vec4(bufferData*bloomFactor, 1);
}