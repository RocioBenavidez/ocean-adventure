shader_type canvas_item;

// Color base del agua
uniform vec4 color : source_color;

// Textura de ruido (para ondas y distorsión)
uniform sampler2D fast_noise : repeat_enable;

// Textura de "profundidad" (la asignarás desde el editor)
uniform sampler2D depth_map; // NO es depth_texture del motor

// Velocidad de animación de las ondas
uniform vec2 speed = vec2(0.03, 0.07);

// Intensidad de la ola/distorsión
uniform float wave_strength = 2.0;

// Brillo del agua en zonas poco profundas
uniform float shallow_color_multiplier = 1.5;

void fragment() {
    // Animar el ruido para crear ondas
    vec2 uv = UV;
    vec2 noise_uv = uv + speed * TIME;
    vec2 noise = texture(fast_noise, noise_uv).rg * 2.0 - 1.0; // Centrar en 0

    // Distorsión de UV para ondas
    vec2 distorted_uv = uv + noise * (wave_strength / 100.0);

    // Leer el "mapa de profundidad" (blanco = profundo, negro = poco profundo)
    float depth = texture(depth_map, distorted_uv).r;

    // Ajustar color según profundidad: menos profundo = más claro
    vec3 water_color = color.rgb;
    water_color = mix(water_color * shallow_color_multiplier, water_color, depth);

    // Aplicar textura de ruido para brillo dinámico
    float noise_detail = texture(fast_noise, uv * 2.0 + speed * TIME * 1.5).b;
    water_color += noise_detail * 0.1;

    // Salida final
    COLOR.rgb = water_color;
    COLOR.a = 1.0;
}