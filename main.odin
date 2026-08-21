package main

import "core:fmt"

import gl "vendor:OpenGL"

import "vendor:glfw"

GL_MAJOR_VERSION :: 4
GL_MINOR_VERSION :: 5

WINDOW_WIDTH :: 500
WINDOW_HEIGHT :: 500

PROGRAMNAME :: "TinyTerribleGame"
VERTEX_SHADER_PATH :: "vertex.glsl"
FRAGMENT_SHADER_PATH :: "fragment.glsl"

running: b32 = true

initGl :: proc() {
	gl.load_up_to(GL_MAJOR_VERSION, GL_MINOR_VERSION, glfw.gl_set_proc_address)

	vertexShader := useShader(VERTEX_SHADER_PATH, gl.VERTEX_SHADER)
	compileShader(vertexShader)

	fragmentShader := useShader(FRAGMENT_SHADER_PATH, gl.FRAGMENT_SHADER)
	compileShader(fragmentShader)

	shaderProgram := useShaderProgram(vertexShader, fragmentShader)

	vao, vbo, ebo: u32
	gl.GenVertexArrays(1, &vao)
	gl.GenBuffers(1, &vbo)
	gl.GenBuffers(1, &ebo)

	gl.BindVertexArray(vao)
	gl.BindBuffer(gl.ARRAY_BUFFER, vbo)
	fmt.println("%v", getTriangleVertices())
	gl.BufferData(
		gl.ARRAY_BUFFER,
		getBufferSize(),
		getTriangleVerticesPtr(),
		gl.STATIC_DRAW,
	)

	gl.VertexAttribPointer(0, 3, gl.FLOAT, gl.FALSE, i32(getBufferSize()), 0)

	gl.EnableVertexAttribArray(0)
	gl.BindBuffer(gl.ARRAY_BUFFER, 0)
	gl.BindVertexArray(0)
}

update :: proc() {
	// update code
}

draw :: proc() {
	gl.ClearColor(0.2, 0.3, 0.3, 1.0)
	gl.Clear(gl.COLOR_BUFFER_BIT)

	gl.UseProgram(shaderProgram)
	gl.BindVertexArray(vao)
	gl.DrawArrays(gl.TRIANGLES, 0, 3)
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
