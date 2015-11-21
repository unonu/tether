do
	for i, v in ipairs(love.filesystem.getDirectoryItems("states/")) do
		require('states/'..v:sub(1,-5))
		print("Loaded state "..v:sub(1,-5))
	end
end