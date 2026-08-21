
package main

import "core:fmt"
import "core:os"
import "core:strings"

import gl "vendor:OpenGL"

// We use GLFW for cross platform window creation and input handling
import "vendor:glfw"

// // GL_VERSION define the version of OpenGL to use. Here we use 4.6 which is the newest version
// // You might need to lower this to 3.3 depending on how old your graphics card is.
// // Constant with explicit type for example
// GL_MAJOR_VERSION :: 4
// // Constant with type inference
// GL_MINOR_VERSION :: 5

// PROGRAMNAME :: "TinyTerribleGame"

// VERTEX_SHADER_PATH :: "vertex.glsl"
// FRAGMENT_SHADER_PATH :: "fragment.glsl"

// // Our own boolean storing if the application is running
// // We use b32 for allignment and easy compatibility with the glfw.WindowShouldClose procedure
// running : b32 = true

// vertices := []f32{
// 	// first triangle
//     0.5, 0.5, 0.0, // top right
//     0.5, -0.5, 0.0, // bottom right
//     -0.5, -0.5, 0.0, // bottom left
// 	-0.5, 0.5, 0.0	// top left
// }; 

indices := []u32{
	0, 1, 3,	// first triangle
	1, 2, 3		// second triangle
}

vbo : u32
vertexShader : u32
fragmentShader : u32
shaderProgram : u32
vao : u32
ebo : u32 // Element Buffer Object

// getShaderSource :: proc(path: string) -> cstring {
// 	data, err:= os.read_entire_file(path, context.allocator)
// 	if err != nil {
// 		fmt.println("Error reading shader file")
// 		return nil
// 	}
// 	defer delete(data, context.allocator)

// 	return strings.clone_to_cstring(string(data))
// }

// compileShader :: proc(shader: u32) {
// 	success : i32
// 	infoLog: [512]u8

// 	gl.CompileShader(shader)

// 	gl.GetShaderiv(shader, gl.COMPILE_STATUS, &success)
// 	if success == 0 {
// 		gl.GetShaderInfoLog(shader, 512, nil, raw_data(infoLog[:]))
// 		fmt.println("Error shader compilation: ", cstring(raw_data(infoLog[:])))
// 	}
// }

// linkProgram :: proc(program: u32) {
// 	success : i32
// 	infoLog: [512]u8

// 	gl.LinkProgram(program)

// 	gl.GetProgramiv(program, gl.LINK_STATUS, &success)
// 	if success == 0 {
// 		gl.GetProgramInfoLog(program, 512, nil, raw_data(infoLog[:]))
// 		fmt.println("Error linking program: ", cstring(raw_data(infoLog[:])))
// 	}
// }

// main :: proc() {
//     // https://www.glfw.org/docs/3.3/window_guide.html#window_hints
// 	// https://www.glfw.org/docs/3.3/group__window.html#ga7d9c8c62384b1e2821c4dc48952d2033
// 	glfw.WindowHint(glfw.RESIZABLE, 1)
// 	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR,GL_MAJOR_VERSION) 
// 	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR,GL_MINOR_VERSION)
// 	glfw.WindowHint(glfw.OPENGL_PROFILE,glfw.OPENGL_CORE_PROFILE)

//     // Initialize glfw
// 	// GLFW_TRUE if successful, or GLFW_FALSE if an error occurred.
// 	// GLFW_TRUE = 1
// 	// GLFW_FALSE = 0
// 	// https://www.glfw.org/docs/latest/group__init.html#ga317aac130a235ab08c6db0834907d85e
// 	if(glfw.Init() != true){
// 		// Print Line
// 		fmt.println("Failed to initialize GLFW")
// 		// Return early
// 		return
// 	}
// 	// the defer keyword makes the procedure run when the calling procedure exits scope
// 	// Deferes are executed in reverse order. So the window will get destoryed first
// 	// They can also just be called manually later instead without defer. This way of doing it ensures are terminated.
// 	// https://odin-lang.org/docs/overview/#defer-statement
// 	// https://www.glfw.org/docs/3.1/group__init.html#gaaae48c0a18607ea4a4ba951d939f0901
// 	defer glfw.Terminate()

//     // Create the window
// 	// Return WindowHandle rawPtr
// 	// https://www.glfw.org/docs/3.3/group__window.html#ga3555a418df92ad53f917597fe2f64aeb
// 	window := glfw.CreateWindow(512, 512, PROGRAMNAME, nil, nil)
// 	// https://www.glfw.org/docs/latest/group__window.html#gacdf43e51376051d2c091662e9fe3d7b2
// 	defer glfw.DestroyWindow(window)

// 	// If the window pointer is invalid
// 	if window == nil {
// 		fmt.println("Unable to create window")
// 		return
// 	}

//     // https://www.glfw.org/docs/3.3/group__context.html#ga1c04dc242268f827290fe40aa1c91157
// 	glfw.MakeContextCurrent(window)
	
// 	// Enable vsync
// 	// https://www.glfw.org/docs/3.3/group__context.html#ga6d4e0cdf151b5e579bd67f13202994ed
// 	glfw.SwapInterval(1)

// 	// This function sets the key callback of the specified window, which is called when a key is pressed, repeated or released.
// 	// https://www.glfw.org/docs/3.3/group__input.html#ga1caf18159767e761185e49a3be019f8d
// 	glfw.SetKeyCallback(window, key_callback)

// 	// This function sets the framebuffer resize callback of the specified window, which is called when the framebuffer of the specified window is resized.
// 	// https://www.glfw.org/docs/3.3/group__window.html#gab3fb7c3366577daef18c0023e2a8591f
// 	glfw.SetFramebufferSizeCallback(window, size_callback)

// 	// Set OpenGL Context bindings using the helper function
// 	// See Odin Vendor source for specifc implementation details
// 	// https://github.com/odin-lang/Odin/tree/master/vendor/OpenGL
// 	// https://www.glfw.org/docs/3.3/group__context.html#ga35f1837e6f666781842483937612f163

// 	// casting the c.int to int
// 	// This is needed because the GL_MAJOR_VERSION has an explicit type of c.int
// 	gl.load_up_to(GL_MAJOR_VERSION, GL_MINOR_VERSION, glfw.gl_set_proc_address) 
	
// 	init()
	
// 	// There is only one kind of loop in Odin called for
// 	// https://odin-lang.org/docs/overview/#for-statement
// 	for (!glfw.WindowShouldClose(window) && running) {
// 		// Process waiting events in queue
// 		// https://www.glfw.org/docs/3.3/group__window.html#ga37bd57223967b4211d60ca1a0bf3c832
// 		glfw.PollEvents()
		
// 		update()
// 		draw()

// 		// This function swaps the front and back buffers of the specified window.
// 		// See https://en.wikipedia.org/wiki/Multiple_buffering to learn more about Multiple buffering
// 		// https://www.glfw.org/docs/3.0/group__context.html#ga15a5a1ee5b3c2ca6b15ca209a12efd14
// 		glfw.SwapBuffers((window))
// 	}

// 	exit()
// }

init :: proc(){
	// Vertex Shader
	// vertexShader = gl.CreateShader(gl.VERTEX_SHADER)

	// vertexShaderSrc := getShaderSource(VERTEX_SHADER_PATH)
	// vertexSrc : [^]cstring = &vertexShaderSrc
	// gl.ShaderSource(vertexShader, 1, vertexSrc, nil)

	// compileShader(vertexShader)

	// // Fragment Shader
	// fragmentShader = gl.CreateShader(gl.FRAGMENT_SHADER)

	// fragmentShaderSrc := getShaderSource(FRAGMENT_SHADER_PATH)
	// fragmentSrc : [^]cstring = &fragmentShaderSrc
	// gl.ShaderSource(fragmentShader, 1, fragmentSrc, nil)

	// compileShader(fragmentShader)

	// Shader program
	// shaderProgram = gl.CreateProgram()
	// gl.AttachShader(shaderProgram, vertexShader)
	// gl.AttachShader(shaderProgram, fragmentShader)
	// linkProgram(shaderProgram)

	// gl.UseProgram(shaderProgram)

	// gl.DeleteShader(vertexShader)
	// gl.DeleteShader(fragmentShader)

	// gl.GenVertexArrays(1, &vao)
	// gl.GenBuffers(1, &vbo)
	// gl.GenBuffers(1, &ebo)

	// gl.BindVertexArray(vao)

	// gl.BindBuffer(gl.ARRAY_BUFFER, vbo)
	// gl.BufferData(gl.ARRAY_BUFFER, len(vertices) * size_of(vertices), &vertices[0], gl.STATIC_DRAW)

	gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, ebo)
	gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, len(indices) * size_of(indices), &indices[0], gl.STATIC_DRAW)

	gl.VertexAttribPointer(0, 3, gl.FLOAT, gl.FALSE, 3 * size_of(f32), 0)
	gl.EnableVertexAttribArray(0)

	gl.BindBuffer(gl.ARRAY_BUFFER, 0)
	gl.BindVertexArray(0)

	// Polygon Mode (Wireframe)
	// gl.PolygonMode(gl.FRONT_AND_BACK, gl.LINE)
}

// update :: proc(){
// 	// Own update code here
// }

// draw :: proc(){
// 	// Set the opengl clear color
// 	// 0-1 rgba values

// 	// Own drawing code here
	
// 	gl.UseProgram(shaderProgram)

// 	gl.BindVertexArray(vao)
// 	gl.DrawElements(gl.TRIANGLES, 6, gl.UNSIGNED_INT, nil)

// 	// gl.BindVertexArray(0)
// }

// exit :: proc(){
// 	// Own termination code here
// }

// Called when glfw keystate changes
key_callback :: proc "c" (window: glfw.WindowHandle, key, scancode, action, mods: i32) {
	// Exit program on escape pressed
	if key == glfw.KEY_ESCAPE {
		running = false
	}
}

// Called when glfw window changes size
size_callback :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	// Set the OpenGL viewport size
	gl.Viewport(0, 0, width, height)
}
