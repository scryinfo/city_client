-----

TargetHeadCtrl = {};
local this = TargetHeadCtrl;

local TargetHead;
local transform;
local gameObject;

--Build Function--
function TargetHeadCtrl.New()
	logWarn("TargetHeadCtrl.New--->>");
	return this;
end

function TargetHeadCtrl.Awake()
	logWarn("TargetHeadCtrl.Awake--->>");
	panelMgr:LoadPrefab_A('TargetHead', nil,this,this.OnCreate);

end

--Startup event--
function TargetHeadCtrl.OnCreate(prefab)
	gameObject = ct.InstantiatePrefab(prefab);
	gameObject.transform.position = Vector3.New(87.5, 337, 0);
	TargetHead = gameObject:GetComponent('LuaBehaviour');

	this.Deactivate();

	logWarn("Start lua--->>"..gameObject.name);
end

function  TargetHeadCtrl.SetHPMax(v)
	if v then
	    TargetHeadPanel.sliderHp.maxValue = v;
	end
end

function  TargetHeadCtrl.SetHP(v)
	if v then
    	TargetHeadPanel.sliderHp.value = v;
    end
end

function  TargetHeadCtrl.SetName(v)
    TargetHeadPanel.textTargetName.text = v;
end

function  TargetHeadCtrl.Deactivate()
    gameObject:SetActive(false);
end

function  TargetHeadCtrl.Activate()
    gameObject:SetActive(true);
end

function TargetHeadCtrl.UpdateTargetUI()
    this.Activate();
    this.SetHPMax(this.target.HP_Max);
    this.SetHP(this.target.HP);
    this.SetName(this.target.name);
end

--Close event--
function TargetHeadCtrl.Close()
	destroy(gameObject);
end