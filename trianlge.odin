package main

getTriangleVertices :: proc() -> []f32 {
    // odinfmt: disable
    vertices := []f32{
        0.5, 0.5, 0.0, // top right
        0.5, -0.5, 0.0, // bottom right
        -0.5, -0.5, 0.0, // bottom left
    }
    // odinfmt: enable

	return vertices
}

getTriangleVerticesPtr :: proc() -> rawptr {
	return &getTriangleVertices()[0]
}

getBufferSize :: proc() -> int {
	vertices := getTriangleVertices()
	return len(vertices) * size_of(vertices)
}
