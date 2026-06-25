shader_type canvas_item;

// Control the celebration colors
uniform vec4 base_color : source_color = vec4(0.05, 0.03, 0.1, 1.0); // Dark tech background
uniform vec4 glow_color : source_color = vec4(0.98, 0.75, 0.2, 1.0);  // Gold/Amber victory glow
uniform float speed : hint_range(0.5, 5.0) = 2.0;

// Pseudo-random function to generate "digital key" patterns
float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

void fragment() {
    // Normalize coordinates into vertical keyboard columns
    vec2 uv = UV;
    
    // Create a subtle, pulsing victory vignette behind the text
    float center_dist = length(uv - vec2(0.5));
    float pulse = sin(TIME * speed * 0.5) * 0.05 + 0.95;
    vec4 final_bg = mix(glow_color * 0.25 * pulse, base_color, center_dist);

    // Grid size for the falling "key symbols"
    vec2 grid = vec2(30.0, 15.0); 
    vec2 ipos = floor(uv * grid);
    vec2 fpos = fract(uv * grid);

    // Add a time-based vertical offset to create the "falling/cascading" effect
    ipos.y += floor(TIME * speed * (1.0 + hash(vec2(ipos.x, 1.0)) * 0.5));

    // Generate random binary/symbol shapes inside the grid cells
    float char_shape = hash(ipos);
    
    // Binary-like mechanical matrix pattern masking
    float pct = 0.0;
    if (char_shape > 0.4) {
        // Create simple digital box/line matrix artifacts resembling key switches or legends
        pct = step(0.15, fpos.x) * step(0.15, 1.0 - fpos.x) * step(0.15, fpos.y) * step(0.15, 1.0 - fpos.y);
        pct -= step(0.25, fpos.x) * step(0.25, 1.0 - fpos.x) * step(0.25, fpos.y) * step(0.25, 1.0 - fpos.y);
    }

    // Fade the symbols out towards the top and bottom to focus on the center text
    float vertical_fade = smoothstep(0.0, 0.5, uv.y) * smoothstep(1.0, 0.5, uv.y);
    
    // Give each falling column a varied brightness
    float column_brightness = hash(vec2(floor(uv.x * grid.x), 0.0));
    
    // Combine everything
    vec3 matrix_glow = glow_color.rgb * pct * column_brightness * vertical_fade * 0.6;
    
    COLOR = vec4(final_bg.rgb + matrix_glow, 1.0);
}