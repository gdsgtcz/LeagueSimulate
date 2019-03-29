--[[
/*
 * @Author: guodi 
 * @Date: 2017-09-08 11:59:38 
 * @Description: 模拟联赛数据
 * @Last Modified by: guodi
 * @Last Modified time: 2017-09-08 16:13:54
 */
]]--

--[[
-- 规则:
-- 初始都是最低段位
-- 没个段位按人数分为N组,每组最大人数一致
-- 每轮每个段位每组前x名晋段,后y名掉段 (x, y 可配置)
-- 最高或最低段位不再升降
]]

--[[
	数据结构
	userList = {
		"Divine" = num,
		"Diamond" = num,
		"Platinum" = num,
		"Gold" = num,
		"Sliver" = num,
		"Bronze" = num,
	}
]]

local userList = {
	["Divine"] = 0,
	["Diamond"] = 0,
	["Platinum"] = 0,
	["Gold"] = 0,
	["Sliver"] = 0,
	["Bronze"] = 0,
}


-- 分配
function sortOneGrop(num, groupLen, upLimit, downLimit)
	local up, down = 0, 0
	if num <= groupLen then
		return up, down
	end
	while num > groupLen do
		up = up + upLimit
		down = down + downLimit
		num = num - groupLen
	end
	return up, down
end

-- 计算一轮
function calculateOne(groupLen, upLimit, downLimit)
	local change1 = 0
	local change2 = 0
	local change3 = 0
	local change4 = 0
	local change5 = 0
	local change6 = 0
	-- 检测
	for k,v in pairs(userList) do
		if k == "Divine" then
			local upLimit = 0
			local downLimit = 55
			local up, down = sortOneGrop(v, groupLen, upLimit, downLimit)
			change1 = change1 - down
			change2 = change2 + down
		elseif k == "Diamond" then
			local upLimit = 20
			local downLimit = 50
			local up, down = sortOneGrop(v, groupLen, upLimit, downLimit)
			change1 = change1 + up
			change2 = change2 - up - down
			change3 = change3 + down
		elseif k == "Platinum" then
			local upLimit = 20
			local downLimit = 45
			local up, down = sortOneGrop(v, groupLen, upLimit, downLimit)
			change2 = change2 + up
			change3 = change3 - up - down
			change4 = change4 + down
		elseif k == "Gold" then
			local upLimit = 30
			local downLimit = 40
			local up, down = sortOneGrop(v, groupLen, upLimit, downLimit)
			change3 = change3 + up
			change4 = change4 - up - down
			change5 = change5 + down
		elseif k == "Sliver" then
			local upLimit = 30
			local downLimit = 30
			local up, down = sortOneGrop(v, groupLen, upLimit, downLimit)
			change4 = change4 + up
			change5 = change5 - up - down
			change6 = change6 + down
		elseif k == "Bronze" then
			local upLimit = 35
			local downLimit = 0
			local up, down = sortOneGrop(v, groupLen, upLimit, downLimit)
			change5 = change5 + up
			change6 = change6 - up
		else
			print("err: wrong lv:"..k)            
		end
	end

	userList.Divine = userList.Divine + change1
	userList.Diamond = userList.Diamond + change2
	userList.Platinum = userList.Platinum + change3
	userList.Gold = userList.Gold + change4
	userList.Sliver = userList.Sliver + change5
	userList.Bronze = userList.Bronze + change6
end

-- 计算所有轮
function calculateAll(oriCounts, addCounts, rounds, groupLen)
	-- check
	if oriCounts < 0 or addCounts < 0 or rounds <= 0 or groupLen <= 0 or groupLen > oriCounts then
		print("Data Error!")
	end
	-- 初始数据进青铜
	userList.Bronze = oriCounts
	for i=1, rounds do
		print("第"..i.."轮计算前..")
		print("神圣: ",userList.Divine)
		print("钻石: ",userList.Diamond)
		print("白金: ",userList.Platinum)
		print("黄金: ",userList.Gold)
		print("白银: ",userList.Sliver)
		print("青铜: ",userList.Bronze)
		local all1 = 0
		for k,v in pairs(userList) do
			all1 = all1 + v
		end
		print("参赛总数:"..all1)
		calculateOne(groupLen)
		print("\n第"..i.."轮计算后..")
		print("神圣: ",userList.Divine)
		print("钻石: ",userList.Diamond)
		print("白金: ",userList.Platinum)
		print("黄金: ",userList.Gold)
		print("白银: ",userList.Sliver)
		print("青铜: ",userList.Bronze)
		local all2 = 0
		for k,v in pairs(userList) do
			all2 = all2 + v
		end
		print("参赛总数:"..all2)
		print("\n==================================\n")
		-- 添加新人进青铜
		userList.Bronze = userList.Bronze + addCounts
	end
end

--[[
	参数:
	oriCounts : 初始总数
	addCounts : 每赛季增加人数
	rounds : 赛季轮数
	groupLen : 每组长度
	upLimit : 每组上升人数
	downLimit : 每组下降人数
]]
function main()
	local oriCounts = 0
	local addCounts = 0
	local rounds = 0
	local groupLen = 0
	local upLimit = 0
	local downLimit = 0
	--	enter
	print ("请输入初始玩家数目:")
	oriCounts = io.read("*num")
	print ("请输入每轮玩家增长数目:")
	addCounts = io.read("*num")
	print ("请输入模拟轮数:")
	rounds = io.read("*num")
	print ("请输入每组人数:")
	groupLen = io.read("*num")
	-- print ("请输入每组前多少名升段：")
	-- upLimit = io.read("*num")
	-- print ("请输入每组后多少名降段：")
	-- downLimit = io.read("*num")
	calculateAll(oriCounts, addCounts, rounds, groupLen)
end

-- test
main()