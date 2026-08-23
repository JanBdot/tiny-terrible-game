package main

import "core:fmt"

import gl "vendor:OpenGL"

import "vendor:glfw"

initGlfw :: proc() -> bool {
	glfw.WindowHint(glfw.RESIZABLE, 1)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR,GL_MAJOR_VERSION) 
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR,GL_MINOR_VERSION)
	glfw.WindowHint(glfw.OPENGL_PROFILE,glfw.OPENGL_CORE_PROFILE)

	if(glfw.Init() != true){
		fmt.println("Failed to initialize GLFW")
		return false
	}

    return true
}

createWindow :: proc(programName: cstring) -> (glfw.WindowHandle, bool) {
	window := glfw.CreateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, programName, nil, nil)
    if window == nil {
        fmt.println("Unable to create window")
        return nil, false
    }

    glfw.MakeContextCurrent(window)
    glfw.SwapInterval(1)
    
    // TODO keyCallback should probably be handled elsewhere
    glfw.SetKeyCallback(window, keyCallback)
    // TODO gl dependency in SetFramebufferSizeCallback should be handled elsewhere
    glfw.SetFramebufferSizeCallback(window, sizeCallback)
    
    return window, true
}

// Called when glfw keystate changes
keyCallback :: proc "c" (window: glfw.WindowHandle, key, scancode, action, mods: i32) {
	// Exit program on escape pressed
	if key == glfw.KEY_ESCAPE {
		running = false
	}
}

// Called when glfw window changes size
sizeCallback :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	// Set the OpenGL viewport size
	gl.Viewport(0, 0, width, height)
}