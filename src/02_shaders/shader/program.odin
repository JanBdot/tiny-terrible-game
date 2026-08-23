package shader

import "core:fmt"

import gl "vendor:OpenGL"

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
