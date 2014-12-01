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

--motion blur

--blur

	local pixelcode = [[
		vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
		{
			float size = .0025;
			vec4 texcolor = vec4(0.0);

            texcolor += (texture2D(texture, vec2(texture_coords[0]-4*size,texture_coords[1]))*.05);
			texcolor += (texture2D(texture, vec2(texture_coords[0]-3*size,texture_coords[1]))*.09);
			texcolor += (texture2D(texture, vec2(texture_coords[0]-2*size,texture_coords[1]))*.12);
			texcolor += (texture2D(texture, vec2(texture_coords[0]-1*size,texture_coords[1]))*.15);
			texcolor += (texture2D(texture, vec2(texture_coords[0],texture_coords[1]))*.16);
			texcolor += (texture2D(texture, vec2(texture_coords[0]+1*size,texture_coords[1]))*.15);
			texcolor += (texture2D(texture, vec2(texture_coords[0]+2*size,texture_coords[1]))*.12);
			texcolor += (texture2D(texture, vec2(texture_coords[0]+3*size,texture_coords[1]))*.09);
			texcolor += (texture2D(texture, vec2(texture_coords[0]+4*size,texture_coords[1]))*.05);
			return texcolor;
		}
	]]

	local vertexcode = [[
		vec4 position( mat4 transform_projection, vec4 vertex_position )
		{
			return transform_projection * vertex_position;
		}
	]]

	shaders.blurX = love.graphics.newShader(pixelcode, vertexcode)

	local pixelcode = [[
		vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
		{
			float size = .0025;
			vec4 texcolor = vec4(0.0);

            texcolor += (texture2D(texture, vec2(texture_coords[0],texture_coords[1]-4*size))*.05);
			texcolor += (texture2D(texture, vec2(texture_coords[0],texture_coords[1]-3*size))*.09);
			texcolor += (texture2D(texture, vec2(texture_coords[0],texture_coords[1]-2*size))*.12);
			texcolor += (texture2D(texture, vec2(texture_coords[0],texture_coords[1]-1*size))*.15);
			texcolor += (texture2D(texture, vec2(texture_coords[0],texture_coords[1]))*.16);
			texcolor += (texture2D(texture, vec2(texture_coords[0],texture_coords[1]+1*size))*.15);
			texcolor += (texture2D(texture, vec2(texture_coords[0],texture_coords[1]+2*size))*.12);
			texcolor += (texture2D(texture, vec2(texture_coords[0],texture_coords[1]+3*size))*.09);
			texcolor += (texture2D(texture, vec2(texture_coords[0],texture_coords[1]+4*size))*.05);
			return texcolor;
		}
	]]

	local vertexcode = [[
		vec4 position( mat4 transform_projection, vec4 vertex_position )
		{
			return transform_projection * vertex_position;
		}
	]]

	shaders.blurY = love.graphics.newShader(pixelcode, vertexcode)

	local pixelcode = [[
		extern vec2 direction;
		
		vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
		{
			float x_dir = direction[0]/2;
			float y_dir = direction[1]/2;
			vec4 texcolor = vec4(0.0);

            texcolor += (texture2D(texture, vec2(texture_coords[0]-4*x_dir,texture_coords[1]))*.1);
			texcolor += (texture2D(texture, vec2(texture_coords[0]-3*x_dir,texture_coords[1]))*.18);
			texcolor += (texture2D(texture, vec2(texture_coords[0]-2*x_dir,texture_coords[1]))*.24);
			texcolor += (texture2D(texture, vec2(texture_coords[0]-1*x_dir,texture_coords[1]))*.3);
			texcolor += (texture2D(texture, vec2(texture_coords[0],texture_coords[1]))*.08);
            texcolor += (texture2D(texture, vec2(texture_coords[0],texture_coords[1]-4*y_dir))*.1);
			texcolor += (texture2D(texture, vec2(texture_coords[0],texture_coords[1]-3*y_dir))*.18);
			texcolor += (texture2D(texture, vec2(texture_coords[0],texture_coords[1]-2*y_dir))*.24);
			texcolor += (texture2D(texture, vec2(texture_coords[0],texture_coords[1]-1*y_dir))*.3);
			texcolor += (texture2D(texture, vec2(texture_coords[0],texture_coords[1]))*.08);
			return texcolor/8;
		}
	]]

	local vertexcode = [[
		vec4 position( mat4 transform_projection, vec4 vertex_position )
		{
			return transform_projection * vertex_position;
		}
	]]

	shaders.motionBlur = love.graphics.newShader(pixelcode, vertexcode)

	local pixelcode = [[

		extern float focus;

		vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
		{
			vec4 red = texture2D(texture,vec2(texture_coords[0] + .0014*focus,texture_coords[1]));
			vec4 green = texture2D(texture,vec2(texture_coords[0] - .0014*focus,texture_coords[1] + .002*focus));
			vec4 blue = texture2D(texture,vec2(texture_coords[0] - .0014*focus,texture_coords[1] - .002*focus));
			vec4 full = texture2D(texture,vec2(texture_coords[0],texture_coords[1]));

            return vec4(red[0],green[1],blue[2],full[3]);
		}
	]]

	local vertexcode = [[
		vec4 position( mat4 transform_projection, vec4 vertex_position )
		{
			return transform_projection * vertex_position;
		}
	]]

	shaders.chromaticAberation = love.graphics.newShader(pixelcode, vertexcode)