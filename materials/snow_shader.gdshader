shader_type spatial;

float hash(vec2 p) {
  return fract(sin(dot(p * 17.17, vec2(14.91, 67.31))) * 4791.9511);
}

float noise(vec2 x) {
  vec2 p = floor(x);
  vec2 f = fract(x);
  f = f * f * (3.0 - 2.0 * f);
  vec2 a = vec2(1.0, 0.0);
  return mix(mix(hash(p + a.yy), hash(p + a.xy), f.x),
         mix(hash(p + a.yx), hash(p + a.xx), f.x), f.y);
}

float fbm(vec2 x) {
  float height = 0.8;
  float amplitude = 1.2;
  float frequency = 4.0;
  for (int i = 0; i < 6; i++){
    height += noise(x * frequency) * amplitude;
    amplitude *= 0.5;
    frequency *= 2.0;
  }
  return height;
}

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX.y = fbm(VERTEX.xz * 0.5);
	COLOR.z = clamp(VERTEX.y, 0.2, 1.9) * 1.2;
	COLOR.y = clamp(VERTEX.y, 0.2, 1.5);
	COLOR.x = clamp(VERTEX.y, 0.2, 1.5);
	
}

void fragment() {
	// Called for every pixel the material is visible on.
	ALBEDO = COLOR.xyz;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
