shader_type canvas_item;

uniform vec4 aura_color : source_color = vec4(0.4, 0.8, 1.0, 1.0); // aura tint
uniform float aura_width_px : hint_range(0.0, 64.0) = 16.0;        // how far glow extends (in texture pixels)
uniform float aura_softness : hint_range(0.0, 1.0) = 0.6;          // edge softness of the glow
uniform float pulse_speed : hint_range(0.0, 10.0) = 1.5;            // pulses per second-ish
uniform float pulse_strength : hint_range(0.0, 1.0) = 0.6;          // 0=no pulse, 1=full pulse
uniform float base_intensity : hint_range(0.0, 5.0) = 1.0;          // overall brightness of aura

// Cheap multi-tap dilation to get a halo from the sprite's alpha.
float dilate_alpha(sampler2D tex, vec2 uv, float px_radius) {
    vec2 texel = 1.0 / vec2(textureSize(tex, 0)); // <-- fixed line
    float a0 = texture(tex, uv).a;
    float mx = a0;

    const int TAPS = 8;
    for (int i = 0; i < TAPS; i++) {
        float ang = (6.2831853 / float(TAPS)) * float(i);
        vec2 dir = vec2(cos(ang), sin(ang));
        vec2 off_uv = uv + dir * texel * px_radius;
        mx = max(mx, texture(tex, off_uv).a);
    }
    return mx;
}


void fragment() {
    vec4 base = texture(TEXTURE, UV);

    // Pulsing factor 0..1
    float pulse = 0.5 + 0.5 * sin(TIME * pulse_speed * 6.2831853);
    float pulse_scale = mix(1.0 - pulse_strength, 1.0, pulse);

    // Dilate alpha outward (aura “thickness”), then subtract the original alpha so halo is outside the sprite
    float expanded = dilate_alpha(TEXTURE, UV, aura_width_px * pulse_scale);
    float halo = max(expanded - base.a, 0.0);

    // Soften edge
    halo = smoothstep(0.0, aura_softness, halo);

    // Compose: keep the sprite, add aura color on top
    vec3 aura = aura_color.rgb * (aura_color.a * base_intensity) * halo;
    vec3 rgb = base.rgb + aura;

    // Keep sprite’s original alpha so it remains clickable/occludable as usual
    COLOR = vec4(rgb, base.a);
}
