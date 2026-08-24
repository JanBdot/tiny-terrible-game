package main

import "core:fmt"
import "core:os"
import "core:strings"

import gl "vendor:OpenGL"
import "vendor:glfw"

runnig: b32 = true

vao, vab, eab, shaderProgram: u32

// odinfmt: disable
vertices : []f32 = {
    -0.5, 1.0, 0.0,     // top-left
    0.5, 1.0, 0.0,      // top-right
    -0.5, -1.0, 0.0,    // bottom-left
    0.5, -1.0, 0.0,     // bottom-right
}

indices : []f32 = {
    0, 2, 3,    // triangle 1
    0, 1, 3,    // triangle 2
}
// odinfmt: enable

main :: proc() {
	// GLFW
	glfw.WindowHint(glfw.RESIZABLE, 1)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, 4)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, 5)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

	if ok := glfw.Init(); !ok {
		fmt.println("Failed to init glfw")
		return
	}
	defer glfw.Terminate()

	window := glfw.CreateWindow(500, 500, "Pong", nil, nil)

	glfw.MakeContextCurrent(window)
	glfw.SwapInterval(1)
	defer glfw.DestroyWindow(window)

	// OpenGl
	gl.load_up_to(4, 5, glfw.gl_set_proc_address)

	vertexShader := gl.CreateShader(gl.VERTEX_SHADER)
	vertexSrc := getShaderSource("./vertex.glsl")
	gl.ShaderSource(vertexShader, 1, &vertexSrc, nil)
	compileShader(vertexShader)

	fragmentShader := gl.CreateShader(gl.FRAGMENT_SHADER)
	fragmentSrc := getShaderSource("./fragment.glsl")
	gl.ShaderSource(fragmentShader, 1, &fragmentSrc, nil)
	compileShader(fragmentShader)

	for (!glfw.WindowShouldClose(window) && runnig) {
		glfw.PollEvents()

		// loop

		glfw.SwapBuffers(window)
	}
}

getShaderSource :: proc(path: string) -> cstring {
	data, err := os.read_entire_file(path, context.allocator)
	if err != nil {
		fmt.println("Error reading shader file")
		return nil
	}
	defer delete(data, context.allocator)

	return strings.clone_to_cstring(string(data))
}

compileShader :: proc(shader: u32) -> bool {
	success: i32
	infoLog: [512]u8

	gl.CompileShader(shader)

	gl.GetShaderiv(shader, gl.COMPILE_STATUS, &success)
	if success == 0 {
		gl.GetShaderInfoLog(shader, 512, nil, raw_data(infoLog[:]))
		fmt.println(
			"Error shader compilation: ",
			cstring(raw_data(infoLog[:])),
		)
		return false
	}
	return true
}
