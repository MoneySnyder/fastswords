--[[
    FastSwordClient.lua
    eliphant
    Created on 10/13/2023 @ 20:04
    
    Description:
        No description provided.
    
    Documentation:
        No documentation provided.
--]]

--= Root =--
local FastSwordClient = {}

--= Roblox Services =--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--= Dependencies =--
local GetRemote = shared("GetRemote")
local Maid = shared("Maid")

--= Object References =--
local LocalPlayer: Player = Players.LocalPlayer
local Character: Model? = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Backpack: Backpack? = LocalPlayer.Backpack or LocalPlayer.CharacterAdded:Wait():WaitForChild("Backpack")
local Sword: Tool?

--= Constants =--
local TOOL_NAME = "FastSword"

--= Variables =--

--= Internal Functions =--
function FastSwordClient:_getSword(): Tool
	task.wait()

	if not Character then
		self:_getSword()
	end

	if Backpack:FindFirstChild(TOOL_NAME) then
		return LocalPlayer.Backpack[TOOL_NAME]
	end

	if Character:FindFirstChild(TOOL_NAME) then
		return Character[TOOL_NAME]
	end

	self:_getSword()
end

function FastSwordClient:_listenToSpawn()
	local maid = Maid.new()

	maid:GiveTask(LocalPlayer.CharacterAdded:Connect(function(character: Model)
		Character = character
		Sword = self:_getSword()
	end))

	maid:GiveTask(LocalPlayer.CharacterRemoving:Connect(function()
		Character = nil
		Sword = nil
	end))
end

--= API Functions =--

--= Initializers =--
function FastSwordClient:Init()
	self:_listenToSpawn()
end

--= Return Module =--
return FastSwordClient
