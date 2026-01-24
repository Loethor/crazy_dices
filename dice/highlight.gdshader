shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform int outline_width = 1;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    vec4 color = tex;

    if (tex.a == 0.0 && outline_width > 0) {
        vec2 px = TEXTURE_PIXEL_SIZE;

        bool outline = false;

        for (int x = -outline_width; x <= outline_width; x++) {
            for (int y = -outline_width; y <= outline_width; y++) {
                vec2 offset = vec2(float(x), float(y)) * px;
                if (texture(TEXTURE, UV + offset).a > 0.0) {
                    outline = true;
                }
            }
        }

        if (outline) {
            color = outline_color;
        }
    }

    COLOR = color;
}
