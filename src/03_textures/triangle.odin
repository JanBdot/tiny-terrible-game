package main

// odinfmt: disable
triangleVertices := []f32{
    // positions        colors
    0.0, 0.5, 0.0,      1.0, 0.0, 0.0,  // top 
    0.5, -0.5, 0.0,     0.0, 1.0, 0.0,  // bottom right
    -0.5, -0.5, 0.0,    0.0, 0.0, 1.0,  // bottom left
}
// odinfmt: enable

getTriangleVerticesPtr :: proc() -> rawptr {
	return &triangleVertices[0]
}

getBufferSize :: proc() -> int {
	return len(triangleVertices) * size_of(triangleVertices)
}
