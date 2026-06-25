shader_type canvas_item;

// Colors & Tuning
uniform vec4 base_color : source_color = vec4(0.02, 0.03, 0.05, 1.0);     // Pitch black / deep slate
uniform vec4 glow_color : source_color = vec4(0.85, 0.15, 0.15, 1.0);     // Deep failure blue or warning amber
uniform vec2 mouse_position = vec2(0.5, 0.5);                             // Fed from a GDScript
uniform float glow_radius : hint_range(0.1, 1.0) = 0.35;                  // How far the mouse light reaches
uniform float grid_count = 35.0;                                          // Number of keys across the screen

void fragment() {
    vec2 uv = UV;
    
    // Create a sharp, proportional keyboard grid layout
    // We scale the Y axis so the keys look like rectangular keycaps, not perfect squares
    vec2 grid_uv = fract(uv * vec2(grid_count, grid_count * 0.5));
    vec2 grid_id = floor(uv * vec2(grid_count, grid_count * 0.5));
    
    // Thin, crisp mechanical grid lines (the PCB board traces)
    float grid_lines = step(0.92, grid_uv.x) + step(0.92, grid_uv.y);
    grid_lines = clamp(grid_lines, 0.0, 1.0);
    
    // Subtle internal keycap shadow/border to give it depth
    float key_box = step(0.1, grid_uv.x) * step(0.1, 1.0 - grid_uv.x) * step(0.1, grid_uv.y) * step(0.1, 1.0 - grid_uv.y);
    
    // Calculate distance from this pixel to the mouse pointer
    float dist_to_mouse = length(uv - mouse_position);
    
    // Smooth radial falloff for the mouse glow
    float mouse_glow = smoothstep(glow_radius, 0.0, dist_to_mouse);
    
    // Mix the ambient dark background with the mouse illumination
    vec3 final_bg = base_color.rgb;
    
    // Light up the grid lines near the mouse
    vec3 illuminated_grid = mix(final_bg, glow_color.rgb * 0.6, grid_lines * mouse_glow);
    
    // Light up the inside of the keys slightly less, creating a "backlit PCB" look
    vec3 illuminated_keys = mix(illuminated_grid, glow_color.rgb * 0.12, (1.0 - key_box) * mouse_glow);
    
    // Add a soft center vignette so the screen edges stay dark, keeping focus on the UI text
    float vignette = smoothstep(0.8, 0.4, length(uv - vec2(0.5)));
    vec3 final_color = mix(base_color.rgb * 0.5, illuminated_keys, vignette);
    
    COLOR = vec4(final_color, 1.0);
}