#pragma header

uniform float uTime;
uniform float money;
uniform bool awesomeOutline;

vec3 rgb2hsv(vec3 c)
{
    vec4 k = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, k.wz), vec4(c.gb, k.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 k = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + k.xyz) * 6.0 - k.www);
    return c.z * mix(k.xxx, clamp(p - k.xxx, 0.0, 1.0), c.y);
}

void main()
{
    #pragma body

    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
    vec4 swagColor = vec4(rgb2hsv(vec3(color[0], color[1], color[2])), color[3]);

    swagColor[0] += uTime;

    color = vec4(hsv2rgb(vec3(swagColor[0], swagColor[1], swagColor[2])), swagColor[3]);

    if (awesomeOutline)
    {
        vec2 size = vec2(3, 3);

        if (color.a <= 0.5)
        {
            float w = size.x / openfl_TextureSize.x;
            float h = size.y / openfl_TextureSize.y;

            if (flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x + w, openfl_TextureCoordv.y)).a != 0.
            || flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x - w, openfl_TextureCoordv.y)).a != 0.
            || flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x, openfl_TextureCoordv.y + h)).a != 0.
            || flixel_texture2D(bitmap, vec2(openfl_TextureCoordv.x, openfl_TextureCoordv.y - h)).a != 0.)
                color = vec4(1.0, 1.0, 1.0, 1.0);
        }
    }

    gl_FragColor = color;
}