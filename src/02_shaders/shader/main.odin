package shader

import "core:fmt"
import "core:os"
import "core:strings"

import gl "vendor:OpenGL"

VERTEX_SHADER_PATH :: "vertex.glsl"
FRAGMENT_SHADER_PATH :: "fragment.glsl"

use :: proc(shaderProgram: u32) {
	gl.UseProgram(shaderProgram)
}

create :: proc() -> (shaderProgram: u32) {
	ok := false
	vertexShader, fragmentShader: u32
	if vertexShader, ok = createShader(VERTEX_SHADER_PATH, gl.VERTEX_SHADER);
	   !ok {
		fmt.println("Failed to load vertex shader")
	}

	if fragmentShader, ok = createShader(
		FRAGMENT_SHADER_PATH,
		gl.FRAGMENT_SHADER,
	); !ok {
		fmt.println("Failed to load fragment shader")
	}

	shaderProgram = createShaderProgram(vertexShader, fragmentShader)
	return
}

createShader :: proc(path: string, type: u32) -> (u32, bool) {
	shader: u32
	shader = gl.CreateShader(type)
	shaderSrc := getShaderSource(path)
	vertexPtr: [^]cstring = &shaderSrc
	gl.ShaderSource(shader, 1, vertexPtr, nil)

	if ok := compileShader(shader); !ok {
		return 0, false
	}

	return shader, true
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

setBoolUniform :: proc(program: u32, name: string, value: bool) {
	gl.Uniform1i(
		gl.GetUniformLocation(program, strings.clone_to_cstring(name)),
		i32(value),
	)
}

setIntUniform :: proc(program: u32, name: string, value: int) {
	gl.Uniform1i(
		gl.GetUniformLocation(program, strings.clone_to_cstring(name)),
		i32(value),
	)
}

setFloatUniform :: proc(program: u32, name: string, value: f32) {
	gl.Uniform1f(
		gl.GetUniformLocation(program, strings.clone_to_cstring(name)),
		value,
	)
}

createShaderProgram :: proc(shaders: ..u32) -> (shaderProgram: u32) {
	shaderProgram = gl.CreateProgram()

	for shader in shaders {
		gl.AttachShader(shaderProgram, shader)
	}

	linkProgram(shaderProgram)

	gl.UseProgram(shaderProgram)

	for shader in shaders {
		gl.DeleteShader(shader)
	}

	return
}

linkProgram :: proc(program: u32) {
	success: i32
	infoLog: [512]u8

	gl.LinkProgram(program)

	gl.GetProgramiv(program, gl.LINK_STATUS, &success)
	if success == 0 {
		gl.GetProgramInfoLog(program, 512, nil, raw_data(infoLog[:]))
		fmt.println("Error linking program: ", cstring(raw_data(infoLog[:])))
	}
}
