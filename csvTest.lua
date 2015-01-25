

function loadCsvFile(filePath)
	-- ��ȡ�ļ�
	local data = cc.FileUtils:getInstance():getStringFromFile(filePath);
	-- ���л���
	local lineStr = split(data, '\n\r');
	--[[
				�ӵ�3�п�ʼ���棨��һ���Ǳ��⣬�ڶ�����ע�ͣ�������в������ݣ�

				�ö�ά���鱣�棺arr[ID][���Ա����ַ���]
	]]
	local titles = split(lineStr[1], ",");
	local ID = 1;
	local arrs = {};
	for i = 3, #lineStr, 1 do
		-- һ���У�ÿһ�е�����
		local content = split(lineStr[i], ",");
		-- �Ա�����Ϊ����������ÿһ�е����ݣ�ȡֵ��ʱ������ȡ��arrs[1].Title
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

