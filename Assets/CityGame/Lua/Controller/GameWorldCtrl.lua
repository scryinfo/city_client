-----

GameWorldCtrl = {};
local this = GameWorldCtrl;

local GameWorld;
local transform;
local gameObject;
local log = log
--Constructor--
function GameWorldCtrl.New()
	logWarn("GameWorldCtrl.New--->>");
	return this;
end

function GameWorldCtrl.Awake()
	logWarn("GameWorldCtrl.Awake--->>");
	panelMgr:LoadPrefab_A('GameWorld', nil,this, this.OnCreate);
end

--Start event--
function GameWorldCtrl.OnCreate(prefab)
	gameObject = ct.InstantiatePrefab(prefab);

	GameWorld = gameObject:GetComponent('LuaBehaviour');
	--GameWorld:AddClick(GameWorldPanel.btnGameWorld, this.OnGameWorld);
	GameWorld:AddClick(GameWorldPanel.btnRelive, this.OnRelive);
	GameWorld:AddClick(GameWorldPanel.btnClose, this.OnClose);
	GameWorld:AddClick(GameWorldPanel.btnSend, this.OnSendMessage);
	GameWorld:AddClick(GameWorldPanel.btnResetView, this.OnResetView);
	GameWorld:AddClick(GameWorldPanel.btnSkill1, this.OnAttackSkill1);
	GameWorld:AddClick(GameWorldPanel.btnSkill2, this.OnAttackSkill2);
	GameWorld:AddClick(GameWorldPanel.btnSkill3, this.OnAttackSkill3);
	GameWorld:AddClick(GameWorldPanel.btnTabTarget, this.OnTabTarget);

	logWarn("Start lua--->>"..gameObject.name);

	Event.AddListener("OnDie", this.OnDie);
	Event.AddListener("ReceiveChatMessage", this.ReceiveChatMessage);

	--Do some initialization
	local p = CityEngineLua.player();
	if p ~= nil then
		this.OnDie(p.state);
	end
	this.SetSkillButton();
end

--Switch selection
function GameWorldCtrl.OnTabTarget( )
    local player = CityEngineLua.player();
    if (player == nil) then
        return;
    end

    local target = TargetHeadCtrl.target;

    local mindis = 10000;
    local minEntity = nil;
    for i, entity in pairs(CityEngineLua.entities) do
    	local obj = entity.renderObj;
        if (obj ~= nil and obj.layer == LayerMask.NameToLayer("CanAttack") and entity.className == "Monster" and entity.HP > 0) then
            local dis = Vector3.Distance(player.position, obj.transform.position);
	        if (mindis > dis and (target == nil or target ~= nil and target ~= entity)) then
	            mindis = dis;
	            minEntity = entity;
	        end
        end
    end
    if minEntity ~= nil then
        TargetHeadCtrl.target = minEntity;
        TargetHeadCtrl.UpdateTargetUI();
    end
end

--resurrection--
function GameWorldCtrl.OnRelive(go)

	local p = CityEngineLua.player();
	if p ~= nil then
		p:relive(1);
	end
end

--Close game--
function GameWorldCtrl.OnClose(go)
	UnityEngine.Application.Quit();
end

--Send chat
function GameWorldCtrl.OnSendMessage(go)
	local p = CityEngineLua.player();
	if p ~= nil and string.len(GameWorldPanel.input_content.text) > 0 then
		Event.Brocast("sendChatMessage", p, GameWorldPanel.input_content.text);
	end
end

--Reset perspective
function GameWorldCtrl.OnResetView(go)
	CameraFollow.ResetView();
end

--Close event--
function GameWorldCtrl.Close()
	--panelMgr:ClosePanel(CtrlNames.Login);
	destroy(gameObject);
end

--Set Skill Button--
function GameWorldCtrl.SetSkillButton()
	if #SkillBox.skills == 3 then
		GameWorldPanel.btnSkill1.transform:Find("Text"):GetComponent("Text").text = SkillBox.skills[1].name;
		GameWorldPanel.btnSkill2.transform:Find("Text"):GetComponent("Text").text = SkillBox.skills[2].name;
		GameWorldPanel.btnSkill3.transform:Find("Text"):GetComponent("Text").text = SkillBox.skills[3].name;
	end
end

function GameWorldCtrl.AttackSkill(skillID )
	local player = CityEngineLua.player();
    
    if (player == nil) then
        return;
    end

    local target = TargetHeadCtrl.target;
    if (player ~= nil) then        
        local errorCode = player:useTargetSkill(skillID, target);
        if (errorCode == 1) then            
            ct.log("目标太远");
            --Approaching the target
            --SkillControl.MoveTo(target.renderObj.transform, SkillBox.Get(skillID).canUseDistMax-1, skillID);
        end
        if (errorCode == 2) then            
            ct.log("技能冷却");
        end
        if (errorCode == 3) then            
            ct.log("目标已死亡");
        end
    end
end

function GameWorldCtrl.OnAttackSkill1( )
	this.AttackSkill(SkillBox.skills[1].id);
end
function GameWorldCtrl.OnAttackSkill2( )
	this.AttackSkill(SkillBox.skills[2].id);
end
function GameWorldCtrl.OnAttackSkill3( )
	this.AttackSkill(SkillBox.skills[3].id);
end

------------event--
--death--
function GameWorldCtrl.OnDie(v)
	if GameWorldPanel.PanelDie == nil then return end
	if v == 1 then
		GameWorldPanel.PanelDie:SetActive(true);
	else
		GameWorldPanel.PanelDie:SetActive(false);
	end
end

--receive the info
function GameWorldCtrl.ReceiveChatMessage(msg)
	local text = GameWorldPanel.textContent:GetComponent("Text");

	if (string.len(text.text) > 0) then
        text.text = text.text .. "\n" .. msg;
    else
        text.text = text.text .. msg;
    end

    if (text.preferredHeight + 30 > 67) then
        GameWorldPanel.textContent:GetComponent("RectTransform").sizeDelta = Vector2.New(0, text.preferredHeight);
    end

    GameWorldPanel.sb_vertical.value = 0;
    GameWorldPanel.input_content.text = "";
end


