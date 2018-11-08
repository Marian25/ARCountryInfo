uniform vec4 haloColor = vec4(0.14, 0.32, 0.83, 0.50);

vec2 haloCenter = vec2(0.0, 0.0);
float haloRadius = 0.6;

float haloIntensity = distance(_surface.position.xy, haloCenter) / haloRadius;
haloIntensity = pow(haloIntensity, 1.2);

_output.color.rgba += haloIntensity * haloColor;

