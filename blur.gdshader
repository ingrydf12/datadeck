shader_type canvas_item;
render_mode unshaded;

// Controles do blur
uniform int blur_radius : hint_range(1, 32) = 8;

void fragment() {
    vec4 color = vec4(0.0);
    float weight_sum = 0.0;
    
    // Sigma controla a suavidade
    float sigma = float(blur_radius) * 0.3;

    for (int x = -blur_radius; x <= blur_radius; x++) {
        for (int y = -blur_radius; y <= blur_radius; y++) {
            vec2 offset = vec2(float(x), float(y)) * TEXTURE_PIXEL_SIZE;
            
            // Peso gaussiano
            float weight = exp(-0.5 * (float(x * x) + float(y * y)) / (sigma * sigma));
            
            color += texture(TEXTURE, UV + offset) * weight;
            weight_sum += weight;
        }
    }
    
    COLOR = color / weight_sum;
}