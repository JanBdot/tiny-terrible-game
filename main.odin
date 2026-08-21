package main

import gl "vendor:OpenGL"

import "vendor:glfw"

GL_MAJOR_VERSION :: 4
GL_MINOR_VERSION :: 5

WINDOW_WIDTH :: 500
WINDOW_HEIGHT :: 500

PROGRAMNAME :: "TinyTerribleGame"
VERTEX_SHADER_PATH :: "vertex.glsl"
FRAGMENT_SHADER_PATH :: "fragment.glsl"
FRAGMENT2_SHADER_PATH :: "fragment2.glsl"

running: b32 = true

vaos := [1]u32{}
vbos := [1]u32{}
ebo, shaderProgram, shaderProgram2: u32

initGl :: proc() {
	gl.load_up_to(GL_MAJOR_VERSION, GL_MINOR_VERSION, glfw.gl_set_proc_address)

	vertexShader := useShader(VERTEX_SHADER_PATH, gl.VERTEX_SHADER)
	compileShader(vertexShader)

	fragmentShader := useShader(FRAGMENT_SHADER_PATH, gl.FRAGMENT_SHADER)
	compileShader(fragmentShader)

	shaderProgram = useShaderProgram(vertexShader, fragmentShader)

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

	gl.VertexAttribPointer(0, 3, gl.FLOAT, gl.FALSE, 3 * size_of(f32), 0)

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
