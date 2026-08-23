package main

import "core:fmt"
import "core:math"
import gl "vendor:OpenGL"

import "vendor:glfw"

import "./shader"

GL_MAJOR_VERSION :: 4
GL_MINOR_VERSION :: 5

WINDOW_WIDTH :: 500
WINDOW_HEIGHT :: 500

PROGRAMNAME :: "TinyTerribleGame"
VERTEX_SHADER_PATH :: "vertex.glsl"
FRAGMENT_SHADER_PATH :: "fragment.glsl"

running: b32 = true

vaos := [1]u32{}
vbos := [1]u32{}
ebo, shaderProgram, shaderProgram2: u32

initGl :: proc() {
	gl.load_up_to(GL_MAJOR_VERSION, GL_MINOR_VERSION, glfw.gl_set_proc_address)

	ok := false
	vertexShader, fragmentShader: u32
	if vertexShader, ok = shader.useShader(
		VERTEX_SHADER_PATH,
		gl.VERTEX_SHADER,
	); !ok {
		fmt.println("Failed to load vertex shader")
	}

	if fragmentShader, ok = shader.useShader(
		FRAGMENT_SHADER_PATH,
		gl.FRAGMENT_SHADER,
	); !ok {
		fmt.println("Failed to load fragment shader")
	}

	shaderProgram = shader.useShaderProgram(vertexShader, fragmentShader)

	gl.GenVertexArrays(2, raw_data(vaos[:]))
	gl.GenBuffers(2, raw_data(vbos[:]))
	gl.GenBuffers(1, &ebo)

	// First triangle
	gl.BindVertexArray(vaos[0])
	gl.BindBuffer(gl.ARRAY_BUFFER, vbos[0])
	gl.BufferData(
		gl.ARRAY_BUFFER,
		getBufferSize(),
		getTriangleVerticesPtr(),
		gl.STATIC_DRAW,
	)

	// position
	gl.VertexAttribPointer(0, 3, gl.FLOAT, gl.FALSE, 6 * size_of(f32), 0)
	gl.EnableVertexAttribArray(0)

	// color
	gl.VertexAttribPointer(
		1,
		3,
		gl.FLOAT,
		gl.FALSE,
		6 * size_of(f32),
		3 * size_of(f32),
	)
	gl.EnableVertexAttribArray(1)

	gl.BindBuffer(gl.ARRAY_BUFFER, 0)
	gl.BindVertexArray(0)
}

update :: proc() {
	// update code
}

draw :: proc() {
	gl.ClearColor(0.2, 0.3, 0.3, 1.0)
	gl.Clear(gl.COLOR_BUFFER_BIT)

	timeValue := glfw.GetTime()
	greenValue := f32((math.sin(timeValue) / 2) + 0.5)
	vertexColorLocation := gl.GetUniformLocation(shaderProgram, "ourColor")

	gl.UseProgram(shaderProgram)
	gl.Uniform4f(vertexColorLocation, 0.0, greenValue, 0.0, 1.0)
	gl.BindVertexArray(vaos[0])
	gl.DrawArrays(gl.TRIANGLES, 0, 3)

	gl.BindVertexArray(0)
}

exit :: proc() {
	// termination code
}

main :: proc() {
	// GLFW
	if ok := initGlfw(); !ok {
		return
	}
	defer glfw.Terminate()

	window, ok := createWindow(PROGRAMNAME)
	if !ok {
		return
	}
	defer glfw.DestroyWindow(window)

	initGl()
	// loop
	for (!glfw.WindowShouldClose(window) && running) {
		glfw.PollEvents()

		update()
		draw()

		glfw.SwapBuffers(window)
	}

	exit()
}
