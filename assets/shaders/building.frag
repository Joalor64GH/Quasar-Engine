#pragma header

uniform float alphaShit;

void main()
{
    #pragma body
    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);

    if (color.a > 0.0)
        color -= alphaShit;

    gl_FragColor = color;
}