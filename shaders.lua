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

	local pixelcode = [[
	// adapted from http://www.youtube.com/watch?v=qNM0k522R7o
	 
	extern vec2 size = vec2(8,8);
	extern int samples = 10; // pixels per axis; higher = bigger glow, worse performance
	extern float quality = 4; // lower = smaller glow, better quality
	 
	vec4 effect(vec4 colour, Image tex, vec2 tc, vec2 sc)
	{
	  vec4 source = Texel(tex, tc);
	  vec4 sum = vec4(0);
	  int diff = (samples - 1) / 2;
	  vec2 sizeFactor = vec2(1) / size * quality;
	  
	  for (int x = -diff; x <= diff; x++)
	  {
	    for (int y = -diff; y <= diff; y++)
	    {
	      vec2 offset = vec2(x, y) * sizeFactor;
	      sum += Texel(tex, tc + offset);
	    }
	  }
	  
	  return ((sum / (samples * samples)) + source) * colour;
	}
	]]

	local vertexcode = [[
		vec4 position( mat4 transform_projection, vec4 vertex_position )
		{
			return transform_projection * vertex_position;
		}
	]]

	shaders.bloom = love.graphics.newShader(pixelcode,vertexcode)

	local pixelcode = [[
	vec4 effect(vec4 colour, Image tex, vec2 tc, vec2 sc)
	{
	  vec4 texcolor = texture2D(tex, tc);

	  // neighbour colours
	  vec4 n1 = texture2D(tex, vec2(sc[0]-1, sc[1]));
	  vec4 n2 = texture2D(tex, vec2(sc[0]+1, sc[1]));
	  if ( abs(n1[0]-n2[0]) > 64 || abs(n1[1]-n2[1]) > 64 || abs(n1[2]-n2[2]) > 64 )
	  {
	  	texcolor[0] = 1.0;
	  	texcolor[1] = 0.0;
	  	texcolor[2] = 0.0;
	  }
	  n1 = texture2D(tex, vec2(sc[0], sc[1]-1));
	  n2 = texture2D(tex, vec2(sc[0], sc[1]+1));
	  if ( abs(n1[0]-n2[0]) > 64 || abs(n1[1]-n2[1]) > 64 || abs(n1[2]-n2[2]) > 64 )
	  {
	  	texcolor[0] = 0.0;
	  	texcolor[1] = 0.0;
	  	texcolor[2] = 0.0;
	  }
	  n1 = texture2D(tex, vec2(sc[0]-1, sc[1]-1));
	  n2 = texture2D(tex, vec2(sc[0]+1, sc[1]+1));
	  if ( abs(n1[0]-n2[0]) > 64 || abs(n1[1]-n2[1]) > 64 || abs(n1[2]-n2[2]) > 64 )
	  {
	  	texcolor[0] = 0.0;
	  	texcolor[1] = 0.0;
	  	texcolor[2] = 0.0;
	  }
	  n1 = texture2D(tex, vec2(sc[0]+1, sc[1]-1));
	  n2 = texture2D(tex, vec2(sc[0]-1, sc[1]+1));
	  if ( abs(n1[0]-n2[0]) > 64 || abs(n1[1]-n2[1]) > 64 || abs(n1[2]-n2[2]) > 64 )
	  {
	  	texcolor[0] = 0.0;
	  	texcolor[1] = 0.0;
	  	texcolor[2] = 0.0;
	  }
	  
	  return texcolor*colour;
	}
	]]

	local vertexcode = [[
		vec4 position( mat4 transform_projection, vec4 vertex_position )
		{
			return transform_projection * vertex_position;
		}
	]]

	shaders.line = love.graphics.newShader(pixelcode,vertexcode)