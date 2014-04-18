shaders = {}

	local pixelcode = [[
		vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
		{
			vec4 texcolor = Texel(texture, texture_coords);
			vec4 test = Texel(texture, texture_coords);

			if (test[0] <= .05 && test[1] <= .05 && test[2] <= .05)
				texcolor = vec4(255,255,255,test[3]);
			else
				texcolor = vec4(0,0,0,test[3]);
            return texcolor;
		}
	]]

	local vertexcode = [[
		vec4 position( mat4 transform_projection, vec4 vertex_position )
		{
			return transform_projection * vertex_position;
		}
	]]

	shaders.monochrome = love.graphics.newShader(pixelcode, vertexcode)

	--tilt