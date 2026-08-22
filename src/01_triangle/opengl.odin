package main

import "core:fmt"
import "core:os"
import "core:strings"

import gl "vendor:OpenGL"

useShader :: proc(path: string, type: u32) -> u32 {
	shader: u32
	shader = gl.CreateShader(type)
	shaderSrc := getShaderSource(path)
	vertexPtr: [^]cstring = &shaderSrc
	gl.ShaderSource(shader, 1, vertexPtr, nil)

	return shader
}

useShaderProgram :: proc(shaders: ..u32) -> (shaderProgram: u32) {
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

getShaderSource :: proc(path: string) -> cstring {
	data, err := os.read_entire_file(path, context.allocator)
	if err != nil {
		fmt.println("Error reading shader file")
		return nil
	}
	defer delete(data, context.allocator)

	return strings.clone_to_cstring(string(data))
}

compileShader :: proc(shader: u32) {
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
	}
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
