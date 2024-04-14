shader_type canvas_item;

uniform float blur_amount = 10;

void fragment() {
    vec4 sum = vec4(0.0);
    vec2 texcoord = UV;

    // Horizontal blur
    sum += texture(TEXTURE, vec2(texcoord.x - 4.0 * blur_amount, texcoord.y)) * 0.05;
    sum += texture(TEXTURE, vec2(texcoord.x - 3.0 * blur_amount, texcoord.y)) * 0.09;
    sum += texture(TEXTURE, vec2(texcoord.x - 2.0 * blur_amount, texcoord.y)) * 0.12;
    sum += texture(TEXTURE, vec2(texcoord.x - blur_amount, texcoord.y)) * 0.15;
    sum += texture(TEXTURE, vec2(texcoord.x, texcoord.y)) * 0.16;
    sum += texture(TEXTURE, vec2(texcoord.x + blur_amount, texcoord.y)) * 0.15;
    sum += texture(TEXTURE, vec2(texcoord.x + 2.0 * blur_amount, texcoord.y)) * 0.12;
    sum += texture(TEXTURE, vec2(texcoord.x + 3.0 * blur_amount, texcoord.y)) * 0.09;
    sum += texture(TEXTURE, vec2(texcoord.x + 4.0 * blur_amount, texcoord.y)) * 0.05;

    // Output blurred color
    COLOR = sum;
}