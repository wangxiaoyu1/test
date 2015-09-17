--
-- Author: dagongju
-- Date: 2015-09-10 16:21:34
--
local GuideScene=class("GuideScene", function()
	return display.newScene("GuideScene")
end)

Scene_Select=require("app.Scene.Scene_Select")

function GuideScene:ctor()
	--创建本地文件
	if #PublicData.SCRENETABLE==0 then
		local docpath=cc.FileUtils:getInstance():getWritablePath().."data.txt"
		if cc.FileUtils:getInstance():isFileExist(docpath)==false then
			local str=json.encode(Data.SCENE)
			ModifyData.writeToDoc(str)
			PublicData.SCRENETABLE=Data.SCENE
		else
			local str=ModifyData.readFromDoc()
			PublicData.scenetable=json.decode(str)
		end
	end

	JuqingMusic=false

	--如果第一场景没有解锁，播放剧情并解锁
	if PublicData.SCENETABLE[1][13].lock==1 then
		audio.playMusic("zone1.mp3",false)
		JuqingMusic=true
		self:juqing()
		PublicData.SCENETABLE[1][13].lock==0
		local str=json.encode(PublicData.SCENETABLE)
		ModifyData.writeToDoc(str)
	else
		self:init()
	end
end

TouchisTime=1
function GuideScene:init()
	--keyboard
	self:setKeypadEnabled(true)
	self:addNodeEventListener(KEYPAD_EVENT, function(event)
		if event.key=="back" then
			if TouchisTime==1 then
				cc.Director:getInstance():pause()
				self.message=MessageBox.new()
				self.message:setPosition(cc.p(0,0))
				self:addChild(self.message, 3)
				TouchisTime
			end
		end)

	--背景
	local bg=display.newSprite("backbg.png")
	local scaleX=display.width/bg:getContentSize().width
	local scaleY=display.height/bg:getContentSize().height

	--屏幕适配
	bg:setScaleX(scaleX)
	bg:setScaleY(scaleY)
	bg:setPosition(display.cx,display.cy)
	self:addChild(bg)

	--进度条
	local timer=cc.ProgressTimer:create(cc.Sprite:create("jindu.png"))
	timer:setPosition(display.cx,display.cy)
	timer:setBarChangeRate(cc.p(1,0))--设置进度条变化速度，只在x轴变化
	timer:setType(display.PROGRESS_TIMER_BAR)
	timer:setMidpoint(cc.p(0,0.5))--设置起点
	timer:setPercentage(0)
	timer:addTo(self)

	local progress=cc.ProgressTo:create(2,100)
	local call=cc.CallFunc:create(function()
		--切换场景
		cc.Director:getInstance():replaceScene(require("app.Scenes.BeginScene").new())
		local scene=BeginScene.new()
		local turn=cc.TransitionPageTurn:create(1,scene,false)
		cc.Director:getInstance():replaceScene(turn)
		end)

	local seq=cc.Sequence:create(progress,call)
	timer:runAction(seq)

	--loading
	local lab=cc.ui.UILabel.new({text="loading...",size=25,color=cc.cc.c3b(255, 0, 0)})
	lab:setPosition(cc.p(display.cx-50,display.cy+40))
	lab:addTo(self)
end


function GuideScene:juqing()
	local png="juqingAction.png"
	local plist="juqingAction.plist"
	display.addSpriteFrames(plist,png)
	self._juqing=display.newSprite("#1_81.png")
	self._juqing:pos(display.cx, display.cy)
	local width=display.width/self._juqing:getContentSize().width
	local height=display.height/self._juqing:getContentSize().height
	self._juqing:setScaleX(width)
	self._juqing:setScaleY(height)
	local frames=display.newFrames("1_%d.png",81,14)
	local animation=display.newAnimation(frames,0.1)
	local animate=cc.Animate:create(animation)
	local jp=cc.CallFunc:create(function()
		self._juqing:removeSelf()
		local node=cc.uiloader:load("juqing.csb")
		print(node:getContentSize().width)
		local width=display.width/node:getContentSize().width
  		local height=display.height/node:getContentSize().height
  		node:setScaleX(width)
  		node:setScaleY(height)
  		node:addTo(self)
  		node:pos(0, 0)


  		for i=1,10 do
			print(i)
			local pageView=node:getChildByName("PageView_1")
			local panel=pageView:getChildByName("Panel_"..i)
			local TiaoguoBtn=panel:getChildByName("Button_"..i)
			TiaoguoBtn:addTouchEventListener(
			function (ref,type)
				if type==ccui.TouchEventType.ended then
					cc.Director:getInstance():replaceScene(Scene_Select.new())
				end
			end)
		end
		
	end)
	local seq=cc.Sequence:create(animate,jq)
	self._Juqing:runAction(seq)
	self:addChild(self._Juqing,1)
		)
end
return GuideScene


































































end