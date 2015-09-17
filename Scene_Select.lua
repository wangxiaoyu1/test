--
-- Author: dagongju
-- Date: 2015-09-10 21:11:40
--
local Scene_Select=class("Scene_Select",function()
	return display.newScene("Scene_Select")
	end)

Chapter_Select=require("app.Scenes.Chapter_Select")
function Scene_Select:ctor()
	--keypad
	self:setKeypadEnabled(true)
	self:setSwallowTouches(true)
	self:addNodeEventListener(KEYPAD_EVENT,function(event)
		if event.key=="back" then
			if TouchTime==1 then
				self.message=MessageBox.new()
				self:message:setPosition(cc.p(0,0))
				self:addChild(self.message, 3)
				TouchisTime=2
				elseif TouchisTime=2 then
					if self.message then
					self.message:removeFromParent()
				end
				TouchisTime=1
			end
				
			end
		end)

	--音乐
	if JuqingMusic==true then
		JuqingMusic=false
		audio.stopMusic()
		audio.playMusic("backmusic.mp3",true)
	end

	--返回按钮
	local backBtn=cc.ui.UIPageView.new({normal="back.png"},{scale9=true})
	backBtn:onButtonClicked(function()
		display.replaceScene(require("app.Scenes.BeginScene").new())
		end)
	backBtn:setPosition(cc.p(50,display.top-50))
	backBtn:setScale(0.15)
	self:addChild(backBtn,1)


	if #PublicData.SCENETABLE==0 then
		local docpath = cc.FileUtils:getInstance():getWritablePath().."data.txt"
		if cc.FileUtils:getInstance():isFileExist(docpath)==false then
			local str = json.encode(Data.SCENE)
			ModifyData.writeToDoc(str)
			PublicData.SCENETABLE = Data.SCENE
		else
			local str = ModifyData.readFromDoc()
			PublicData.SCENETABLE = json.decode(str)
		end
	end























