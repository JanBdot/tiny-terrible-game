#version 450 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aColor;

out vec4 ourColor;

uniform float xOffset;

void main()
{
    vec4 vertexPosition = vec4(aPos.x + xOffset, aPos.y, aPos.z, 1.0);
    gl_Position = vertexPosition;
    ourColor = vertexPosition;
    // ourColor = vec4(aColor, 1.0);
}