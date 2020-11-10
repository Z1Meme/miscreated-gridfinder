ChatCommands["!grid"] = function(playerId, command)
	Log(">> !grid ");
		-- Locate players position
		local player = System.GetEntity(playerId)
		local pos = player:GetWorldPos()

		local gridSize=1024;--for use in expanding mod for other maps
		local mapSize={length=8, height=8};--for use in expanding mod for other maps
		local letters={"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
		--convert xy coordinate to grid location
		local gridLetter=nil;
		local gridNumber=nil;
		local y;
		local x;
		function sendMsg(stuff)
			g_gameRules.game:SendTextMessage(4, playerId, string.format(stuff));
		end
	    function setGridNumber(number, num)
	    	gridNumber = number
			if pos.x>=(num-gridSize)+(gridSize/3)*2 then x="right"
			elseif pos.x<=(num-gridSize)+(gridSize/3) then x="left"
			else x="middle" end
	    end
	    function setGridLetter(letter, num)
	    	gridLetter = letter
			if pos.y>=(num-gridSize)+(gridSize/3)*2 then y="upper"
			elseif pos.y<=(num-gridSize)+(gridSize/3) then y="lower"
			else y="middle" end
	   	end
		function getCoords()
			--Y coordinates
			for i=1, mapSize.height do
				if pos.y>=gridSize*(i-1) and pos.y<gridSize*i then setGridLetter(letters[i], gridSize*i) end
			end
			--X coordinates
			for i=1, mapSize.length do
				if pos.x>=gridSize*(i-1) and pos.x<gridSize*i then setGridNumber(string.format(i), gridSize*i) end
			end
		end
		--output to user
		function printGrid()
			if not gridLetter then sendMsg("Error: Y-coordinate out of bounds")
			elseif not gridNumber then sendMsg("Error: X-coordinate out of bounds")
			elseif (y=="upper" and x=="left") or (y=="upper" and x=="right") or (y=="lower" and x=="left") or (y=="lower" and x=="right")then
				sendMsg("You're at the "..y.." "..x.."-hand corner of grid: "..gridLetter..gridNumber);
			elseif (y=="middle" and x=="left") or (y=="middle" and x=="right") then
				sendMsg("You're at the center "..x.."-hand side of grid: "..gridLetter..gridNumber);
		  	elseif (y=="middle") and (x=="middle") then
		  		sendMsg("You're at the center of grid: "..gridLetter..gridNumber);
			elseif (y=="upper" and x=="middle") or (y=="lower" and x=="middle") then
		  		sendMsg("You're at the "..y.." "..x.." of grid: "..gridLetter..gridNumber);
			end
				
		end
		getCoords();
		printGrid();
end