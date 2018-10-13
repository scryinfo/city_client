require "Common/define"
require "City"

MaterialModel = {};
local this = MaterialModel;

--构建函数
function MaterialModel.New()
    return this;
end

function MaterialModel.Awake()
    --UpdateBeat:Add(this.Update, this);
    --this:OnCreate();
end

--function MaterialModel.Update()
--    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.T) then
--        --MaterialCtrl.OpenPanel({});
--        UIPage:ShowPage(MaterialCtrl);
--    end
--end


function MaterialModel:OnCreate(go)

end




