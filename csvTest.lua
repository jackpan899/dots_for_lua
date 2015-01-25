

function loadCsvFile(filePath)
	-- 读取文件
	local data = cc.FileUtils:getInstance():getStringFromFile(filePath);
	-- 按行划分
	local lineStr = split(data, '\n\r');
	--[[
				从第3行开始保存（第一行是标题，第二行是注释，后面的行才是内容）

				用二维数组保存：arr[ID][属性标题字符串]
	]]
	local titles = split(lineStr[1], ",");
	local ID = 1;
	local arrs = {};
	for i = 3, #lineStr, 1 do
		-- 一行中，每一列的内容
		local content = split(lineStr[i], ",");
		-- 以标题作为索引，保存每一列的内容，取值的时候这样取：arrs[1].Title
		arrs[ID] = {};
		for j = 1, #titles, 1 do
			arrs[ID][titles[j]] = content[j];
		end
		ID = ID + 1;
	end
	return arrs;
end


function split(str, reps)
	local resultStrsList = {};
	string.gsub(str, '[^' .. reps ..']+', function(w) table.insert(resultStrsList, w) end );
	return resultStrsList;
end

