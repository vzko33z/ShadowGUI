local _GUI_ROOT
do
    local ok, root = pcall(function() return gethui() end)
    _GUI_ROOT = (ok and root) or game:GetService("CoreGui")
end

local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player       = Players.LocalPlayer
local Mouse        = Player:GetMouse()

local C = {
    bg        = Color3.fromRGB(18,18,22),
    panel     = Color3.fromRGB(24,24,30),
    panelDark = Color3.fromRGB(20,20,25),
    card      = Color3.fromRGB(30,30,38),
    cardHov   = Color3.fromRGB(38,38,48),
    surface   = Color3.fromRGB(32,32,40),
    surfaceHov= Color3.fromRGB(40,40,50),
    sidebar   = Color3.fromRGB(14,14,18),
    border    = Color3.fromRGB(40,40,50),
    primary   = Color3.fromRGB(139,92,246),
    accent    = Color3.fromRGB(167,139,250),
    text      = Color3.fromRGB(220,220,228),
    textDim   = Color3.fromRGB(130,125,155),
    textSub   = Color3.fromRGB(55,55,70),
}
local VIOLET     = Color3.fromRGB(139,92,246)
local VIOLET_DIM = Color3.fromRGB(100,75,175)
local GREY_DARK  = Color3.fromRGB(80,80,95)
local F_MC = Enum.Font.Fantasy

local I = {
    dashboard    = "rbxassetid://124620632231839",
    boost        = "rbxassetid://16149155528",
    visual       = "rbxassetid://6523858394",
    others       = "rbxassetid://123908228387675",
    unlock       = "rbxassetid://118917184418804",
    skins        = "rbxassetid://105955025341798",
    wraps        = "rbxassetid://129261498595427",
    charms       = "rbxassetid://110164536607343",
    finishers    = "rbxassetid://13321838559",
    emotes       = "rbxassetid://106660377005001",
    spoof        = "rbxassetid://11322093465",
    device_spoof = "rbxassetid://12684119225",
    profile      = "rbxassetid://13805569043",
    weapons      = "rbxassetid://4391741881",
    game_spoof   = "rbxassetid://4621599120",
    settings     = "rbxassetid://9405931578",
    search       = "rbxassetid://118685771787843",
    drag         = "rbxassetid://5172066892",
    resize       = "rbxassetid://115558082558028",
}
I.weapons_spoof = I.weapons

----------------------------------------------------
-- CURSEUR
----------------------------------------------------
local CURSOR_IMG         = "rbxassetid://10213989924"
local CURSOR_TRANSPARENT = "rbxassetid://6479477716"
local CURSOR_SIZE        = 20

local CursorGui = Instance.new("ScreenGui")
CursorGui.Name="ShadowCursorGui"; CursorGui.DisplayOrder=999
CursorGui.IgnoreGuiInset=true; CursorGui.ResetOnSpawn=false
CursorGui.Parent=_GUI_ROOT

local CursorImg = Instance.new("ImageLabel", CursorGui)
CursorImg.Size=UDim2.fromOffset(CURSOR_SIZE,CURSOR_SIZE)
CursorImg.BackgroundTransparency=1; CursorImg.Image=CURSOR_IMG
CursorImg.ScaleType=Enum.ScaleType.Fit; CursorImg.ZIndex=999; CursorImg.Visible=false

local cursorMoveConn=nil; local cursorLockConn1=nil; local cursorLockConn2=nil

local function applyTransparent()
    pcall(function() Mouse.Icon=CURSOR_TRANSPARENT end)
    pcall(function() UIS.MouseIcon=CURSOR_TRANSPARENT end)
end
local function startCursor()
    pcall(function() UIS.MouseIconEnabled=true end)
    applyTransparent()
    if cursorLockConn1 then cursorLockConn1:Disconnect() end
    if cursorLockConn2 then cursorLockConn2:Disconnect() end
    cursorLockConn1=Mouse:GetPropertyChangedSignal("Icon"):Connect(function()
        if Mouse.Icon~=CURSOR_TRANSPARENT then applyTransparent() end
    end)
    cursorLockConn2=UIS:GetPropertyChangedSignal("MouseIcon"):Connect(function()
        if UIS.MouseIcon~=CURSOR_TRANSPARENT then applyTransparent() end
    end)
    CursorImg.Position=UDim2.fromOffset(Mouse.X,Mouse.Y); CursorImg.Visible=true
    if cursorMoveConn then cursorMoveConn:Disconnect() end
    cursorMoveConn=UIS.InputChanged:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseMovement then
            CursorImg.Position=UDim2.fromOffset(input.Position.X,input.Position.Y)
        end
    end)
end
local function stopCursor()
    if cursorMoveConn  then cursorMoveConn:Disconnect();  cursorMoveConn=nil  end
    if cursorLockConn1 then cursorLockConn1:Disconnect(); cursorLockConn1=nil end
    if cursorLockConn2 then cursorLockConn2:Disconnect(); cursorLockConn2=nil end
    CursorImg.Visible=false
    pcall(function() Mouse.Icon="" end); pcall(function() UIS.MouseIcon="" end)
end

----------------------------------------------------
-- GUI ROOT
----------------------------------------------------
local ScreenGui=Instance.new("ScreenGui")
ScreenGui.Parent=_GUI_ROOT; ScreenGui.IgnoreGuiInset=true; ScreenGui.ResetOnSpawn=false

local MAIN_W=580; local MAIN_H=460; local SIDEBAR_W=185; local TOPBAR_H=40; local FOOTER_H=26

local Main=Instance.new("Frame",ScreenGui)
Main.Size=UDim2.fromOffset(MAIN_W,MAIN_H)
Main.Position=UDim2.new(.5,-MAIN_W/2,.5,-MAIN_H/2)
Main.BackgroundColor3=C.bg; Main.Active=true; Main.BorderSizePixel=0
Instance.new("UICorner",Main).CornerRadius=UDim.new(0,7)
Instance.new("UIStroke",Main).Color=C.border

Main:GetPropertyChangedSignal("Visible"):Connect(function()
    if Main.Visible then startCursor() else stopCursor() end
end)
task.defer(startCursor)

task.defer(startCursor)
if getgenv().ShadowSilentMode then
    task.defer(function() Main.Visible=false; stopCursor() end)
end

----------------------------------------------------
-- TOPBAR
----------------------------------------------------
local TopBar=Instance.new("Frame",Main)
TopBar.Size=UDim2.new(1,0,0,TOPBAR_H); TopBar.BackgroundColor3=C.sidebar; TopBar.BorderSizePixel=0
Instance.new("UICorner",TopBar).CornerRadius=UDim.new(0,7)
local tbp=Instance.new("Frame",TopBar)
tbp.Size=UDim2.new(1,0,0,10); tbp.Position=UDim2.new(0,0,1,-10)
tbp.BackgroundColor3=C.sidebar; tbp.BorderSizePixel=0

do
    local d=Instance.new("Frame",Main)
    d.Size=UDim2.new(1,0,0,1); d.Position=UDim2.fromOffset(0,TOPBAR_H)
    d.BackgroundColor3=C.border; d.BorderSizePixel=0
end

do
    local dr,dS,sP=false,nil,nil
    TopBar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dr=true; dS=i.Position; sP=Main.Position
            i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then dr=false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dr and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-dS
            Main.Position=UDim2.new(sP.X.Scale,sP.X.Offset+d.X,sP.Y.Scale,sP.Y.Offset+d.Y)
        end
    end)
end

local TitleLbl=Instance.new("TextLabel",TopBar)
TitleLbl.Size=UDim2.fromOffset(130,TOPBAR_H); TitleLbl.Position=UDim2.fromOffset(12,0)
TitleLbl.BackgroundTransparency=1; TitleLbl.Text="ShadowGUI"
TitleLbl.Font=F_MC; TitleLbl.TextSize=15; TitleLbl.TextColor3=C.text
TitleLbl.TextXAlignment=Enum.TextXAlignment.Left

local SrchBar=Instance.new("Frame",TopBar)
SrchBar.Size=UDim2.fromOffset(260,26); SrchBar.Position=UDim2.new(0.5,-130,0.5,-13)
SrchBar.BackgroundColor3=C.surface; SrchBar.BorderSizePixel=0
Instance.new("UICorner",SrchBar).CornerRadius=UDim.new(0,5)
Instance.new("UIStroke",SrchBar).Color=C.border

local SrchIco=Instance.new("ImageLabel",SrchBar)
SrchIco.Size=UDim2.fromOffset(18,18); SrchIco.Position=UDim2.new(0,7,0.5,-9)
SrchIco.BackgroundTransparency=1; SrchIco.Image=I.search
SrchIco.ImageColor3=GREY_DARK; SrchIco.ScaleType=Enum.ScaleType.Fit

local SearchBox=Instance.new("TextBox",SrchBar)
SearchBox.Size=UDim2.new(1,0,1,-4); SearchBox.Position=UDim2.fromOffset(0,2)
SearchBox.BackgroundTransparency=1; SearchBox.Text=""
SearchBox.PlaceholderText="Search..."; SearchBox.Font=F_MC
SearchBox.TextSize=12; SearchBox.TextColor3=C.text
SearchBox.PlaceholderColor3=C.textSub
SearchBox.TextXAlignment=Enum.TextXAlignment.Center; SearchBox.ClearTextOnFocus=false

local DragIco=Instance.new("ImageLabel",TopBar)
DragIco.Size=UDim2.fromOffset(18,18); DragIco.Position=UDim2.new(1,-26,0.5,-9)
DragIco.BackgroundTransparency=1; DragIco.Image=I.drag
DragIco.ImageColor3=GREY_DARK; DragIco.ScaleType=Enum.ScaleType.Fit

local OptionRegistry={}
local SuggestFrame=Instance.new("Frame",Main)
SuggestFrame.Size=UDim2.fromOffset(260,150)
SuggestFrame.Position=UDim2.new(0.5,-130,0,TOPBAR_H+4)
SuggestFrame.BackgroundColor3=Color3.fromRGB(20,20,26)
SuggestFrame.BorderSizePixel=0; SuggestFrame.Visible=false; SuggestFrame.ZIndex=60
SuggestFrame.ClipsDescendants=true
Instance.new("UICorner",SuggestFrame).CornerRadius=UDim.new(0,6)
Instance.new("UIStroke",SuggestFrame).Color=Color3.fromRGB(40,40,55)
local SuggestScroll=Instance.new("ScrollingFrame",SuggestFrame)
SuggestScroll.Size=UDim2.new(1,0,1,0); SuggestScroll.BackgroundTransparency=1
SuggestScroll.BorderSizePixel=0; SuggestScroll.ScrollBarThickness=2
SuggestScroll.ScrollBarImageColor3=Color3.fromRGB(139,92,246)
SuggestScroll.CanvasSize=UDim2.new(0,0,0,0); SuggestScroll.ZIndex=61
local SuggestLayout=Instance.new("UIListLayout",SuggestScroll)
SuggestLayout.SortOrder=Enum.SortOrder.LayoutOrder; SuggestLayout.Padding=UDim.new(0,0)
SuggestLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SuggestScroll.CanvasSize=UDim2.new(0,0,0,SuggestLayout.AbsoluteContentSize.Y)
    SuggestFrame.Size=UDim2.fromOffset(260,math.min(SuggestLayout.AbsoluteContentSize.Y+2,160))
end)

----------------------------------------------------
-- SIDEBAR
----------------------------------------------------
local Sidebar=Instance.new("Frame",Main)
Sidebar.Size=UDim2.new(0,SIDEBAR_W,1,-TOPBAR_H-1-FOOTER_H)
Sidebar.Position=UDim2.fromOffset(0,TOPBAR_H+1)
Sidebar.BackgroundColor3=C.sidebar; Sidebar.BorderSizePixel=0
Instance.new("UICorner",Sidebar).CornerRadius=UDim.new(0,7)
local sp1=Instance.new("Frame",Sidebar)
sp1.Size=UDim2.new(1,0,0,10); sp1.BackgroundColor3=C.sidebar; sp1.BorderSizePixel=0
local sp2=Instance.new("Frame",Sidebar)
sp2.Size=UDim2.new(0,10,1,0); sp2.Position=UDim2.new(1,-10,0,0)
sp2.BackgroundColor3=C.sidebar; sp2.BorderSizePixel=0

local SbVDiv=Instance.new("Frame",Main)
SbVDiv.Size=UDim2.new(0,2,1,-TOPBAR_H-1-FOOTER_H)
SbVDiv.Position=UDim2.fromOffset(SIDEBAR_W,TOPBAR_H+1)
SbVDiv.BackgroundColor3=C.border; SbVDiv.BorderSizePixel=0

local SbScroll=Instance.new("ScrollingFrame",Sidebar)
SbScroll.Size=UDim2.new(1,0,1,-6); SbScroll.Position=UDim2.fromOffset(0,4)
SbScroll.BackgroundTransparency=1; SbScroll.BorderSizePixel=0
SbScroll.ScrollBarThickness=2; SbScroll.ScrollBarImageColor3=C.primary
SbScroll.CanvasSize=UDim2.new(0,0,0,0)
local SbList=Instance.new("UIListLayout",SbScroll)
SbList.Padding=UDim.new(0,0); SbList.SortOrder=Enum.SortOrder.LayoutOrder

local ContentArea=Instance.new("Frame",Main)
ContentArea.Size=UDim2.new(1,-SIDEBAR_W-2,1,-TOPBAR_H-1-FOOTER_H)
ContentArea.Position=UDim2.fromOffset(SIDEBAR_W+2,TOPBAR_H+1)
ContentArea.BackgroundTransparency=1; ContentArea.BorderSizePixel=0

----------------------------------------------------
-- FOOTER
----------------------------------------------------
local Footer=Instance.new("Frame",Main)
Footer.Size=UDim2.new(1,0,0,FOOTER_H); Footer.Position=UDim2.new(0,0,1,-FOOTER_H)
Footer.BackgroundColor3=C.sidebar; Footer.BorderSizePixel=0
Instance.new("UICorner",Footer).CornerRadius=UDim.new(0,7)
local ftp=Instance.new("Frame",Footer)
ftp.Size=UDim2.new(1,0,0,10); ftp.BackgroundColor3=C.sidebar; ftp.BorderSizePixel=0
local FtDiv=Instance.new("Frame",Main)
FtDiv.Size=UDim2.new(1,0,0,1); FtDiv.Position=UDim2.new(0,0,1,-FOOTER_H)
FtDiv.BackgroundColor3=C.border; FtDiv.BorderSizePixel=0

local FooterLbl=Instance.new("TextLabel",Footer)
FooterLbl.Size=UDim2.new(1,-36,1,0); FooterLbl.BackgroundTransparency=1
FooterLbl.Text="Vzko On Top !"; FooterLbl.Font=F_MC
FooterLbl.TextSize=10; FooterLbl.TextColor3=C.textSub
FooterLbl.TextXAlignment=Enum.TextXAlignment.Center

local ResizeIco=Instance.new("ImageLabel",Footer)
ResizeIco.Size=UDim2.fromOffset(16,16); ResizeIco.Position=UDim2.new(1,-20,0.5,-8)
ResizeIco.BackgroundTransparency=1; ResizeIco.Image=I.resize
ResizeIco.ImageColor3=GREY_DARK; ResizeIco.ScaleType=Enum.ScaleType.Fit

do
    local resizing,rS,rW,rH=false,Vector2.zero,MAIN_W,MAIN_H
    local rBtn=Instance.new("TextButton",Footer)
    rBtn.Size=UDim2.fromOffset(20,FOOTER_H); rBtn.Position=UDim2.new(1,-22,0,0)
    rBtn.BackgroundTransparency=1; rBtn.Text=""; rBtn.ZIndex=10
    rBtn.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            resizing=true; rS=Vector2.new(i.Position.X,i.Position.Y)
            rW=Main.AbsoluteSize.X; rH=Main.AbsoluteSize.Y
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if resizing and i.UserInputType==Enum.UserInputType.MouseMovement then
            Main.Size=UDim2.fromOffset(
                math.max(480,rW+(i.Position.X-rS.X)),
                math.max(360,rH+(i.Position.Y-rS.Y))
            )
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then resizing=false end
    end)
end

----------------------------------------------------
-- PAGES
----------------------------------------------------
local Pages={}
local function CreatePage(name)
    local c=Instance.new("ScrollingFrame",ContentArea)
    c.Size=UDim2.new(1,0,1,0); c.BackgroundTransparency=1; c.BorderSizePixel=0
    c.ScrollBarThickness=3; c.ScrollBarImageColor3=C.primary
    c.CanvasSize=UDim2.new(0,0,0,0); c.Visible=false
    local pad=Instance.new("UIPadding",c)
    pad.PaddingLeft=UDim.new(0,10); pad.PaddingRight=UDim.new(0,10)
    pad.PaddingTop=UDim.new(0,10); pad.PaddingBottom=UDim.new(0,10)
    local list=Instance.new("UIListLayout",c)
    list.Padding=UDim.new(0,8); list.SortOrder=Enum.SortOrder.LayoutOrder
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        c.CanvasSize=UDim2.new(0,0,0,list.AbsoluteContentSize.Y+20)
    end)
    Pages[name]=c; return c
end

CreatePage("Dashboard"); CreatePage("Boost");     CreatePage("Visuals")
CreatePage("Others");    CreatePage("Skins");     CreatePage("Wraps")
CreatePage("Charms");    CreatePage("Finishers"); CreatePage("Emotes")
CreatePage("Profile");   CreatePage("DeviceSpoof"); CreatePage("WeaponsSpoof")
CreatePage("GameSpoof"); CreatePage("Settings")

local function ShowPage(name)
    for _,v in pairs(Pages) do v.Visible=false end
    if Pages[name] then Pages[name].Visible=true end
end

_G.ShadowCard=function(parent,text,callback)
    local card=Instance.new("TextButton",parent)
    card.Size=UDim2.new(1,0,0,34); card.BackgroundColor3=C.card; card.BorderSizePixel=0
    card.Text=text; card.Font=F_MC; card.TextSize=12; card.TextColor3=C.text
    card.AutoButtonColor=false; card.TextXAlignment=Enum.TextXAlignment.Left
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,6)
    local pad=Instance.new("UIPadding",card); pad.PaddingLeft=UDim.new(0,10)
    card.MouseEnter:Connect(function() TweenService:Create(card,TweenInfo.new(0.08),{BackgroundColor3=C.cardHov}):Play() end)
    card.MouseLeave:Connect(function() TweenService:Create(card,TweenInfo.new(0.08),{BackgroundColor3=C.card}):Play() end)
    if callback then card.MouseButton1Click:Connect(callback) end
    return card
end

----------------------------------------------------
-- SIDEBAR TABS
----------------------------------------------------
local currentActiveBtn=nil; local expandedGroups={}; local sbOrder=0

local function makeSbSection(label)
    sbOrder=sbOrder+1
    local f=Instance.new("Frame",SbScroll)
    f.Size=UDim2.new(1,0,0,22); f.BackgroundTransparency=1; f.LayoutOrder=sbOrder
    local lbl=Instance.new("TextLabel",f)
    lbl.Size=UDim2.new(1,-14,1,0); lbl.Position=UDim2.fromOffset(14,0)
    lbl.BackgroundTransparency=1; lbl.Text=label; lbl.Font=F_MC; lbl.TextSize=9
    lbl.TextColor3=C.textSub; lbl.TextXAlignment=Enum.TextXAlignment.Left
end

local function makeTabBtn(label,iconId,pageName,isSub)
    sbOrder=sbOrder+1
    local H=isSub and 28 or 36
    local btn=Instance.new("TextButton",SbScroll)
    btn.Size=UDim2.new(1,0,0,H); btn.BackgroundColor3=C.surfaceHov
    btn.BackgroundTransparency=1; btn.Text=""; btn.BorderSizePixel=0; btn.LayoutOrder=sbOrder
    local bar=Instance.new("Frame",btn)
    bar.Size=UDim2.new(0,3,0,H-16); bar.Position=UDim2.new(0,0,0.5,-(H-16)/2)
    bar.BackgroundColor3=C.primary; bar.BorderSizePixel=0
    Instance.new("UICorner",bar).CornerRadius=UDim.new(0,2); bar.Visible=false
    local leftPad=isSub and 30 or 10; local icoSize=isSub and 14 or 18
    local ico=Instance.new("ImageLabel",btn)
    ico.Size=UDim2.fromOffset(icoSize,icoSize); ico.Position=UDim2.new(0,leftPad,0.5,-icoSize/2)
    ico.BackgroundTransparency=1; ico.Image=iconId; ico.ImageColor3=VIOLET_DIM; ico.ScaleType=Enum.ScaleType.Fit
    local txtLeft=leftPad+icoSize+8
    local lbl=Instance.new("TextLabel",btn)
    lbl.Size=UDim2.new(1,-txtLeft-4,1,0); lbl.Position=UDim2.fromOffset(txtLeft,0)
    lbl.BackgroundTransparency=1; lbl.Text=label; lbl.Font=F_MC
    lbl.TextSize=isSub and 10 or 11; lbl.TextColor3=C.textDim; lbl.TextXAlignment=Enum.TextXAlignment.Left
    btn.MouseEnter:Connect(function()
        if currentActiveBtn==btn then return end
        btn.BackgroundTransparency=0.85; btn.BackgroundColor3=C.surfaceHov
        lbl.TextColor3=Color3.fromRGB(190,185,215); ico.ImageColor3=VIOLET
    end)
    btn.MouseLeave:Connect(function()
        if currentActiveBtn==btn then return end
        btn.BackgroundTransparency=1; lbl.TextColor3=C.textDim; ico.ImageColor3=VIOLET_DIM
    end)
    local function activate()
        if currentActiveBtn and currentActiveBtn~=btn then
            local old=currentActiveBtn; old.BackgroundTransparency=1
            for _,c in pairs(old:GetChildren()) do
                if c:IsA("Frame") then c.Visible=false end
                if c:IsA("TextLabel") then c.TextColor3=C.textDim end
                if c:IsA("ImageLabel") then c.ImageColor3=VIOLET_DIM end
            end
        end
        currentActiveBtn=btn; bar.Visible=true
        btn.BackgroundTransparency=0.80; btn.BackgroundColor3=C.surfaceHov
        lbl.TextColor3=C.text; ico.ImageColor3=VIOLET
    end
    btn.MouseButton1Click:Connect(function() ShowPage(pageName); activate() end)
    return btn,activate
end

local function makeGroupBtn(label,iconId,subList)
    sbOrder=sbOrder+1; local H=36
    local btn=Instance.new("TextButton",SbScroll)
    btn.Size=UDim2.new(1,0,0,H); btn.BackgroundColor3=C.surfaceHov
    btn.BackgroundTransparency=1; btn.Text=""; btn.BorderSizePixel=0; btn.LayoutOrder=sbOrder
    local ico=Instance.new("ImageLabel",btn)
    ico.Size=UDim2.fromOffset(18,18); ico.Position=UDim2.new(0,10,0.5,-9)
    ico.BackgroundTransparency=1; ico.Image=iconId; ico.ImageColor3=VIOLET_DIM; ico.ScaleType=Enum.ScaleType.Fit
    local lbl=Instance.new("TextLabel",btn)
    lbl.Size=UDim2.new(1,-50,1,0); lbl.Position=UDim2.fromOffset(36,0)
    lbl.BackgroundTransparency=1; lbl.Text=label; lbl.Font=F_MC; lbl.TextSize=11
    lbl.TextColor3=C.textDim; lbl.TextXAlignment=Enum.TextXAlignment.Left
    local chev=Instance.new("TextLabel",btn)
    chev.Size=UDim2.fromOffset(18,H); chev.Position=UDim2.new(1,-20,0,0)
    chev.BackgroundTransparency=1; chev.Text="›"; chev.Font=F_MC; chev.TextSize=16; chev.TextColor3=C.textSub
    local subs={}
    for _,st in ipairs(subList) do
        local sb,sact=makeTabBtn(st.label,st.icon,st.pageName,true)
        sb.Visible=false; table.insert(subs,{btn=sb,act=sact})
    end
    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency=0.85; btn.BackgroundColor3=C.surfaceHov
        lbl.TextColor3=Color3.fromRGB(190,185,215); ico.ImageColor3=VIOLET
    end)
    btn.MouseLeave:Connect(function()
        if not expandedGroups[label] then btn.BackgroundTransparency=1 end
        lbl.TextColor3=expandedGroups[label] and C.text or C.textDim
        ico.ImageColor3=expandedGroups[label] and VIOLET or VIOLET_DIM
    end)
    local isExp=false
    btn.MouseButton1Click:Connect(function()
        isExp=not isExp; expandedGroups[label]=isExp
        chev.Text=isExp and "˅" or "›"
        lbl.TextColor3=isExp and C.text or C.textDim
        ico.ImageColor3=isExp and VIOLET or VIOLET_DIM
        btn.BackgroundTransparency=isExp and 0.80 or 1
        for _,s in ipairs(subs) do s.btn.Visible=isExp end
        task.defer(function() SbScroll.CanvasSize=UDim2.new(0,0,0,SbList.AbsoluteContentSize.Y+8) end)
    end)
end

makeSbSection("GENERAL")
local _dashBtn,_dashAct=makeTabBtn("Dashboard",I.dashboard,"Dashboard",false)
makeTabBtn("Boost",I.boost,"Boost",false)
makeTabBtn("Visual",I.visual,"Visuals",false)

makeSbSection("UNLOCK")
makeGroupBtn("Unlock",I.unlock,{
    {label="Skins",     icon=I.skins,     pageName="Skins"},
    {label="Wraps",     icon=I.wraps,     pageName="Wraps"},
    {label="Charms",    icon=I.charms,    pageName="Charms"},
    {label="Finishers", icon=I.finishers, pageName="Finishers"},
    {label="Emotes",    icon=I.emotes,    pageName="Emotes"},
})

makeSbSection("SPOOF")
makeGroupBtn("Spoof",I.spoof,{
    {label="Device Spoof",  icon=I.device_spoof,  pageName="DeviceSpoof"},
    {label="Profil Spoof",  icon=I.profile,       pageName="Profile"},
    {label="Weapons Spoof", icon=I.weapons_spoof, pageName="WeaponsSpoof"},
    {label="Game Spoof",    icon=I.game_spoof,    pageName="GameSpoof"},
})

makeSbSection("OTHER")
makeTabBtn("Others",I.others,"Others",false)
makeTabBtn("Settings",I.settings,"Settings",false)

task.defer(function() SbScroll.CanvasSize=UDim2.new(0,0,0,SbList.AbsoluteContentSize.Y+8) end)
ShowPage("Dashboard")
task.defer(function() if _dashAct then _dashAct() end end)

local function navigateToOption(entry)
    ShowPage(entry.page); SearchBox.Text=""; SuggestFrame.Visible=false
    task.defer(function()
        if entry.scroll and entry.card then
            pcall(function()
                local relY=entry.card.AbsolutePosition.Y-entry.scroll.AbsolutePosition.Y+entry.scroll.CanvasPosition.Y
                entry.scroll.CanvasPosition=Vector2.new(0,math.max(0,relY-10))
            end)
        end
    end)
end

local function showSuggestions(q)
    for _,c in pairs(SuggestScroll:GetChildren()) do
        if not c:IsA("UIListLayout") then c:Destroy() end
    end
    if q=="" then SuggestFrame.Visible=false; return end
    local qlow=q:lower(); local matches={}
    for name in pairs(Pages) do
        if name:lower():find(qlow,1,true) then
            table.insert(matches,{label="► "..name,page=name,card=nil,scroll=nil,isPage=true})
        end
    end
    for _,entry in ipairs(OptionRegistry) do
        if entry.label:lower():find(qlow,1,true) then table.insert(matches,entry) end
        if #matches>=8 then break end
    end
    if #matches==0 then SuggestFrame.Visible=false; return end
    for i,entry in ipairs(matches) do
        local btn=Instance.new("TextButton",SuggestScroll)
        btn.Size=UDim2.new(1,0,0,26); btn.BackgroundColor3=Color3.fromRGB(20,20,26)
        btn.BackgroundTransparency=1; btn.BorderSizePixel=0
        btn.Text=""; btn.AutoButtonColor=false; btn.ZIndex=62; btn.LayoutOrder=i
        local lbl=Instance.new("TextLabel",btn)
        lbl.Size=UDim2.new(1,-8,1,0); lbl.Position=UDim2.fromOffset(8,0)
        lbl.BackgroundTransparency=1; lbl.TextSize=10; lbl.Font=Enum.Font.Fantasy
        lbl.TextColor3=entry.isPage and Color3.fromRGB(139,92,246) or Color3.fromRGB(200,200,215)
        lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=63
        lbl.Text=entry.label..(not entry.isPage and "  |  "..entry.page or "")
        local div=Instance.new("Frame",btn)
        div.Size=UDim2.new(1,-16,0,1); div.Position=UDim2.new(0,8,1,-1)
        div.BackgroundColor3=Color3.fromRGB(35,35,45); div.BorderSizePixel=0; div.ZIndex=62
        btn.MouseEnter:Connect(function() btn.BackgroundTransparency=0; btn.BackgroundColor3=Color3.fromRGB(35,35,50) end)
        btn.MouseLeave:Connect(function() btn.BackgroundTransparency=1 end)
        local captEntry=entry
        btn.MouseButton1Click:Connect(function() navigateToOption(captEntry) end)
    end
    SuggestFrame.Visible=true
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q=SearchBox.Text:lower()
    if q=="" then SuggestFrame.Visible=false; return end
    showSuggestions(q)
end)
SearchBox.FocusLost:Connect(function() task.delay(0.2,function() SuggestFrame.Visible=false end) end)
SearchBox.Focused:Connect(function() if SearchBox.Text~="" then showSuggestions(SearchBox.Text:lower()) end end)

task.defer(function()
    task.wait(1)
    for pageName,page in pairs(Pages) do
        for _,child in ipairs(page:GetChildren()) do
            if child:IsA("Frame") and child.Size.Y.Offset>20 then
                for _,desc in ipairs(child:GetChildren()) do
                    if desc:IsA("TextLabel") and desc.TextSize>=9
                       and desc.Text~="" and #desc.Text>2
                       and not desc.Text:find("^%u+$") then
                        table.insert(OptionRegistry,{label=desc.Text,page=pageName,card=child,scroll=page})
                        break
                    end
                end
            end
        end
    end
end)

----------------------------------------------------
-- SERVICES
----------------------------------------------------
local RunService   = game:GetService("RunService")
local Lighting     = game:GetService("Lighting")
local Workspace    = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local Stats        = game:GetService("Stats")

local function hex(r,g,b) return Color3.fromRGB(r,g,b) end
local SILK      = Font.new("rbxassetid://12187371840",Enum.FontWeight.Regular)
local SILK_BOLD = Font.new("rbxassetid://12187371840",Enum.FontWeight.Bold)

----------------------------------------------------
-- NOTIFICATION SYSTEM
----------------------------------------------------
local NotifGui = Instance.new("ScreenGui", _GUI_ROOT)
NotifGui.Name = "ShadowNotifGui"; NotifGui.DisplayOrder = 1003
NotifGui.IgnoreGuiInset = true; NotifGui.ResetOnSpawn = false

local NotifHolder = Instance.new("Frame", NotifGui)
NotifHolder.AnchorPoint = Vector2.new(1,0)
NotifHolder.Size = UDim2.fromOffset(270,500)
NotifHolder.Position = UDim2.new(1,-8,0,8)
NotifHolder.BackgroundTransparency = 1; NotifHolder.BorderSizePixel = 0

local NotifLayout = Instance.new("UIListLayout", NotifHolder)
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotifLayout.Padding = UDim.new(0,5)

local _notifIdx = 0
local function ShadowNotif(title, message, color)
    if getgenv().ShadowNoNotif then return end
    color = color or Color3.fromRGB(139,92,246)
    _notifIdx = _notifIdx + 1
    local card = Instance.new("Frame", NotifHolder)
    card.Size = UDim2.fromOffset(255,56); card.BackgroundColor3 = Color3.fromRGB(18,18,24)
    card.BackgroundTransparency = 1; card.BorderSizePixel = 0; card.LayoutOrder = _notifIdx
    Instance.new("UICorner", card).CornerRadius = UDim.new(0,8)
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = color; stroke.Thickness = 1; stroke.Transparency = 1
    local bar = Instance.new("Frame", card)
    bar.Size = UDim2.fromOffset(3,36); bar.Position = UDim2.fromOffset(8,10)
    bar.BackgroundColor3 = color; bar.BorderSizePixel = 0; bar.BackgroundTransparency = 1
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0,2)
    local titleLbl = Instance.new("TextLabel", card)
    titleLbl.Size = UDim2.new(1,-24,0,20); titleLbl.Position = UDim2.fromOffset(18,7)
    titleLbl.BackgroundTransparency = 1; titleLbl.TextSize = 11
    titleLbl.TextColor3 = color; titleLbl.TextTransparency = 1
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.Text = title
    local msgLbl = Instance.new("TextLabel", card)
    msgLbl.Size = UDim2.new(1,-24,0,16); msgLbl.Position = UDim2.fromOffset(18,30)
    msgLbl.BackgroundTransparency = 1; msgLbl.TextSize = 9
    msgLbl.TextColor3 = Color3.fromRGB(130,125,155); msgLbl.TextTransparency = 1
    msgLbl.TextXAlignment = Enum.TextXAlignment.Left; msgLbl.Text = message
    task.defer(function()
        titleLbl.FontFace = Font.new("rbxassetid://12187371840",Enum.FontWeight.Bold)
        msgLbl.FontFace = Font.new("rbxassetid://12187371840",Enum.FontWeight.Regular)
    end)
    local tIn = TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
    TweenService:Create(card,tIn,{BackgroundTransparency=0}):Play()
    TweenService:Create(stroke,tIn,{Transparency=0}):Play()
    TweenService:Create(bar,tIn,{BackgroundTransparency=0}):Play()
    TweenService:Create(titleLbl,tIn,{TextTransparency=0}):Play()
    TweenService:Create(msgLbl,tIn,{TextTransparency=0}):Play()
    task.delay(3.2, function()
        if not card or not card.Parent then return end
        local tOut = TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
        TweenService:Create(card,tOut,{BackgroundTransparency=1}):Play()
        TweenService:Create(stroke,tOut,{Transparency=1}):Play()
        TweenService:Create(bar,tOut,{BackgroundTransparency=1}):Play()
        TweenService:Create(titleLbl,tOut,{TextTransparency=1}):Play()
        TweenService:Create(msgLbl,tOut,{TextTransparency=1}):Play()
        task.delay(0.35, function() pcall(function() card:Destroy() end) end)
    end)
end
getgenv().ShadowNotif = ShadowNotif

----------------------------------------------------
-- DASHBOARD
----------------------------------------------------
local DashPage=Pages["Dashboard"]

local WelcomeLbl=Instance.new("TextLabel",DashPage)
WelcomeLbl.Size=UDim2.new(1,0,0,30); WelcomeLbl.BackgroundTransparency=1
WelcomeLbl.FontFace=SILK_BOLD; WelcomeLbl.TextSize=16; WelcomeLbl.TextColor3=C.primary
WelcomeLbl.TextXAlignment=Enum.TextXAlignment.Center; WelcomeLbl.LayoutOrder=0
WelcomeLbl.Text="Bienvenue "..Player.DisplayName.." !"

local WelcomeDiv=Instance.new("Frame",DashPage)
WelcomeDiv.Size=UDim2.new(0.4,0,0,1); WelcomeDiv.Position=UDim2.new(0.3,0,0,0)
WelcomeDiv.BackgroundColor3=C.primary; WelcomeDiv.BorderSizePixel=0; WelcomeDiv.LayoutOrder=1
Instance.new("UICorner",WelcomeDiv).CornerRadius=UDim.new(1,0)

local ProfileCard=Instance.new("Frame",DashPage)
-- [MODIF 1] Taille augmentée de 108 → 124 pour accueillir la ligne Plateforme
ProfileCard.Size=UDim2.new(1,0,0,124); ProfileCard.BackgroundColor3=C.card
ProfileCard.BorderSizePixel=0; ProfileCard.LayoutOrder=2
Instance.new("UICorner",ProfileCard).CornerRadius=UDim.new(0,8)
Instance.new("UIStroke",ProfileCard).Color=C.border

local AvatarFrame=Instance.new("Frame",ProfileCard)
AvatarFrame.Size=UDim2.fromOffset(80,80); AvatarFrame.Position=UDim2.fromOffset(12,14)
AvatarFrame.BackgroundColor3=C.surface; AvatarFrame.BorderSizePixel=0
Instance.new("UICorner",AvatarFrame).CornerRadius=UDim.new(0,8)
local avStr=Instance.new("UIStroke",AvatarFrame); avStr.Color=C.primary; avStr.Thickness=2

local AvatarImg=Instance.new("ImageLabel",AvatarFrame)
AvatarImg.Size=UDim2.new(1,-4,1,-4); AvatarImg.Position=UDim2.fromOffset(2,2)
AvatarImg.BackgroundTransparency=1; AvatarImg.ScaleType=Enum.ScaleType.Fit
Instance.new("UICorner",AvatarImg).CornerRadius=UDim.new(0,6)
pcall(function()
    local c,_=Players:GetUserThumbnailAsync(Player.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)
    AvatarImg.Image=c
end)

local InfoFrame=Instance.new("Frame",ProfileCard)
InfoFrame.Size=UDim2.new(1,-108,1,-14); InfoFrame.Position=UDim2.fromOffset(104,7)
InfoFrame.BackgroundTransparency=1
local InfoList=Instance.new("UIListLayout",InfoFrame)
InfoList.Padding=UDim.new(0,4); InfoList.SortOrder=Enum.SortOrder.LayoutOrder

local function infoRow(parent,key,value,order,valColor,richText)
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,15); row.BackgroundTransparency=1; row.LayoutOrder=order
    local kl=Instance.new("TextLabel",row)
    kl.Size=UDim2.fromOffset(90,15); kl.BackgroundTransparency=1
    kl.FontFace=SILK; kl.TextSize=10; kl.TextColor3=C.textDim
    kl.TextXAlignment=Enum.TextXAlignment.Left; kl.Text=key..":"
    local vl=Instance.new("TextLabel",row)
    vl.Size=UDim2.new(1,-94,1,0); vl.Position=UDim2.fromOffset(94,0)
    vl.BackgroundTransparency=1; vl.FontFace=SILK; vl.TextSize=10
    vl.TextColor3=valColor or C.text; vl.TextXAlignment=Enum.TextXAlignment.Left
    vl.RichText=richText or false; vl.Text=value
    return vl
end

local gameName="Rivals"
pcall(function() gameName=game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)

-- [MODIF 2] Détection de la plateforme initiale
local playerPlatform = "PC"
if UIS.VREnabled then
    playerPlatform = "VR"
elseif UIS.TouchEnabled and not UIS.KeyboardEnabled then
    playerPlatform = "Phone"
elseif UIS.GamepadEnabled and not UIS.KeyboardEnabled then
    playerPlatform = "Controller"
end

-- [MODIF 2] Plateforme en ordre 1 (en tête), les autres décalés
local infoPlatformeLbl   = infoRow(InfoFrame,"Plateforme",playerPlatform,1)  -- << EN PREMIER
local infoDisplayNameLbl = infoRow(InfoFrame,"DisplayName",Player.DisplayName,2)
local infoUsernameLbl    = infoRow(InfoFrame,"Username","@"..Player.Name,3)
local infoUserIdLbl      = infoRow(InfoFrame,"User ID",tostring(Player.UserId),4)
infoRow(InfoFrame,"Jeu",gameName,5)
infoRow(InfoFrame,"Statut",'[<font color="#22c55e">Connecté OK</font>]',6,hex(34,197,94),true)

local PerfCard=Instance.new("Frame",DashPage)
PerfCard.Size=UDim2.new(1,0,0,148); PerfCard.BackgroundColor3=C.card
PerfCard.BorderSizePixel=0; PerfCard.LayoutOrder=3
Instance.new("UICorner",PerfCard).CornerRadius=UDim.new(0,8)
Instance.new("UIStroke",PerfCard).Color=C.border

local PerfTitle=Instance.new("TextLabel",PerfCard)
PerfTitle.Size=UDim2.fromOffset(140,22); PerfTitle.Position=UDim2.fromOffset(12,6)
PerfTitle.BackgroundTransparency=1; PerfTitle.FontFace=SILK; PerfTitle.TextSize=9
PerfTitle.TextColor3=C.textDim; PerfTitle.TextXAlignment=Enum.TextXAlignment.Left
PerfTitle.Text="PERFORMANCES"

local ServerCountryLbl=Instance.new("TextLabel",PerfCard)
ServerCountryLbl.Size=UDim2.new(1,-160,0,22); ServerCountryLbl.Position=UDim2.fromOffset(150,6)
ServerCountryLbl.BackgroundTransparency=1; ServerCountryLbl.FontFace=SILK; ServerCountryLbl.TextSize=9
ServerCountryLbl.TextColor3=C.textDim; ServerCountryLbl.TextXAlignment=Enum.TextXAlignment.Right
ServerCountryLbl.Text="Serveur : ..."

task.spawn(function()
    local ok,res=pcall(function()
        local ls=game:GetService("LocalizationService")
        local locale=ls.RobloxLocaleId:lower()
        local map={
            ["en-gb"]="🇬🇧 Royaume-Uni",["fr-fr"]="🇫🇷 France",["fr"]="🇫🇷 France",
            ["en-us"]="🇺🇸 États-Unis",["de-de"]="🇩🇪 Allemagne",["de"]="🇩🇪 Allemagne",
            ["es-es"]="🇪🇸 Espagne",["it-it"]="🇮🇹 Italie",["pt-br"]="🇧🇷 Brésil",
            ["nl-nl"]="🇳🇱 Pays-Bas",["pl-pl"]="🇵🇱 Pologne",["ru-ru"]="🇷🇺 Russie",
            ["ja-jp"]="🇯🇵 Japon",["ko-kr"]="🇰🇷 Corée du Sud",["zh-cn"]="🇨🇳 Chine",
            ["tr-tr"]="🇹🇷 Turquie",["en-au"]="🇦🇺 Australie",["en-sg"]="🇸🇬 Singapour",
            ["id-id"]="🇮🇩 Indonésie",["ar-sa"]="🇸🇦 Arabie Saoudite",
        }
        if map[locale] then return map[locale] end
        local short=locale:sub(1,2)
        for k,v in pairs(map) do if k:sub(1,2)==short then return v end end
        return "🌍 "..locale:upper()
    end)
    ServerCountryLbl.Text="Serveur : "..(ok and res or "Inconnu")
end)

local FpsValLbl=Instance.new("TextLabel",PerfCard)
FpsValLbl.Size=UDim2.fromOffset(110,20); FpsValLbl.Position=UDim2.fromOffset(12,30)
FpsValLbl.BackgroundTransparency=1; FpsValLbl.FontFace=SILK_BOLD; FpsValLbl.TextSize=13
FpsValLbl.TextColor3=C.primary; FpsValLbl.TextXAlignment=Enum.TextXAlignment.Left; FpsValLbl.Text="FPS: --"

local PingValLbl=Instance.new("TextLabel",PerfCard)
PingValLbl.Size=UDim2.fromOffset(130,20); PingValLbl.Position=UDim2.fromOffset(130,30)
PingValLbl.BackgroundTransparency=1; PingValLbl.FontFace=SILK_BOLD; PingValLbl.TextSize=13
PingValLbl.TextColor3=hex(167,139,250); PingValLbl.TextXAlignment=Enum.TextXAlignment.Left; PingValLbl.Text="PING: -- ms"

local GraphBg=Instance.new("Frame",PerfCard)
GraphBg.Size=UDim2.new(1,-24,0,82); GraphBg.Position=UDim2.fromOffset(12,56)
GraphBg.BackgroundColor3=C.panelDark; GraphBg.BorderSizePixel=0; GraphBg.ClipsDescendants=true
Instance.new("UICorner",GraphBg).CornerRadius=UDim.new(0,6)
Instance.new("UIStroke",GraphBg).Color=C.border

local FpsLeg=Instance.new("TextLabel",GraphBg)
FpsLeg.Size=UDim2.fromOffset(52,12); FpsLeg.Position=UDim2.fromOffset(6,3)
FpsLeg.BackgroundTransparency=1; FpsLeg.FontFace=SILK; FpsLeg.TextSize=8
FpsLeg.TextColor3=C.primary; FpsLeg.TextXAlignment=Enum.TextXAlignment.Left; FpsLeg.Text="* FPS"

local PingLeg=Instance.new("TextLabel",GraphBg)
PingLeg.Size=UDim2.fromOffset(62,12); PingLeg.Position=UDim2.fromOffset(58,3)
PingLeg.BackgroundTransparency=1; PingLeg.FontFace=SILK; PingLeg.TextSize=8
PingLeg.TextColor3=hex(167,139,250); PingLeg.TextXAlignment=Enum.TextXAlignment.Left; PingLeg.Text="* PING"

for _,pct in ipairs({0.33,0.66}) do
    local g=Instance.new("Frame",GraphBg)
    g.Size=UDim2.new(1,0,0,1); g.Position=UDim2.new(0,0,pct,0)
    g.BackgroundColor3=C.border; g.BorderSizePixel=0
end

local GRAPH_POINTS=50; local STRIP_W=4; local GRAPH_TOP=18
local fpsHistory={}; local pingHistory={}; local fpsStrips={}; local pingStrips={}

for i=1,GRAPH_POINTS do
    local s=Instance.new("Frame",GraphBg)
    s.AnchorPoint=Vector2.new(0,1); s.BackgroundColor3=C.primary; s.BorderSizePixel=0; s.ZIndex=3
    Instance.new("UICorner",s).CornerRadius=UDim.new(0,2)
    s.Size=UDim2.fromOffset(STRIP_W-1,0); s.Position=UDim2.fromOffset((i-1)*STRIP_W,0); s.Visible=false
    fpsStrips[i]=s
    local p=Instance.new("Frame",GraphBg)
    p.AnchorPoint=Vector2.new(0,1); p.BackgroundColor3=hex(167,139,250); p.BorderSizePixel=0; p.ZIndex=2
    Instance.new("UICorner",p).CornerRadius=UDim.new(0,2)
    p.Size=UDim2.fromOffset(STRIP_W-1,0); p.Position=UDim2.fromOffset((i-1)*STRIP_W,0)
    p.Visible=false; p.BackgroundTransparency=0.45; pingStrips[i]=p
end

local function updateGraph()
    local absH=GraphBg.AbsoluteSize.Y-GRAPH_TOP
    if absH<=0 then return end
    local nF=#fpsHistory; local nP=#pingHistory
    for i=1,GRAPH_POINTS do
        local fi=nF-GRAPH_POINTS+i
        if fi>=1 and fpsHistory[fi] then
            local v=math.clamp(fpsHistory[fi],0,144)
            fpsStrips[i].Size=UDim2.fromOffset(STRIP_W-1,math.max(2,(v/144)*absH))
            fpsStrips[i].Position=UDim2.new(0,(i-1)*STRIP_W,1,0); fpsStrips[i].Visible=true
            fpsStrips[i].BackgroundColor3=v>=55 and hex(34,197,94) or v>=30 and hex(250,204,21) or hex(239,68,68)
        else fpsStrips[i].Visible=false end
        local pi=nP-GRAPH_POINTS+i
        if pi>=1 and pingHistory[pi] then
            local v=math.clamp(pingHistory[pi],0,300)
            pingStrips[i].Size=UDim2.fromOffset(STRIP_W-1,math.max(2,(v/300)*absH))
            pingStrips[i].Position=UDim2.new(0,(i-1)*STRIP_W,1,0); pingStrips[i].Visible=true
            pingStrips[i].BackgroundColor3=v<=80 and hex(34,197,94) or v<=150 and hex(250,204,21) or hex(239,68,68)
        else pingStrips[i].Visible=false end
    end
end

local lastSample=0
RunService.Heartbeat:Connect(function(dt)
    lastSample=lastSample+dt
    if lastSample<0.5 then return end; lastSample=0
    local fps=math.floor(1/dt)
    table.insert(fpsHistory,fps); if #fpsHistory>GRAPH_POINTS then table.remove(fpsHistory,1) end
    local ping=0; pcall(function() ping=Player:GetNetworkPing()*1000 end)
    table.insert(pingHistory,math.floor(ping)); if #pingHistory>GRAPH_POINTS then table.remove(pingHistory,1) end
    local fc=fps>=55 and hex(34,197,94) or fps>=30 and hex(250,204,21) or hex(239,68,68)
    FpsValLbl.TextColor3=fc; FpsValLbl.Text="FPS: "..fps
    local pc2=ping<=80 and hex(34,197,94) or ping<=150 and hex(250,204,21) or hex(239,68,68)
    PingValLbl.TextColor3=pc2; PingValLbl.Text="PING: "..math.floor(ping).." ms"
    updateGraph()
end)

----------------------------------------------------
-- BOOST PAGE
----------------------------------------------------
local BoostPage=Pages["Boost"]
local State={
    performance=false,quality=4,shadows=true,effects=true,
    particles=true,viewDistance=512,lowLatency=false,
    hudVisible=false,reduceVisual=false,progLoad=false,autoOpt=false,
}
local UIRefs={}

local function makeSection(parent,title,order)
    local sec=Instance.new("Frame",parent)
    sec.Size=UDim2.new(1,0,0,20); sec.BackgroundTransparency=1; sec.LayoutOrder=order
    local lbl=Instance.new("TextLabel",sec)
    lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
    lbl.FontFace=SILK; lbl.TextSize=9; lbl.TextColor3=C.textSub
    lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=title
    return sec
end

local function makeToggle(parent,label,iconId,stateKey,order,onToggle)
    local card=Instance.new("Frame",parent)
    card.Size=UDim2.new(1,0,0,38); card.BackgroundColor3=C.card
    card.BorderSizePixel=0; card.LayoutOrder=order
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,7)
    Instance.new("UIStroke",card).Color=C.border
    local ico=Instance.new("ImageLabel",card)
    ico.Size=UDim2.fromOffset(18,18); ico.Position=UDim2.new(0,10,0.5,-9)
    ico.BackgroundTransparency=1; ico.Image="rbxassetid://"..iconId
    ico.ImageColor3=C.primary; ico.ScaleType=Enum.ScaleType.Fit
    local lbl=Instance.new("TextLabel",card)
    lbl.Size=UDim2.new(1,-100,1,0); lbl.Position=UDim2.fromOffset(34,0)
    lbl.BackgroundTransparency=1; lbl.FontFace=SILK; lbl.TextSize=10
    lbl.TextColor3=C.text; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=label
    local track=Instance.new("TextButton",card)
    track.Size=UDim2.fromOffset(42,22); track.Position=UDim2.new(1,-54,0.5,-11)
    track.BackgroundColor3=State[stateKey] and C.primary or C.surface
    track.BorderSizePixel=0; track.Text=""; track.AutoButtonColor=false
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
    Instance.new("UIStroke",track).Color=C.border
    local thumb=Instance.new("Frame",track)
    thumb.Size=UDim2.fromOffset(16,16)
    thumb.Position=State[stateKey] and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)
    thumb.BackgroundColor3=Color3.new(1,1,1); thumb.BorderSizePixel=0
    Instance.new("UICorner",thumb).CornerRadius=UDim.new(1,0)
    UIRefs[stateKey]={track=track,thumb=thumb}
    track.MouseButton1Click:Connect(function()
        State[stateKey]=not State[stateKey]
        TweenService:Create(track,TweenInfo.new(0.12),{BackgroundColor3=State[stateKey] and C.primary or C.surface}):Play()
        TweenService:Create(thumb,TweenInfo.new(0.12),{Position=State[stateKey] and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)}):Play()
        if onToggle then pcall(onToggle,State[stateKey]) end
        if getgenv().ShadowNotif then
            local c=State[stateKey] and Color3.fromRGB(34,197,94) or Color3.fromRGB(239,68,68)
            getgenv().ShadowNotif(label, State[stateKey] and "✓  Activé" or "✗  Désactivé", c)
        end
    end)
    return card
end

local function makeSlider(parent,label,iconId,stateKey,minV,maxV,step,unit,order,onChange)
    local card=Instance.new("Frame",parent)
    card.Size=UDim2.new(1,0,0,52); card.BackgroundColor3=C.card
    card.BorderSizePixel=0; card.LayoutOrder=order
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,7)
    Instance.new("UIStroke",card).Color=C.border
    local ico=Instance.new("ImageLabel",card)
    ico.Size=UDim2.fromOffset(18,18); ico.Position=UDim2.fromOffset(10,8)
    ico.BackgroundTransparency=1; ico.Image="rbxassetid://"..iconId
    ico.ImageColor3=C.primary; ico.ScaleType=Enum.ScaleType.Fit
    local lbl=Instance.new("TextLabel",card)
    lbl.Size=UDim2.new(0.6,0,0,22); lbl.Position=UDim2.fromOffset(34,6)
    lbl.BackgroundTransparency=1; lbl.FontFace=SILK; lbl.TextSize=10
    lbl.TextColor3=C.text; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=label
    local valLbl=Instance.new("TextLabel",card)
    valLbl.Size=UDim2.new(0.35,0,0,22); valLbl.Position=UDim2.new(0.63,0,0,6)
    valLbl.BackgroundTransparency=1; valLbl.FontFace=SILK; valLbl.TextSize=10
    valLbl.TextColor3=C.primary; valLbl.TextXAlignment=Enum.TextXAlignment.Right
    valLbl.Text=tostring(State[stateKey])..unit
    local trackBg=Instance.new("Frame",card)
    trackBg.Size=UDim2.new(1,-24,0,6); trackBg.Position=UDim2.fromOffset(12,38)
    trackBg.BackgroundColor3=C.surface; trackBg.BorderSizePixel=0
    Instance.new("UICorner",trackBg).CornerRadius=UDim.new(1,0)
    local fill=Instance.new("Frame",trackBg); fill.BackgroundColor3=C.primary; fill.BorderSizePixel=0
    fill.Size=UDim2.new((State[stateKey]-minV)/(maxV-minV),0,1,0)
    Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
    local knob=Instance.new("Frame",trackBg); knob.Size=UDim2.fromOffset(14,14)
    knob.AnchorPoint=Vector2.new(0.5,0.5); knob.Position=UDim2.new((State[stateKey]-minV)/(maxV-minV),0,0.5,0)
    knob.BackgroundColor3=Color3.new(1,1,1); knob.BorderSizePixel=0
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
    local dragging=false
    local btn=Instance.new("TextButton",trackBg)
    btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""; btn.ZIndex=5
    local function setVal(absX)
        local rel=math.clamp((absX-trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X,0,1)
        local snapped=math.floor((minV+rel*(maxV-minV))/step+0.5)*step
        snapped=math.clamp(snapped,minV,maxV); State[stateKey]=snapped
        local pct=(snapped-minV)/(maxV-minV)
        fill.Size=UDim2.new(pct,0,1,0); knob.Position=UDim2.new(pct,0,0.5,0)
        valLbl.Text=tostring(snapped)..unit
        if onChange then pcall(onChange,snapped) end
    end
    btn.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; setVal(i.Position.X) end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then setVal(i.Position.X) end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)
    return card
end

local function makeButtonFixed(parent,label,iconId,bgColor,order,onClick)
    local wrap=Instance.new("Frame",parent)
    wrap.Size=UDim2.new(1,0,0,38); wrap.BackgroundColor3=bgColor or hex(55,55,75)
    wrap.BorderSizePixel=0; wrap.LayoutOrder=order
    Instance.new("UICorner",wrap).CornerRadius=UDim.new(0,7)
    local ico=Instance.new("ImageLabel",wrap)
    ico.Size=UDim2.fromOffset(18,18); ico.Position=UDim2.new(0,12,0.5,-9)
    ico.BackgroundTransparency=1; ico.Image="rbxassetid://"..iconId
    ico.ImageColor3=Color3.new(1,1,1); ico.ScaleType=Enum.ScaleType.Fit
    local lbl=Instance.new("TextLabel",wrap)
    lbl.Size=UDim2.new(1,-42,1,0); lbl.Position=UDim2.fromOffset(38,0)
    lbl.BackgroundTransparency=1; lbl.FontFace=SILK; lbl.TextSize=10
    lbl.TextColor3=Color3.new(1,1,1); lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=label
    local hit=Instance.new("TextButton",wrap)
    hit.Size=UDim2.new(1,0,1,0); hit.BackgroundTransparency=1; hit.Text=""; hit.ZIndex=5
    hit.MouseEnter:Connect(function()
        TweenService:Create(wrap,TweenInfo.new(0.08),{BackgroundColor3=(bgColor or hex(55,55,75)):Lerp(Color3.new(1,1,1),0.12)}):Play()
    end)
    hit.MouseLeave:Connect(function()
        TweenService:Create(wrap,TweenInfo.new(0.08),{BackgroundColor3=bgColor or hex(55,55,75)}):Play()
    end)
    if onClick then hit.MouseButton1Click:Connect(function() pcall(onClick) end) end
    return wrap
end

-- HUD
local HudGui=Instance.new("ScreenGui",_GUI_ROOT)
HudGui.Name="ShadowHUD"; HudGui.DisplayOrder=998; HudGui.ResetOnSpawn=false; HudGui.IgnoreGuiInset=true
local HudFrame=Instance.new("Frame",HudGui)
HudFrame.Size=UDim2.fromOffset(110,52); HudFrame.Position=UDim2.fromOffset(10,100)
HudFrame.BackgroundColor3=hex(18,12,36); HudFrame.BorderSizePixel=0
HudFrame.Visible=false; HudFrame.Active=true
Instance.new("UICorner",HudFrame).CornerRadius=UDim.new(0,5)
local hudStr=Instance.new("UIStroke",HudFrame); hudStr.Color=C.primary; hudStr.Thickness=1
local HudPad=Instance.new("UIPadding",HudFrame)
HudPad.PaddingLeft=UDim.new(0,7); HudPad.PaddingTop=UDim.new(0,5)
HudPad.PaddingRight=UDim.new(0,7); HudPad.PaddingBottom=UDim.new(0,5)
local HudList=Instance.new("UIListLayout",HudFrame)
HudList.Padding=UDim.new(0,2); HudList.SortOrder=Enum.SortOrder.LayoutOrder

local function makeHudLine(txt,order)
    local l=Instance.new("TextLabel",HudFrame)
    l.Size=UDim2.new(1,0,0,13); l.BackgroundTransparency=1
    l.FontFace=Font.new("rbxasset://fonts/families/RobotoMono.json",Enum.FontWeight.Bold)
    l.TextSize=11; l.TextColor3=C.primary
    l.TextXAlignment=Enum.TextXAlignment.Left; l.Text=txt; l.LayoutOrder=order
    return l
end
local HudFpsLbl=makeHudLine("FPS  --",1)
local HudPingLbl=makeHudLine("PING --ms",2)
local HudMemLbl=makeHudLine("MEM  --MB",3)

do
    local hDrag,hDS,hSP=false,nil,nil
    HudFrame.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            hDrag=true; hDS=i.Position; hSP=HudFrame.Position
            i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then hDrag=false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if hDrag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-hDS
            HudFrame.Position=UDim2.new(hSP.X.Scale,hSP.X.Offset+d.X,hSP.Y.Scale,hSP.Y.Offset+d.Y)
        end
    end)
end

local function updateHud()
    HudFrame.Visible=State.hudVisible
    HudFrame.Size=UDim2.fromOffset(110,12+HudList.AbsoluteContentSize.Y)
end

RunService.Heartbeat:Connect(function(dt)
    if not HudFrame.Visible then return end
    HudFpsLbl.Text="FPS  "..math.floor(1/dt)
    local p=0; pcall(function() p=Player:GetNetworkPing()*1000 end)
    HudPingLbl.Text="PING "..math.floor(p).."ms"
    HudMemLbl.Text="MEM  "..math.floor(Stats:GetTotalMemoryUsageMb()).."MB"
end)

local particleConn=nil
local function applyParticles(on)
    for _,d in ipairs(Workspace:GetDescendants()) do
        if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Smoke") or d:IsA("Fire") or d:IsA("Sparkles") then
            pcall(function() d.Enabled=on end) end
    end
    if not on then
        if particleConn then particleConn:Disconnect() end
        particleConn=Workspace.DescendantAdded:Connect(function(d)
            if State.particles then particleConn:Disconnect(); return end
            if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Smoke") or d:IsA("Fire") or d:IsA("Sparkles") then
                pcall(function() d.Enabled=false end) end
        end)
    else
        if particleConn then particleConn:Disconnect(); particleConn=nil end
    end
end
local function applyEffects(on)
    for _,v in ipairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect")
           or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("DepthOfFieldEffect") then
            pcall(function() v.Enabled=on end) end
    end
end
local function applyShadows(on) pcall(function() Lighting.GlobalShadows=on end) end
local function applyQuality(v) pcall(function() settings().Rendering.QualityLevel=v end) end
local function applyViewDistance(v)
    pcall(function() Workspace.StreamingMinRadius=math.min(v,256) end)
    pcall(function() Workspace.StreamingTargetRadius=v end)
end
local function applyLowLatency(on)
    applyEffects(not on); applyParticles(not on)
    if on then
        applyViewDistance(math.min(State.viewDistance,256))
        pcall(function() settings().Rendering.QualityLevel=4 end)
    end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=Player then pcall(function()
            local char=p.Character
            if char then for _,acc in ipairs(char:GetChildren()) do
                if acc:IsA("Accessory") then
                    local h=acc:FindFirstChild("Handle")
                    if h then for _,m in ipairs(h:GetChildren()) do
                        if m:IsA("SpecialMesh") then m.Scale=on and Vector3.new(0,0,0) or Vector3.new(1,1,1) end
                    end end
                end
            end end
        end) end
    end
end
local function applyReduceVisual(on)
    for _,d in ipairs(Workspace:GetDescendants()) do
        if d:IsA("Decal") or d:IsA("Texture") then pcall(function() d.Transparency=on and 0.98 or 0 end) end
    end
    for _,s in ipairs(Workspace:GetDescendants()) do
        if s:IsA("Sound") and not s.IsPlaying then pcall(function() s.Volume=on and 0 or 0.5 end) end
    end
end
local function applyProgLoad(on)
    pcall(function() Workspace.StreamingEnabled=on end)
    if on then
        pcall(function() Workspace.StreamingMinRadius=128 end)
        pcall(function() Workspace.StreamingTargetRadius=512 end)
    end
end
local function applyPerformanceMode(on)
    if on then
        pcall(function() settings().Rendering.QualityLevel=1 end)
        Lighting.GlobalShadows=false
        applyEffects(false); applyParticles(false); applyViewDistance(200)
        for _,s in ipairs(Workspace:GetDescendants()) do
            if s:IsA("Sound") then pcall(function() s.Volume=0 end) end
        end
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=Player then pcall(function()
                local char=p.Character
                if char then for _,acc in ipairs(char:GetChildren()) do
                    if acc:IsA("Accessory") then acc.Parent=nil end
                end end
            end) end
        end
        State.shadows=false; State.effects=false; State.particles=false
        for _,key in ipairs({"shadows","effects","particles"}) do
            local ref=UIRefs[key]
            if ref then
                TweenService:Create(ref.track,TweenInfo.new(0.12),{BackgroundColor3=C.surface}):Play()
                TweenService:Create(ref.thumb,TweenInfo.new(0.12),{Position=UDim2.fromOffset(3,3)}):Play()
            end
        end
    else
        pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Automatic end)
        Lighting.GlobalShadows=true; applyEffects(true); applyParticles(true); applyViewDistance(512)
    end
end
local function autoOptimize()
    State.performance=true; applyPerformanceMode(true)
    State.lowLatency=true; applyLowLatency(true)
    State.reduceVisual=true; applyReduceVisual(true)
    State.progLoad=true; applyProgLoad(true)
    State.viewDistance=200; applyViewDistance(200)
    State.quality=2; applyQuality(2)
    for key,ref in pairs(UIRefs) do
        local on=State[key]
        if type(on)=="boolean" then
            TweenService:Create(ref.track,TweenInfo.new(0.12),{BackgroundColor3=on and C.primary or C.surface}):Play()
            TweenService:Create(ref.thumb,TweenInfo.new(0.12),{Position=on and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)}):Play()
        end
    end
end
local function resetAll()
    State.performance=false; applyPerformanceMode(false)
    State.shadows=true; applyShadows(true)
    State.effects=true; applyEffects(true)
    State.particles=true; applyParticles(true)
    State.viewDistance=512; applyViewDistance(512)
    State.quality=4; applyQuality(4)
    State.lowLatency=false; applyLowLatency(false)
    State.reduceVisual=false; applyReduceVisual(false)
    State.progLoad=false; applyProgLoad(false)
    State.hudVisible=false; updateHud()
    for key,ref in pairs(UIRefs) do
        local on=State[key]
        if type(on)=="boolean" then
            TweenService:Create(ref.track,TweenInfo.new(0.12),{BackgroundColor3=on and C.primary or C.surface}):Play()
            TweenService:Create(ref.thumb,TweenInfo.new(0.12),{Position=on and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)}):Play()
        end
    end
end

local o=0; local function O() o=o+1; return o end
makeSection(BoostPage,"GRAPHISMES",O())
makeToggle(BoostPage,"Mode performance",   "13321880274",      "performance",  O(),applyPerformanceMode)
makeSlider(BoostPage,"Qualité graphique",  "102994395432803",  "quality",      1,10,1,"/10",O(),applyQuality)
makeToggle(BoostPage,"Ombres",             "9405931578",       "shadows",      O(),applyShadows)
makeToggle(BoostPage,"Effets visuels",     "138274063261193",  "effects",      O(),applyEffects)
makeToggle(BoostPage,"Particules",         "108670129622160",  "particles",    O(),applyParticles)
makeSlider(BoostPage,"Distance affichage", "11833663904",      "viewDistance", 64,1024,64," st",O(),applyViewDistance)
makeSection(BoostPage,"RÉSEAU",O())
makeToggle(BoostPage,"Mode faible latence",            "105442920358687","lowLatency",  O(),applyLowLatency)
makeToggle(BoostPage,"PING / FPS / MEM  HUD",          "16149201252",    "hudVisible",  O(),function() updateHud() end)
makeToggle(BoostPage,"Réduire mises à jour visuelles", "15000801352",    "reduceVisual",O(),applyReduceVisual)
makeToggle(BoostPage,"Chargement progressif",          "12662723726",    "progLoad",    O(),applyProgLoad)
makeSection(BoostPage,"AVANCÉ",O())
makeButtonFixed(BoostPage,"Réinitialiser les paramètres","15000801352",    hex(55,55,75),O(),resetAll)
makeButtonFixed(BoostPage,"Optimisation auto",           "111935382692087",hex(55,55,75),O(),autoOptimize)

----------------------------------------------------
-- VISUALS PAGE
----------------------------------------------------
local VisualsPage=Pages["Visuals"]
local vo=0; local function VO() vo=vo+1; return vo end
local ICON_COLOR=C.primary; local ICON_SIZE=18

local function getCC()
    local cc=Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
    if not cc then cc=Instance.new("ColorCorrectionEffect",Lighting); cc.Enabled=true end; return cc
end
local function getBloom()
    local b=Lighting:FindFirstChildOfClass("BloomEffect")
    if not b then b=Instance.new("BloomEffect",Lighting); b.Enabled=false end; return b
end
local function getSunRays()
    local s=Lighting:FindFirstChildOfClass("SunRaysEffect")
    if not s then s=Instance.new("SunRaysEffect",Lighting); s.Enabled=false end; return s
end
local function getDOF()
    local d=Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
    if not d then d=Instance.new("DepthOfFieldEffect",Lighting); d.Enabled=false end; return d
end
local function getAtmo()
    local a=Lighting:FindFirstChildOfClass("Atmosphere")
    if not a then a=Instance.new("Atmosphere",Lighting) end; return a
end

local function vSection(label,order)
    local f=Instance.new("Frame",VisualsPage)
    f.Size=UDim2.new(1,0,0,20); f.BackgroundTransparency=1; f.LayoutOrder=order
    local l=Instance.new("TextLabel",f); l.Size=UDim2.new(1,0,1,0)
    l.BackgroundTransparency=1; l.FontFace=SILK; l.TextSize=9
    l.TextColor3=C.textSub; l.TextXAlignment=Enum.TextXAlignment.Left; l.Text=label
end

local function vToggle(label,iconId,order,initVal,onToggle)
    local card=Instance.new("Frame",VisualsPage)
    card.Size=UDim2.new(1,0,0,38); card.BackgroundColor3=C.card
    card.BorderSizePixel=0; card.LayoutOrder=order
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,7)
    Instance.new("UIStroke",card).Color=C.border
    local ico=Instance.new("ImageLabel",card)
    ico.Size=UDim2.fromOffset(ICON_SIZE,ICON_SIZE); ico.Position=UDim2.new(0,10,0.5,-ICON_SIZE/2)
    ico.BackgroundTransparency=1; ico.Image="rbxassetid://"..iconId
    ico.ImageColor3=ICON_COLOR; ico.ScaleType=Enum.ScaleType.Fit
    local lbl=Instance.new("TextLabel",card)
    lbl.Size=UDim2.new(1,-100,1,0); lbl.Position=UDim2.fromOffset(34,0)
    lbl.BackgroundTransparency=1; lbl.FontFace=SILK; lbl.TextSize=10
    lbl.TextColor3=C.text; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=label
    local state={on=initVal or false}
    local track=Instance.new("TextButton",card)
    track.Size=UDim2.fromOffset(42,22); track.Position=UDim2.new(1,-54,0.5,-11)
    track.BackgroundColor3=state.on and C.primary or C.surface
    track.BorderSizePixel=0; track.Text=""; track.AutoButtonColor=false
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
    Instance.new("UIStroke",track).Color=C.border
    local thumb=Instance.new("Frame",track)
    thumb.Size=UDim2.fromOffset(16,16)
    thumb.Position=state.on and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)
    thumb.BackgroundColor3=Color3.new(1,1,1); thumb.BorderSizePixel=0
    Instance.new("UICorner",thumb).CornerRadius=UDim.new(1,0)
    track.MouseButton1Click:Connect(function()
        state.on=not state.on
        TweenService:Create(track,TweenInfo.new(0.12),{BackgroundColor3=state.on and C.primary or C.surface}):Play()
        TweenService:Create(thumb,TweenInfo.new(0.12),{Position=state.on and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)}):Play()
        if onToggle then pcall(onToggle,state.on) end
        if getgenv().ShadowNotif then
            local c=state.on and Color3.fromRGB(34,197,94) or Color3.fromRGB(239,68,68)
            getgenv().ShadowNotif(label, state.on and "✓  Activé" or "✗  Désactivé", c)
        end
    end)
    return card,state
end

local function vSlider(label,iconId,order,minV,maxV,stepV,unit,initVal,onChange)
    local card=Instance.new("Frame",VisualsPage)
    card.Size=UDim2.new(1,0,0,52); card.BackgroundColor3=C.card
    card.BorderSizePixel=0; card.LayoutOrder=order
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,7)
    Instance.new("UIStroke",card).Color=C.border
    local ico=Instance.new("ImageLabel",card)
    ico.Size=UDim2.fromOffset(ICON_SIZE,ICON_SIZE); ico.Position=UDim2.fromOffset(10,8)
    ico.BackgroundTransparency=1; ico.Image="rbxassetid://"..iconId
    ico.ImageColor3=ICON_COLOR; ico.ScaleType=Enum.ScaleType.Fit
    local lbl=Instance.new("TextLabel",card)
    lbl.Size=UDim2.new(0.62,0,0,22); lbl.Position=UDim2.fromOffset(34,6)
    lbl.BackgroundTransparency=1; lbl.FontFace=SILK; lbl.TextSize=10
    lbl.TextColor3=C.text; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=label
    local val=initVal or minV
    local valLbl=Instance.new("TextLabel",card)
    valLbl.Size=UDim2.new(0.32,0,0,22); valLbl.Position=UDim2.new(0.66,0,0,6)
    valLbl.BackgroundTransparency=1; valLbl.FontFace=SILK; valLbl.TextSize=10
    valLbl.TextColor3=C.primary; valLbl.TextXAlignment=Enum.TextXAlignment.Right
    valLbl.Text=(unit=="H") and string.format("%02dH",val) or tostring(val)..unit
    local trackBg=Instance.new("Frame",card)
    trackBg.Size=UDim2.new(1,-24,0,6); trackBg.Position=UDim2.fromOffset(12,38)
    trackBg.BackgroundColor3=C.surface; trackBg.BorderSizePixel=0
    Instance.new("UICorner",trackBg).CornerRadius=UDim.new(1,0)
    local pct0=(val-minV)/(maxV-minV)
    local fill=Instance.new("Frame",trackBg); fill.BackgroundColor3=C.primary; fill.BorderSizePixel=0
    fill.Size=UDim2.new(pct0,0,1,0)
    Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
    local knob=Instance.new("Frame",trackBg); knob.Size=UDim2.fromOffset(14,14)
    knob.AnchorPoint=Vector2.new(0.5,0.5); knob.Position=UDim2.new(pct0,0,0.5,0)
    knob.BackgroundColor3=Color3.new(1,1,1); knob.BorderSizePixel=0
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
    local dragging=false
    local btn=Instance.new("TextButton",trackBg)
    btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.Text=""; btn.ZIndex=5
    local function setVal(absX)
        local rel=math.clamp((absX-trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X,0,1)
        local snapped=math.floor((minV+rel*(maxV-minV))/stepV+0.5)*stepV
        snapped=math.clamp(snapped,minV,maxV)
        local p=(snapped-minV)/(maxV-minV)
        fill.Size=UDim2.new(p,0,1,0); knob.Position=UDim2.new(p,0,0.5,0)
        valLbl.Text=(unit=="H") and string.format("%02dH",snapped) or tostring(snapped)..unit
        if onChange then pcall(onChange,snapped) end
    end
    btn.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; setVal(i.Position.X) end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then setVal(i.Position.X) end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
    end)
    return card
end

local function vColorPicker(label,iconId,order,initColor,onChange)
    local HUE_H=16; local PICK_H=140
    local card=Instance.new("Frame",VisualsPage)
    card.Size=UDim2.new(1,0,0,38); card.BackgroundColor3=C.card
    card.BorderSizePixel=0; card.LayoutOrder=order; card.ClipsDescendants=true
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,7)
    Instance.new("UIStroke",card).Color=C.border
    local ico=Instance.new("ImageLabel",card)
    ico.Size=UDim2.fromOffset(ICON_SIZE,ICON_SIZE); ico.Position=UDim2.fromOffset(10,10)
    ico.BackgroundTransparency=1; ico.Image="rbxassetid://"..iconId
    ico.ImageColor3=ICON_COLOR; ico.ScaleType=Enum.ScaleType.Fit
    local lbl=Instance.new("TextLabel",card)
    lbl.Size=UDim2.new(1,-110,0,38); lbl.Position=UDim2.fromOffset(34,0)
    lbl.BackgroundTransparency=1; lbl.FontFace=SILK; lbl.TextSize=10
    lbl.TextColor3=C.text; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=label
    local preview=Instance.new("Frame",card)
    preview.Size=UDim2.fromOffset(22,22); preview.Position=UDim2.new(1,-60,0,8)
    preview.BackgroundColor3=initColor or C.primary; preview.BorderSizePixel=0
    Instance.new("UICorner",preview).CornerRadius=UDim.new(0,4)
    Instance.new("UIStroke",preview).Color=C.border
    local expandBtn=Instance.new("TextButton",card)
    expandBtn.Size=UDim2.fromOffset(30,30); expandBtn.Position=UDim2.new(1,-32,0,4)
    expandBtn.BackgroundTransparency=1; expandBtn.FontFace=SILK; expandBtn.TextSize=14
    expandBtn.TextColor3=C.textDim; expandBtn.Text="▾"; expandBtn.AutoButtonColor=false
    local pickerZone=Instance.new("Frame",card)
    pickerZone.Size=UDim2.new(1,-16,0,PICK_H); pickerZone.Position=UDim2.fromOffset(8,42)
    pickerZone.BackgroundTransparency=1; pickerZone.Visible=false
    local hueBar=Instance.new("Frame",pickerZone)
    hueBar.Size=UDim2.new(1,0,0,HUE_H); hueBar.BackgroundTransparency=1; hueBar.ClipsDescendants=true
    Instance.new("UICorner",hueBar).CornerRadius=UDim.new(0,4)
    local hueColors={Color3.fromHSV(0,1,1),Color3.fromHSV(1/6,1,1),Color3.fromHSV(2/6,1,1),
        Color3.fromHSV(3/6,1,1),Color3.fromHSV(4/6,1,1),Color3.fromHSV(5/6,1,1),Color3.fromHSV(1,1,1)}
    for i=1,6 do
        local seg=Instance.new("Frame",hueBar)
        seg.Size=UDim2.new(1/6,1,1,0); seg.Position=UDim2.new((i-1)/6,0,0,0); seg.BorderSizePixel=0
        Instance.new("UIGradient",seg).Color=ColorSequence.new(hueColors[i],hueColors[i+1])
    end
    local hueCursor=Instance.new("Frame",hueBar)
    hueCursor.Size=UDim2.fromOffset(4,HUE_H+4); hueCursor.AnchorPoint=Vector2.new(0.5,0.5)
    hueCursor.Position=UDim2.new(0,0,0.5,0); hueCursor.BackgroundColor3=Color3.new(1,1,1)
    hueCursor.BorderSizePixel=0; hueCursor.ZIndex=3
    Instance.new("UICorner",hueCursor).CornerRadius=UDim.new(0,2)
    local svFrame=Instance.new("Frame",pickerZone)
    svFrame.Size=UDim2.fromOffset(100,100); svFrame.Position=UDim2.fromOffset(0,HUE_H+8)
    svFrame.BackgroundColor3=Color3.fromHSV(0,1,1); svFrame.BorderSizePixel=0
    Instance.new("UICorner",svFrame).CornerRadius=UDim.new(0,4)
    local whiteFade=Instance.new("Frame",svFrame)
    whiteFade.Size=UDim2.new(1,0,1,0); whiteFade.BackgroundTransparency=0; whiteFade.BorderSizePixel=0
    local wg=Instance.new("UIGradient",whiteFade)
    wg.Color=ColorSequence.new(Color3.new(1,1,1),Color3.new(1,1,1)); wg.Transparency=NumberSequence.new(0,1)
    local blackFade=Instance.new("Frame",svFrame)
    blackFade.Size=UDim2.new(1,0,1,0); blackFade.BackgroundTransparency=0; blackFade.BorderSizePixel=0; blackFade.ZIndex=2
    local bg2=Instance.new("UIGradient",blackFade)
    bg2.Color=ColorSequence.new(Color3.new(0,0,0),Color3.new(0,0,0))
    bg2.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)})
    bg2.Rotation=90
    local svCursor=Instance.new("Frame",svFrame)
    svCursor.Size=UDim2.fromOffset(10,10); svCursor.AnchorPoint=Vector2.new(0.5,0.5)
    svCursor.Position=UDim2.new(1,0,0,0); svCursor.BackgroundTransparency=1; svCursor.ZIndex=5
    Instance.new("UICorner",svCursor).CornerRadius=UDim.new(1,0)
    Instance.new("UIStroke",svCursor).Color=Color3.new(1,1,1)
    local H2,S2,V2=0,1,1
    if initColor then H2,S2,V2=initColor:ToHSV() end
    local function rebuildColor()
        local c=Color3.fromHSV(H2,S2,V2); preview.BackgroundColor3=c
        if onChange then pcall(onChange,c) end
    end
    local function updateSVBg() svFrame.BackgroundColor3=Color3.fromHSV(H2,1,1) end
    hueCursor.Position=UDim2.new(H2,0,0.5,0); svCursor.Position=UDim2.new(S2,0,1-V2,0); updateSVBg()
    local hueDragging=false
    local hueHit=Instance.new("TextButton",hueBar)
    hueHit.Size=UDim2.new(1,0,1,0); hueHit.BackgroundTransparency=1; hueHit.Text=""; hueHit.ZIndex=4
    local function setHue(absX)
        H2=math.clamp((absX-hueBar.AbsolutePosition.X)/hueBar.AbsoluteSize.X,0,0.9999)
        hueCursor.Position=UDim2.new(H2,0,0.5,0); updateSVBg(); rebuildColor()
    end
    hueHit.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then hueDragging=true; setHue(i.Position.X) end
    end)
    UIS.InputChanged:Connect(function(i)
        if hueDragging and i.UserInputType==Enum.UserInputType.MouseMovement then setHue(i.Position.X) end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then hueDragging=false end
    end)
    local svDragging=false
    local svHit=Instance.new("TextButton",svFrame)
    svHit.Size=UDim2.new(1,0,1,0); svHit.BackgroundTransparency=1; svHit.Text=""; svHit.ZIndex=6
    local function setSV(absX,absY)
        S2=math.clamp((absX-svFrame.AbsolutePosition.X)/svFrame.AbsoluteSize.X,0,1)
        V2=1-math.clamp((absY-svFrame.AbsolutePosition.Y)/svFrame.AbsoluteSize.Y,0,1)
        svCursor.Position=UDim2.new(S2,0,1-V2,0); rebuildColor()
    end
    svHit.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then svDragging=true; setSV(i.Position.X,i.Position.Y) end
    end)
    UIS.InputChanged:Connect(function(i)
        if svDragging and i.UserInputType==Enum.UserInputType.MouseMovement then setSV(i.Position.X,i.Position.Y) end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then svDragging=false end
    end)
    local expanded=false
    expandBtn.MouseButton1Click:Connect(function()
        expanded=not expanded; expandBtn.Text=expanded and "▴" or "▾"
        TweenService:Create(card,TweenInfo.new(0.15),{Size=UDim2.new(1,0,0,expanded and (42+PICK_H+8) or 38)}):Play()
        pickerZone.Visible=expanded
    end)
    return card
end

local function vDropdown(label,iconId,order,presets,initIdx,onSelect)
    local ITEM_H=30; local MAX_VISIBLE=5
    local card=Instance.new("Frame",VisualsPage)
    card.Size=UDim2.new(1,0,0,40); card.BackgroundColor3=C.card
    card.BorderSizePixel=0; card.LayoutOrder=order; card.ClipsDescendants=false
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,7)
    Instance.new("UIStroke",card).Color=C.border
    local ico=Instance.new("ImageLabel",card)
    ico.Size=UDim2.fromOffset(ICON_SIZE,ICON_SIZE); ico.Position=UDim2.new(0,10,0.5,-ICON_SIZE/2)
    ico.BackgroundTransparency=1; ico.Image="rbxassetid://"..iconId
    ico.ImageColor3=ICON_COLOR; ico.ScaleType=Enum.ScaleType.Fit
    local nameLbl=Instance.new("TextLabel",card)
    nameLbl.Size=UDim2.fromOffset(90,40); nameLbl.Position=UDim2.fromOffset(34,0)
    nameLbl.BackgroundTransparency=1; nameLbl.FontFace=SILK; nameLbl.TextSize=9
    nameLbl.TextColor3=C.textDim; nameLbl.TextXAlignment=Enum.TextXAlignment.Left
    nameLbl.Text=label:upper()
    local selBtn=Instance.new("TextButton",card)
    selBtn.Size=UDim2.new(1,-130,1,0); selBtn.Position=UDim2.fromOffset(128,0)
    selBtn.BackgroundColor3=C.surface; selBtn.BorderSizePixel=0
    selBtn.Text=""; selBtn.AutoButtonColor=false
    Instance.new("UICorner",selBtn).CornerRadius=UDim.new(0,5)
    Instance.new("UIStroke",selBtn).Color=C.border
    local selLbl=Instance.new("TextLabel",selBtn)
    selLbl.Size=UDim2.new(1,-30,1,0); selLbl.Position=UDim2.fromOffset(10,0)
    selLbl.BackgroundTransparency=1; selLbl.FontFace=SILK; selLbl.TextSize=10
    selLbl.TextColor3=C.text; selLbl.TextXAlignment=Enum.TextXAlignment.Left
    selLbl.Text=presets[initIdx].name
    local chevLbl=Instance.new("TextLabel",selBtn)
    chevLbl.Size=UDim2.fromOffset(24,40); chevLbl.Position=UDim2.new(1,-24,0,0)
    chevLbl.BackgroundTransparency=1; chevLbl.FontFace=SILK; chevLbl.TextSize=12
    chevLbl.TextColor3=C.textDim; chevLbl.Text="▾"
    local visibleCount=math.min(#presets,MAX_VISIBLE)
    local dropList=Instance.new("Frame",card)
    dropList.Size=UDim2.new(1,-128,0,visibleCount*ITEM_H)
    dropList.Position=UDim2.new(0,128,1,4)
    dropList.BackgroundColor3=Color3.fromRGB(22,22,28)
    dropList.BorderSizePixel=0; dropList.ZIndex=30; dropList.Visible=false
    dropList.ClipsDescendants=true
    Instance.new("UICorner",dropList).CornerRadius=UDim.new(0,6)
    local dropStroke=Instance.new("UIStroke",dropList)
    dropStroke.Color=C.primary; dropStroke.Thickness=1
    local dropScroll=Instance.new("ScrollingFrame",dropList)
    dropScroll.Size=UDim2.new(1,0,1,0); dropScroll.BackgroundTransparency=1
    dropScroll.BorderSizePixel=0; dropScroll.ScrollBarThickness=3
    dropScroll.ScrollBarImageColor3=C.primary; dropScroll.ZIndex=31
    dropScroll.CanvasSize=UDim2.new(0,0,0,#presets*ITEM_H)
    local dropLL=Instance.new("UIListLayout",dropScroll)
    dropLL.SortOrder=Enum.SortOrder.LayoutOrder; dropLL.Padding=UDim.new(0,0)
    local currentIdx=initIdx; local isOpen=false
    local function closeDD()
        isOpen=false; dropList.Visible=false; chevLbl.Text="▾"
        TweenService:Create(selBtn,TweenInfo.new(0.08),{BackgroundColor3=C.surface}):Play()
    end
    for i,preset in ipairs(presets) do
        local item=Instance.new("TextButton",dropScroll)
        item.Size=UDim2.new(1,0,0,ITEM_H); item.BackgroundColor3=Color3.fromRGB(22,22,28)
        item.BorderSizePixel=0; item.Text=""; item.AutoButtonColor=false
        item.ZIndex=32; item.LayoutOrder=i
        local bar=Instance.new("Frame",item)
        bar.Size=UDim2.fromOffset(3,ITEM_H-8); bar.Position=UDim2.new(0,0,0.5,-((ITEM_H-8)/2))
        bar.BackgroundColor3=C.primary; bar.BorderSizePixel=0; bar.ZIndex=33
        Instance.new("UICorner",bar).CornerRadius=UDim.new(0,2); bar.Visible=(i==currentIdx)
        local itemLbl=Instance.new("TextLabel",item)
        itemLbl.Size=UDim2.new(1,-16,1,0); itemLbl.Position=UDim2.fromOffset(12,0)
        itemLbl.BackgroundTransparency=1; itemLbl.FontFace=SILK; itemLbl.TextSize=10
        itemLbl.TextColor3=i==currentIdx and C.primary or C.textDim
        itemLbl.TextXAlignment=Enum.TextXAlignment.Left; itemLbl.Text=preset.name; itemLbl.ZIndex=33
        item.MouseEnter:Connect(function()
            if i~=currentIdx then
                TweenService:Create(item,TweenInfo.new(0.06),{BackgroundColor3=Color3.fromRGB(32,32,42)}):Play()
                itemLbl.TextColor3=C.text
            end
        end)
        item.MouseLeave:Connect(function()
            if i~=currentIdx then
                TweenService:Create(item,TweenInfo.new(0.06),{BackgroundColor3=Color3.fromRGB(22,22,28)}):Play()
                itemLbl.TextColor3=C.textDim
            end
        end)
        item.MouseButton1Click:Connect(function()
            for _,c in ipairs(dropScroll:GetChildren()) do
                if c:IsA("TextButton") then
                    c.BackgroundColor3=Color3.fromRGB(22,22,28)
                    local cl=c:FindFirstChildOfClass("TextLabel"); local cb=c:FindFirstChildOfClass("Frame")
                    if cl then cl.TextColor3=C.textDim end; if cb then cb.Visible=false end
                end
            end
            currentIdx=i; bar.Visible=true; itemLbl.TextColor3=C.primary
            item.BackgroundColor3=Color3.fromRGB(30,28,45); selLbl.Text=preset.name; closeDD()
            if onSelect then pcall(onSelect,i,preset) end
        end)
    end
    selBtn.MouseButton1Click:Connect(function()
        isOpen=not isOpen; dropList.Visible=isOpen; chevLbl.Text=isOpen and "▴" or "▾"
        if isOpen then TweenService:Create(selBtn,TweenInfo.new(0.08),{BackgroundColor3=C.surfaceHov}):Play() end
    end)
    return card
end

-- ASPECT RATIO
local StretchFactor=1; local stretchConn=nil; local fovPersistConn=nil
local customFOVActive=false; local customFOVValue=80

local function activateFOVPersist(v)
    customFOVValue=v; customFOVActive=true
    if fovPersistConn then fovPersistConn:Disconnect() end
    fovPersistConn=RunService.RenderStepped:Connect(function()
        if not customFOVActive then return end
        pcall(function()
            local cam=Workspace.CurrentCamera
            if cam and math.abs(cam.FieldOfView-customFOVValue)>0.5 then cam.FieldOfView=customFOVValue end
        end)
    end)
end

local function applyAspectRatioReal(factor,fov)
    if stretchConn then stretchConn:Disconnect(); stretchConn=nil end
    StretchFactor=factor
    if fov then activateFOVPersist(fov) end
    if factor==1 then return end
    stretchConn=RunService.RenderStepped:Connect(function()
        pcall(function()
            local cam2=Workspace.CurrentCamera; if not cam2 then return end
            if cam2.CameraType~=Enum.CameraType.Custom and cam2.CameraType~=Enum.CameraType.Scriptable then return end
            local cf=cam2.CFrame; local pos=cf.Position
            local look=cf.LookVector; local up=cf.UpVector; local right=cf.RightVector.Unit
            cam2.CFrame=CFrame.fromMatrix(pos,right*StretchFactor,up,-look)
        end)
    end)
end

local ASPECT_PRESETS={
    {name="16:9  (Défaut)",         factor=1,    fov=80},
    {name="4:3   STRETCH  léger",   factor=1.20, fov=78},
    {name="4:3   STRETCH  normal",  factor=1.45, fov=75},
    {name="4:3   STRETCH  fort",    factor=1.80, fov=72},
    {name="4:3   STRETCH  extrême", factor=2.30, fov=68},
    {name="WIDE  STRETCH",          factor=2.80, fov=63},
    {name="ULTRA WIDE",             factor=3.50, fov=58},
}
local RESOLUTION_PRESETS={
    {name="100%  (Max)",level=10},{name="75%",level=8},
    {name="50%",level=5},{name="25%  (Min)",level=1},
}

-- CROSSHAIR
local CrosshairGui=Instance.new("ScreenGui",_GUI_ROOT)
CrosshairGui.Name="ShadowCrosshairV2"; CrosshairGui.DisplayOrder=1001
CrosshairGui.IgnoreGuiInset=true; CrosshairGui.ResetOnSpawn=false

local CrossImg=Instance.new("ImageLabel",CrosshairGui)
CrossImg.AnchorPoint=Vector2.new(0.5,0.5); CrossImg.BackgroundTransparency=1
CrossImg.ScaleType=Enum.ScaleType.Fit; CrossImg.ZIndex=1001
CrossImg.Visible=false; CrossImg.Position=UDim2.new(0.5,0,0.5,0)

local CROSSHAIR_PRESETS={
    {name="Defaut  (Rivals)",id="",           size=0,   color=Color3.new(1,1,1)},
    {name="Cross",           id="12472538419",size=200, color=Color3.new(1,1,1)},
    {name="Point",           id="10213989924",size=160, color=Color3.new(1,0,0)},
    {name="Coeur  (Violet)", id="10878218308",size=52,  color=Color3.fromRGB(139,92,246)},
    {name="Kirby",           id="11988231127",size=48,  color=Color3.new(1,1,1)},
}

local rivalsCrosshairParts={}
local function hideRivalsCrosshair(hide)
    if hide then
        rivalsCrosshairParts={}
        local pgui=Player:FindFirstChildOfClass("PlayerGui"); if not pgui then return end
        for _,desc in ipairs(pgui:GetDescendants()) do
            if desc:IsA("ImageLabel") or desc:IsA("ImageButton") or desc:IsA("Frame") then
                local name=desc.Name:lower()
                local isCrossName=name:find("cross") or name:find("aim") or name:find("reticle")
                    or name:find("dot") or name:find("cursor") or name:find("sight")
                    or name:find("hit") or name:find("center")
                local isCrossPos=false
                pcall(function()
                    local pos=desc.AbsolutePosition; local size=desc.AbsoluteSize
                    local screenSize=game:GetService("GuiService"):GetScreenResolution()
                    local elemCX=pos.X+size.X/2; local elemCY=pos.Y+size.Y/2
                    if math.abs(elemCX-screenSize.X/2)<80 and math.abs(elemCY-screenSize.Y/2)<80
                       and size.X<120 and size.Y<120 and size.X>2 then isCrossPos=true end
                end)
                if isCrossName or isCrossPos then
                    local wasVisible=desc.Visible
                    if wasVisible then
                        table.insert(rivalsCrosshairParts,{obj=desc,vis=wasVisible})
                        pcall(function() desc.Visible=false end)
                    end
                end
            end
        end
    else
        for _,entry in ipairs(rivalsCrosshairParts) do pcall(function() entry.obj.Visible=entry.vis end) end
        rivalsCrosshairParts={}
    end
end

local function applyCrosshair(idx,preset)
    if idx==1 or preset.id=="" then CrossImg.Visible=false; hideRivalsCrosshair(false); return end
    CrossImg.Image="rbxassetid://"..preset.id; CrossImg.ImageColor3=preset.color
    CrossImg.Size=UDim2.fromOffset(preset.size,preset.size); CrossImg.Visible=true
    task.delay(0.5,function() hideRivalsCrosshair(true) end)
    task.spawn(function()
        while CrossImg.Visible do task.wait(1); hideRivalsCrosshair(true) end
    end)
end

-- SKY
local defaultSkyProps=nil
local function saveSky()
    if defaultSkyProps then return end
    local sky=Lighting:FindFirstChildOfClass("Sky")
    if sky then
        defaultSkyProps={
            SkyboxBk=sky.SkyboxBk,SkyboxDn=sky.SkyboxDn,SkyboxFt=sky.SkyboxFt,
            SkyboxLf=sky.SkyboxLf,SkyboxRt=sky.SkyboxRt,SkyboxUp=sky.SkyboxUp,
            SunAngularSize=sky.SunAngularSize,MoonAngularSize=sky.MoonAngularSize,
            CelestialBodiesShown=sky.CelestialBodiesShown,
        }
    else defaultSkyProps=false end
end
local function getSky()
    local sky=Lighting:FindFirstChildOfClass("Sky")
    if not sky then sky=Instance.new("Sky",Lighting) end; return sky
end

local SKY_PRESETS={
    {name="Default",apply=function()
        if defaultSkyProps==false then local s=Lighting:FindFirstChildOfClass("Sky"); if s then s:Destroy() end
        elseif defaultSkyProps then local s=getSky(); for k,v in pairs(defaultSkyProps) do pcall(function() s[k]=v end) end end
    end},
    {name="Blue",apply=function() saveSky(); local s=getSky(); pcall(function()
        s.SkyboxBk="rbxassetid://159451206";s.SkyboxDn="rbxassetid://159451206";s.SkyboxFt="rbxassetid://159451206"
        s.SkyboxLf="rbxassetid://159451206";s.SkyboxRt="rbxassetid://159451206";s.SkyboxUp="rbxassetid://159451206"
        s.CelestialBodiesShown=true;Lighting.ClockTime=12 end) end},
    {name="Chill Pink",apply=function() saveSky(); local s=getSky(); pcall(function()
        s.SkyboxBk="rbxassetid://2523547718";s.SkyboxDn="rbxassetid://2523547718";s.SkyboxFt="rbxassetid://2523547718"
        s.SkyboxLf="rbxassetid://2523547718";s.SkyboxRt="rbxassetid://2523547718";s.SkyboxUp="rbxassetid://2523547718"
        s.CelestialBodiesShown=false;Lighting.ClockTime=15 end) end},
    {name="Hades",apply=function() saveSky(); local s=getSky(); pcall(function()
        s.SkyboxBk="rbxassetid://6444320789";s.SkyboxDn="rbxassetid://6444320789";s.SkyboxFt="rbxassetid://6444320789"
        s.SkyboxLf="rbxassetid://6444320789";s.SkyboxRt="rbxassetid://6444320789";s.SkyboxUp="rbxassetid://6444320789"
        s.CelestialBodiesShown=false;Lighting.ClockTime=0 end) end},
    {name="NeonSky",apply=function() saveSky(); local s=getSky(); pcall(function()
        s.SkyboxBk="rbxassetid://4882433404";s.SkyboxDn="rbxassetid://4882433404";s.SkyboxFt="rbxassetid://4882433404"
        s.SkyboxLf="rbxassetid://4882433404";s.SkyboxRt="rbxassetid://4882433404";s.SkyboxUp="rbxassetid://4882433404"
        s.CelestialBodiesShown=false;Lighting.ClockTime=0 end) end},
    {name="Night",apply=function() saveSky(); local s=getSky(); pcall(function()
        s.SkyboxBk="rbxassetid://159452023";s.SkyboxDn="rbxassetid://159452023";s.SkyboxFt="rbxassetid://159452023"
        s.SkyboxLf="rbxassetid://159452023";s.SkyboxRt="rbxassetid://159452023";s.SkyboxUp="rbxassetid://159452023"
        s.CelestialBodiesShown=true;Lighting.ClockTime=0 end) end},
    {name="Orange",apply=function() saveSky(); local s=getSky(); pcall(function()
        s.SkyboxBk="rbxassetid://159451884";s.SkyboxDn="rbxassetid://159451884";s.SkyboxFt="rbxassetid://159451884"
        s.SkyboxLf="rbxassetid://159451884";s.SkyboxRt="rbxassetid://159451884";s.SkyboxUp="rbxassetid://159451884"
        s.CelestialBodiesShown=true;Lighting.ClockTime=18 end) end},
    {name="Pink Sunrise",apply=function() saveSky(); local s=getSky(); pcall(function()
        s.SkyboxBk="rbxassetid://1040609252";s.SkyboxDn="rbxassetid://1040609252";s.SkyboxFt="rbxassetid://1040609252"
        s.SkyboxLf="rbxassetid://1040609252";s.SkyboxRt="rbxassetid://1040609252";s.SkyboxUp="rbxassetid://1040609252"
        s.CelestialBodiesShown=false;Lighting.ClockTime=6 end) end},
    {name="Red",apply=function() saveSky(); local s=getSky(); pcall(function()
        s.SkyboxBk="rbxassetid://159451889";s.SkyboxDn="rbxassetid://159451889";s.SkyboxFt="rbxassetid://159451889"
        s.SkyboxLf="rbxassetid://159451889";s.SkyboxRt="rbxassetid://159451889";s.SkyboxUp="rbxassetid://159451889"
        s.CelestialBodiesShown=false;Lighting.ClockTime=0 end) end},
    {name="Spooky",apply=function() saveSky(); local s=getSky(); pcall(function()
        s.SkyboxBk="rbxassetid://6506234505";s.SkyboxDn="rbxassetid://6506234505";s.SkyboxFt="rbxassetid://6506234505"
        s.SkyboxLf="rbxassetid://6506234505";s.SkyboxRt="rbxassetid://6506234505";s.SkyboxUp="rbxassetid://6506234505"
        s.CelestialBodiesShown=true;Lighting.ClockTime=0 end) end},
    {name="Overcast",apply=function() saveSky(); local s=getSky(); pcall(function()
        s.SkyboxBk="rbxassetid://159451993";s.SkyboxDn="rbxassetid://159451993";s.SkyboxFt="rbxassetid://159451993"
        s.SkyboxLf="rbxassetid://159451993";s.SkyboxRt="rbxassetid://159451993";s.SkyboxUp="rbxassetid://159451993"
        s.CelestialBodiesShown=false;Lighting.ClockTime=12 end) end},
    {name="Anime - Sakura",apply=function() saveSky(); local s=getSky(); pcall(function()
        s.SkyboxBk="rbxassetid://11612932444";s.SkyboxDn="rbxassetid://11612932444";s.SkyboxFt="rbxassetid://11612932444"
        s.SkyboxLf="rbxassetid://11612932444";s.SkyboxRt="rbxassetid://11612932444";s.SkyboxUp="rbxassetid://11612932444"
        s.CelestialBodiesShown=false;Lighting.ClockTime=10 end) end},
    {name="Anime - Galaxy",apply=function() saveSky(); local s=getSky(); pcall(function()
        s.SkyboxBk="rbxassetid://5801990361";s.SkyboxDn="rbxassetid://5801990361";s.SkyboxFt="rbxassetid://5801990361"
        s.SkyboxLf="rbxassetid://5801990361";s.SkyboxRt="rbxassetid://5801990361";s.SkyboxUp="rbxassetid://5801990361"
        s.CelestialBodiesShown=false;Lighting.ClockTime=0 end) end},
    {name="Anime - Heaven",apply=function() saveSky(); local s=getSky(); pcall(function()
        s.SkyboxBk="rbxassetid://129440489756809";s.SkyboxDn="rbxassetid://129440489756809";s.SkyboxFt="rbxassetid://129440489756809"
        s.SkyboxLf="rbxassetid://129440489756809";s.SkyboxRt="rbxassetid://129440489756809";s.SkyboxUp="rbxassetid://129440489756809"
        s.CelestialBodiesShown=false;Lighting.ClockTime=14 end) end},
}
local skyDropPresets={}
for _,p in ipairs(SKY_PRESETS) do table.insert(skyDropPresets,{name=p.name}) end

-- SHADERS
local function applyShaders(on)
    pcall(function() Lighting.Technology=on and Enum.Technology.Future or Enum.Technology.ShadowMap end)
    getBloom().Enabled=on
    if on then local b=getBloom(); b.Intensity=0.4;b.Size=24;b.Threshold=0.95 end
    getSunRays().Enabled=on
    if on then local s=getSunRays(); s.Intensity=0.15;s.Spread=0.08 end
    local cc=getCC(); cc.Enabled=true
    if on then cc.Brightness=0.04;cc.Contrast=0.12;cc.Saturation=0.15;cc.TintColor=hex(255,248,240)
    else cc.Brightness=0;cc.Contrast=0;cc.Saturation=0;cc.TintColor=Color3.new(1,1,1) end
    local atmo=getAtmo()
    if on then atmo.Density=0.35;atmo.Offset=0.15;atmo.Glare=0.1;atmo.Haze=0.6
    else atmo.Density=0.395;atmo.Offset=0;atmo.Glare=0;atmo.Haze=0 end
    pcall(function()
        Lighting.Ambient=on and hex(80,80,100) or hex(70,70,70)
        Lighting.OutdoorAmbient=on and hex(140,150,170) or hex(120,120,120)
        Lighting.Brightness=on and 2.2 or 2;Lighting.ShadowSoftness=on and 0.25 or 0.2
    end)
end

local function applyRayTracing(on)
    pcall(function() Lighting.Technology=on and Enum.Technology.Future or Enum.Technology.ShadowMap end)
    getBloom().Enabled=on
    if on then local b=getBloom(); b.Intensity=0.65;b.Size=32;b.Threshold=0.82 end
    getSunRays().Enabled=on
    if on then local s=getSunRays(); s.Intensity=0.28;s.Spread=0.13 end
    getDOF().Enabled=on
    if on then local d=getDOF(); d.FarIntensity=0.22;d.NearIntensity=0;d.FocusDistance=50;d.InFocusRadius=20 end
    local cc=getCC(); cc.Enabled=true
    if on then cc.Brightness=0.06;cc.Contrast=0.2;cc.Saturation=0.28;cc.TintColor=hex(255,250,245)
    else cc.Brightness=0;cc.Contrast=0;cc.Saturation=0;cc.TintColor=Color3.new(1,1,1) end
    local atmo=getAtmo()
    if on then atmo.Density=0.42;atmo.Offset=0.26;atmo.Glare=0.28;atmo.Haze=1.3 end
    pcall(function()
        Lighting.Ambient=on and hex(55,60,78) or hex(70,70,70)
        Lighting.OutdoorAmbient=on and hex(148,158,178) or hex(120,120,120)
        Lighting.Brightness=on and 2.9 or 2;Lighting.ShadowSoftness=on and 0.45 or 0.2
        Lighting.EnvironmentDiffuseScale=on and 0.65 or 0.4
        Lighting.EnvironmentSpecularScale=on and 0.85 or 0.4
    end)
end

-- Dark texture
local darkColor2=Color3.fromRGB(30,35,38); local darkBase2=Color3.fromRGB(151,153,163); local darkConn2=nil
local function isClose2(c1,c2,t)
    t=(t or 10)/255
    return math.abs(c1.R-c2.R)<t and math.abs(c1.G-c2.G)<t and math.abs(c1.B-c2.B)<t
end
local function applyDarkTexture(on)
    if on then
        for _,v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Part") and isClose2(v.Color,darkBase2) then pcall(function() v.Color=darkColor2 end) end
        end
        if darkConn2 then darkConn2:Disconnect() end
        darkConn2=Workspace.DescendantAdded:Connect(function(d)
            if d:IsA("Part") and isClose2(d.Color,darkBase2) then pcall(function() d.Color=darkColor2 end) end
        end)
    else
        if darkConn2 then darkConn2:Disconnect(); darkConn2=nil end
        for _,v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Part") and isClose2(v.Color,darkColor2) then pcall(function() v.Color=darkBase2 end) end
        end
    end
end

local FilterGui2=Instance.new("ScreenGui",_GUI_ROOT)
FilterGui2.Name="ShadowFilter2"; FilterGui2.DisplayOrder=2; FilterGui2.ResetOnSpawn=false; FilterGui2.IgnoreGuiInset=true
local FilterFrame2=Instance.new("Frame",FilterGui2)
FilterFrame2.Size=UDim2.new(1,0,1,0); FilterFrame2.BackgroundColor3=hex(255,50,50)
FilterFrame2.BackgroundTransparency=0.82; FilterFrame2.BorderSizePixel=0; FilterFrame2.Visible=false
local filterActive2=false

-- BUILD VISUALS PAGE
vSection("AFFICHAGE",VO())
vDropdown("Aspect Ratio","12684119225",VO(),ASPECT_PRESETS,1,function(idx,preset)
    applyAspectRatioReal(preset.factor,preset.fov)
end)

do
    local sc=Instance.new("Frame",VisualsPage)
    sc.Size=UDim2.new(1,0,0,52); sc.BackgroundColor3=C.card; sc.BorderSizePixel=0; sc.LayoutOrder=VO()
    Instance.new("UICorner",sc).CornerRadius=UDim.new(0,7); Instance.new("UIStroke",sc).Color=C.border
    local ico=Instance.new("ImageLabel",sc); ico.Size=UDim2.fromOffset(18,18); ico.Position=UDim2.fromOffset(10,8)
    ico.BackgroundTransparency=1; ico.Image="rbxassetid://12684119225"; ico.ImageColor3=C.primary; ico.ScaleType=Enum.ScaleType.Fit
    local lbl=Instance.new("TextLabel",sc); lbl.Size=UDim2.new(0.62,0,0,22); lbl.Position=UDim2.fromOffset(34,6)
    lbl.BackgroundTransparency=1; lbl.FontFace=SILK; lbl.TextSize=10
    lbl.TextColor3=C.text; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text="Stretch personnalisé"
    local valLbl=Instance.new("TextLabel",sc); valLbl.Size=UDim2.new(0.32,0,0,22); valLbl.Position=UDim2.new(0.66,0,0,6)
    valLbl.BackgroundTransparency=1; valLbl.FontFace=SILK; valLbl.TextSize=10
    valLbl.TextColor3=C.primary; valLbl.TextXAlignment=Enum.TextXAlignment.Right; valLbl.Text="1.0x"
    local trackBg=Instance.new("Frame",sc); trackBg.Size=UDim2.new(1,-24,0,6); trackBg.Position=UDim2.fromOffset(12,38)
    trackBg.BackgroundColor3=C.surface; trackBg.BorderSizePixel=0; Instance.new("UICorner",trackBg).CornerRadius=UDim.new(1,0)
    local fill=Instance.new("Frame",trackBg); fill.BackgroundColor3=C.primary; fill.BorderSizePixel=0; fill.Size=UDim2.new(0,0,1,0)
    Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
    local knob=Instance.new("Frame",trackBg); knob.Size=UDim2.fromOffset(14,14)
    knob.AnchorPoint=Vector2.new(0.5,0.5); knob.Position=UDim2.new(0,0,0.5,0)
    knob.BackgroundColor3=Color3.new(1,1,1); knob.BorderSizePixel=0; Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
    local dragging=false
    local btn2=Instance.new("TextButton",trackBg); btn2.Size=UDim2.new(1,0,1,0); btn2.BackgroundTransparency=1; btn2.Text=""; btn2.ZIndex=5
    local function setStretchVal(absX)
        local rel=math.clamp((absX-trackBg.AbsolutePosition.X)/trackBg.AbsoluteSize.X,0,1)
        local realFactor=1+rel*2.5; fill.Size=UDim2.new(rel,0,1,0); knob.Position=UDim2.new(rel,0,0.5,0)
        valLbl.Text=string.format("%.1fx",1+rel*14)
        if stretchConn then stretchConn:Disconnect(); stretchConn=nil end
        StretchFactor=realFactor
        if realFactor>1.01 then
            stretchConn=RunService.RenderStepped:Connect(function()
                pcall(function()
                    local cam2=Workspace.CurrentCamera; if not cam2 then return end
                    local cf=cam2.CFrame; local right=cf.RightVector.Unit
                    cam2.CFrame=CFrame.fromMatrix(cf.Position,right*StretchFactor,cf.UpVector,-cf.LookVector)
                end)
            end)
        end
    end
    btn2.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; setStretchVal(i.Position.X) end end)
    UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then setStretchVal(i.Position.X) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
end

vDropdown("Résolution","12684119225",VO(),RESOLUTION_PRESETS,1,function(idx,preset)
    pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end)
    task.wait(0.1); pcall(function() settings().Rendering.QualityLevel=preset.level end)
end)
vSlider("Custom FOV","15875255096",VO(),50,120,1,"°",80,function(v) activateFOVPersist(v) end)

vSection("CROSSHAIR",VO())
do
    local ITEM_H=30; local MAX_VISIBLE=5
    local chCard=Instance.new("Frame",VisualsPage)
    chCard.Size=UDim2.new(1,0,0,40); chCard.BackgroundColor3=C.card
    chCard.BorderSizePixel=0; chCard.LayoutOrder=VO(); chCard.ClipsDescendants=false
    Instance.new("UICorner",chCard).CornerRadius=UDim.new(0,7); Instance.new("UIStroke",chCard).Color=C.border
    local ico2=Instance.new("ImageLabel",chCard); ico2.Size=UDim2.fromOffset(18,18); ico2.Position=UDim2.new(0,10,0.5,-9)
    ico2.BackgroundTransparency=1; ico2.Image="rbxassetid://8440390034"; ico2.ImageColor3=C.primary; ico2.ScaleType=Enum.ScaleType.Fit
    local nameLbl2=Instance.new("TextLabel",chCard); nameLbl2.Size=UDim2.fromOffset(90,40); nameLbl2.Position=UDim2.fromOffset(34,0)
    nameLbl2.BackgroundTransparency=1; nameLbl2.FontFace=SILK; nameLbl2.TextSize=9
    nameLbl2.TextColor3=C.textDim; nameLbl2.TextXAlignment=Enum.TextXAlignment.Left; nameLbl2.Text="CROSSHAIR"
    local selBtn2=Instance.new("TextButton",chCard); selBtn2.Size=UDim2.new(1,-130,1,0); selBtn2.Position=UDim2.fromOffset(128,0)
    selBtn2.BackgroundColor3=C.surface; selBtn2.BorderSizePixel=0; selBtn2.Text=""; selBtn2.AutoButtonColor=false
    Instance.new("UICorner",selBtn2).CornerRadius=UDim.new(0,5); Instance.new("UIStroke",selBtn2).Color=C.border
    local previewIco=Instance.new("ImageLabel",selBtn2); previewIco.Size=UDim2.fromOffset(20,20); previewIco.Position=UDim2.new(0,6,0.5,-10)
    previewIco.BackgroundTransparency=1; previewIco.ScaleType=Enum.ScaleType.Fit; previewIco.Image=""
    local selLbl2=Instance.new("TextLabel",selBtn2); selLbl2.Size=UDim2.new(1,-58,1,0); selLbl2.Position=UDim2.fromOffset(30,0)
    selLbl2.BackgroundTransparency=1; selLbl2.FontFace=SILK; selLbl2.TextSize=10
    selLbl2.TextColor3=C.text; selLbl2.TextXAlignment=Enum.TextXAlignment.Left; selLbl2.Text=CROSSHAIR_PRESETS[1].name
    local chevLbl2=Instance.new("TextLabel",selBtn2); chevLbl2.Size=UDim2.fromOffset(24,40); chevLbl2.Position=UDim2.new(1,-24,0,0)
    chevLbl2.BackgroundTransparency=1; chevLbl2.FontFace=SILK; chevLbl2.TextSize=12; chevLbl2.TextColor3=C.textDim; chevLbl2.Text="▾"
    local visCount2=math.min(#CROSSHAIR_PRESETS,MAX_VISIBLE)
    local dropList2=Instance.new("Frame",chCard); dropList2.Size=UDim2.new(1,-128,0,visCount2*ITEM_H)
    dropList2.Position=UDim2.new(0,128,1,4); dropList2.BackgroundColor3=Color3.fromRGB(22,22,28)
    dropList2.BorderSizePixel=0; dropList2.ZIndex=30; dropList2.Visible=false; dropList2.ClipsDescendants=true
    Instance.new("UICorner",dropList2).CornerRadius=UDim.new(0,6)
    local ds2=Instance.new("UIStroke",dropList2); ds2.Color=C.primary; ds2.Thickness=1
    local dropScroll2=Instance.new("ScrollingFrame",dropList2); dropScroll2.Size=UDim2.new(1,0,1,0)
    dropScroll2.BackgroundTransparency=1; dropScroll2.BorderSizePixel=0; dropScroll2.ScrollBarThickness=3
    dropScroll2.ScrollBarImageColor3=C.primary; dropScroll2.ZIndex=31; dropScroll2.CanvasSize=UDim2.new(0,0,0,#CROSSHAIR_PRESETS*ITEM_H)
    local dropLL2=Instance.new("UIListLayout",dropScroll2); dropLL2.SortOrder=Enum.SortOrder.LayoutOrder; dropLL2.Padding=UDim.new(0,0)
    local curIdx2=1; local isOpen2=false
    local function closeDD2()
        isOpen2=false; dropList2.Visible=false; chevLbl2.Text="▾"
        TweenService:Create(selBtn2,TweenInfo.new(0.08),{BackgroundColor3=C.surface}):Play()
    end
    for i,preset in ipairs(CROSSHAIR_PRESETS) do
        local item=Instance.new("TextButton",dropScroll2); item.Size=UDim2.new(1,0,0,ITEM_H)
        item.BackgroundColor3=Color3.fromRGB(22,22,28); item.BorderSizePixel=0; item.Text=""
        item.AutoButtonColor=false; item.ZIndex=32; item.LayoutOrder=i
        local bar2=Instance.new("Frame",item); bar2.Size=UDim2.fromOffset(3,ITEM_H-8)
        bar2.Position=UDim2.new(0,0,0.5,-((ITEM_H-8)/2)); bar2.BackgroundColor3=C.primary
        bar2.BorderSizePixel=0; bar2.ZIndex=33; Instance.new("UICorner",bar2).CornerRadius=UDim.new(0,2); bar2.Visible=(i==1)
        if preset.id~="" then
            local ico3=Instance.new("ImageLabel",item); ico3.Size=UDim2.fromOffset(18,18); ico3.Position=UDim2.new(0,8,0.5,-9)
            ico3.BackgroundTransparency=1; ico3.Image="rbxassetid://"..preset.id
            ico3.ImageColor3=preset.color; ico3.ScaleType=Enum.ScaleType.Fit; ico3.ZIndex=33
        end
        local itemLbl2=Instance.new("TextLabel",item); itemLbl2.Size=UDim2.new(1,-36,1,0); itemLbl2.Position=UDim2.fromOffset(30,0)
        itemLbl2.BackgroundTransparency=1; itemLbl2.FontFace=SILK; itemLbl2.TextSize=10
        itemLbl2.TextColor3=i==1 and C.primary or C.textDim
        itemLbl2.TextXAlignment=Enum.TextXAlignment.Left; itemLbl2.Text=preset.name; itemLbl2.ZIndex=33
        item.MouseEnter:Connect(function()
            if i~=curIdx2 then TweenService:Create(item,TweenInfo.new(0.06),{BackgroundColor3=Color3.fromRGB(32,32,42)}):Play(); itemLbl2.TextColor3=C.text end
        end)
        item.MouseLeave:Connect(function()
            if i~=curIdx2 then TweenService:Create(item,TweenInfo.new(0.06),{BackgroundColor3=Color3.fromRGB(22,22,28)}):Play(); itemLbl2.TextColor3=C.textDim end
        end)
        item.MouseButton1Click:Connect(function()
            for _,c in ipairs(dropScroll2:GetChildren()) do
                if c:IsA("TextButton") then
                    c.BackgroundColor3=Color3.fromRGB(22,22,28)
                    local cl=c:FindFirstChildOfClass("TextLabel"); local cb=c:FindFirstChildOfClass("Frame")
                    if cl then cl.TextColor3=C.textDim end; if cb then cb.Visible=false end
                end
            end
            curIdx2=i; bar2.Visible=true; itemLbl2.TextColor3=C.primary
            item.BackgroundColor3=Color3.fromRGB(30,28,45); selLbl2.Text=preset.name
            if preset.id~="" then previewIco.Image="rbxassetid://"..preset.id; previewIco.ImageColor3=preset.color
            else previewIco.Image="" end
            closeDD2(); applyCrosshair(i,preset)
        end)
    end
    selBtn2.MouseButton1Click:Connect(function()
        isOpen2=not isOpen2; dropList2.Visible=isOpen2; chevLbl2.Text=isOpen2 and "▴" or "▾"
        if isOpen2 then TweenService:Create(selBtn2,TweenInfo.new(0.08),{BackgroundColor3=C.surfaceHov}):Play() end
    end)
end

vSection("TEXTURE",VO())
vToggle("Dark Texture","18594461795",VO(),false,applyDarkTexture)

vSection("COLOR FILTER",VO())
vColorPicker("Couleur du filtre","18594461795",VO(),hex(255,50,50),function(c)
    FilterFrame2.BackgroundColor3=c; if filterActive2 then FilterFrame2.Visible=true end
end)
vToggle("Activer Color Filter","18594461795",VO(),false,function(on)
    filterActive2=on; FilterFrame2.Visible=on
end)

vSection("ÉCLAIRAGE",VO())
vSlider("Brightness","18594461795",VO(),0,10,0.5,"",2,function(v) pcall(function() Lighting.Brightness=v end) end)
vSlider("Time of Day","17551409679",VO(),0,23,1,"H",14,function(v) pcall(function() Lighting.ClockTime=v end) end)
vSlider("Contrast","18594461795",VO(),0,100,1,"%",50,function(v) local cc=getCC(); cc.Enabled=true; cc.Contrast=(v/50)-1 end)
vSlider("Saturation","18594461795",VO(),0,100,1,"%",50,function(v) local cc=getCC(); cc.Enabled=true; cc.Saturation=(v/50)-1 end)
vSlider("Shadow Softness","18594461795",VO(),0,100,1,"%",20,function(v) pcall(function() Lighting.ShadowSoftness=v/100 end) end)

vSection("COLOR SHIFT",VO())
vColorPicker("Color Shift Top","18594461795",VO(),Color3.new(1,1,1),function(c) pcall(function() Lighting.ColorShift_Top=c end) end)
vColorPicker("Color Shift Bottom","18594461795",VO(),Color3.new(0,0,0),function(c) pcall(function() Lighting.ColorShift_Bottom=c end) end)

vSection("SKY",VO()); saveSky()
vDropdown("Sky Preset","17551409679",VO(),skyDropPresets,1,function(idx,preset)
    if SKY_PRESETS[idx] then pcall(SKY_PRESETS[idx].apply) end
    if getgenv().ShadowNotif then getgenv().ShadowNotif("Sky", preset.name.." ✓ appliqué", Color3.fromRGB(139,92,246)) end
end)

vSection("SHADERS",VO())
vToggle("Shaders - Future Lighting","7035631382",VO(),false,applyShaders)
vToggle("Ray Tracing","87544459349643",VO(),false,applyRayTracing)

local function applyReflectiveTexture(on)
    for _,v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
            pcall(function() v.Reflectance=on and 0.6 or 0 end)
        end
    end
    if on then
        Workspace.DescendantAdded:Connect(function(d)
            if d:IsA("Part") or d:IsA("UnionOperation") or d:IsA("MeshPart") then
                pcall(function() d.Reflectance=0.6 end)
            end
        end)
    end
end
vToggle("Reflective Texture","87544459349643",VO(),false,applyReflectiveTexture)

task.defer(function()
    for _,obj in ipairs(ScreenGui:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            pcall(function() obj.FontFace=SILK end)
        end
    end
    ScreenGui.DescendantAdded:Connect(function(obj)
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            pcall(function() obj.FontFace=SILK end)
        end
    end)
end)

----------------------------------------------------
-- DEVICE SPOOF PAGE
----------------------------------------------------
local DeviceSpoofPage = Pages["DeviceSpoof"]

-- [MODIF 3] DeviceSpoofAPI.Set met à jour infoPlatformeLbl dans le Dashboard
task.spawn(function()
    local spoofMap = { PC = "MouseKeyboard", Phone = "Touch", Controller = "Gamepad", VR = "VR" }
    local spoofRemote = nil
    local spoofCurrent = nil
    pcall(function()
        spoofRemote = game:GetService("ReplicatedStorage").Remotes.Replication.Fighter.SetControls
    end)
    getgenv().DeviceSpoofAPI = {
        Set = function(device)
            local mapped = spoofMap[device] or device
            if spoofRemote then pcall(function() spoofRemote:FireServer(mapped) end) end
            spoofCurrent = device
            -- Met à jour le label Plateforme dans le Dashboard
            if infoPlatformeLbl then infoPlatformeLbl.Text = device end
        end,
        GetCurrent = function() return spoofCurrent end,
    }
end)

do
    local secF = Instance.new("Frame", DeviceSpoofPage)
    secF.Size = UDim2.new(1,0,0,20); secF.BackgroundTransparency = 1; secF.LayoutOrder = 1
    local secL = Instance.new("TextLabel", secF)
    secL.Size = UDim2.new(1,0,1,0); secL.BackgroundTransparency = 1
    secL.FontFace = SILK; secL.TextSize = 9; secL.TextColor3 = C.textSub
    secL.TextXAlignment = Enum.TextXAlignment.Left; secL.Text = "PLATEFORME"

    local ITEM_H = 30; local MAX_VISIBLE = 4
    local DEVICE_PRESETS = {
        { name = "PC  (Clavier / Souris)", device = "PC"         },
        { name = "Phone  (Tactile)",       device = "Phone"      },
        { name = "Controller  (Manette)",  device = "Controller" },
        { name = "VR",                     device = "VR"         },
    }

    local card = Instance.new("Frame", DeviceSpoofPage)
    card.Size = UDim2.new(1,0,0,40); card.BackgroundColor3 = C.card
    card.BorderSizePixel = 0; card.LayoutOrder = 2; card.ClipsDescendants = false
    Instance.new("UICorner", card).CornerRadius = UDim.new(0,7)
    Instance.new("UIStroke", card).Color = C.border

    local ico = Instance.new("ImageLabel", card)
    ico.Size = UDim2.fromOffset(18,18); ico.Position = UDim2.new(0,10,0.5,-9)
    ico.BackgroundTransparency = 1; ico.Image = I.device_spoof
    ico.ImageColor3 = C.primary; ico.ScaleType = Enum.ScaleType.Fit

    local nameLbl = Instance.new("TextLabel", card)
    nameLbl.Size = UDim2.fromOffset(90,40); nameLbl.Position = UDim2.fromOffset(34,0)
    nameLbl.BackgroundTransparency = 1; nameLbl.FontFace = SILK; nameLbl.TextSize = 9
    nameLbl.TextColor3 = C.textDim; nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Text = "DEVICE SPOOF"

    local selBtn = Instance.new("TextButton", card)
    selBtn.Size = UDim2.new(1,-130,1,0); selBtn.Position = UDim2.fromOffset(128,0)
    selBtn.BackgroundColor3 = C.surface; selBtn.BorderSizePixel = 0
    selBtn.Text = ""; selBtn.AutoButtonColor = false
    Instance.new("UICorner", selBtn).CornerRadius = UDim.new(0,5)
    Instance.new("UIStroke", selBtn).Color = C.border

    local selLbl = Instance.new("TextLabel", selBtn)
    selLbl.Size = UDim2.new(1,-30,1,0); selLbl.Position = UDim2.fromOffset(10,0)
    selLbl.BackgroundTransparency = 1; selLbl.FontFace = SILK; selLbl.TextSize = 10
    selLbl.TextColor3 = C.text; selLbl.TextXAlignment = Enum.TextXAlignment.Left
    selLbl.Text = DEVICE_PRESETS[1].name

    local chevLbl = Instance.new("TextLabel", selBtn)
    chevLbl.Size = UDim2.fromOffset(24,40); chevLbl.Position = UDim2.new(1,-24,0,0)
    chevLbl.BackgroundTransparency = 1; chevLbl.FontFace = SILK; chevLbl.TextSize = 12
    chevLbl.TextColor3 = C.textDim; chevLbl.Text = "▾"

    local dropList = Instance.new("Frame", card)
    dropList.Size = UDim2.new(1,-128,0,MAX_VISIBLE*ITEM_H)
    dropList.Position = UDim2.new(0,128,1,4)
    dropList.BackgroundColor3 = Color3.fromRGB(22,22,28)
    dropList.BorderSizePixel = 0; dropList.ZIndex = 30; dropList.Visible = false
    dropList.ClipsDescendants = true
    Instance.new("UICorner", dropList).CornerRadius = UDim.new(0,6)
    local ddStroke = Instance.new("UIStroke", dropList)
    ddStroke.Color = C.primary; ddStroke.Thickness = 1

    local dropScroll = Instance.new("ScrollingFrame", dropList)
    dropScroll.Size = UDim2.new(1,0,1,0); dropScroll.BackgroundTransparency = 1
    dropScroll.BorderSizePixel = 0; dropScroll.ScrollBarThickness = 3
    dropScroll.ScrollBarImageColor3 = C.primary; dropScroll.ZIndex = 31
    dropScroll.CanvasSize = UDim2.new(0,0,0,#DEVICE_PRESETS*ITEM_H)
    local dropLL = Instance.new("UIListLayout", dropScroll)
    dropLL.SortOrder = Enum.SortOrder.LayoutOrder; dropLL.Padding = UDim.new(0,0)

    local curIdx = 1; local isOpen = false
    local function closeDDev()
        isOpen = false; dropList.Visible = false; chevLbl.Text = "▾"
        TweenService:Create(selBtn, TweenInfo.new(0.08), {BackgroundColor3 = C.surface}):Play()
    end

    for i, preset in ipairs(DEVICE_PRESETS) do
        local item = Instance.new("TextButton", dropScroll)
        item.Size = UDim2.new(1,0,0,ITEM_H); item.BackgroundColor3 = Color3.fromRGB(22,22,28)
        item.BorderSizePixel = 0; item.Text = ""; item.AutoButtonColor = false
        item.ZIndex = 32; item.LayoutOrder = i

        local bar = Instance.new("Frame", item)
        bar.Size = UDim2.fromOffset(3,ITEM_H-8)
        bar.Position = UDim2.new(0,0,0.5,-((ITEM_H-8)/2))
        bar.BackgroundColor3 = C.primary; bar.BorderSizePixel = 0; bar.ZIndex = 33
        Instance.new("UICorner", bar).CornerRadius = UDim.new(0,2)
        bar.Visible = (i == 1)

        local itemLbl = Instance.new("TextLabel", item)
        itemLbl.Size = UDim2.new(1,-16,1,0); itemLbl.Position = UDim2.fromOffset(12,0)
        itemLbl.BackgroundTransparency = 1; itemLbl.FontFace = SILK; itemLbl.TextSize = 10
        itemLbl.TextColor3 = (i == 1) and C.primary or C.textDim
        itemLbl.TextXAlignment = Enum.TextXAlignment.Left
        itemLbl.Text = preset.name; itemLbl.ZIndex = 33

        local captI = i
        item.MouseEnter:Connect(function()
            if captI ~= curIdx then
                TweenService:Create(item, TweenInfo.new(0.06), {BackgroundColor3 = Color3.fromRGB(32,32,42)}):Play()
                itemLbl.TextColor3 = C.text
            end
        end)
        item.MouseLeave:Connect(function()
            if captI ~= curIdx then
                TweenService:Create(item, TweenInfo.new(0.06), {BackgroundColor3 = Color3.fromRGB(22,22,28)}):Play()
                itemLbl.TextColor3 = C.textDim
            end
        end)
        item.MouseButton1Click:Connect(function()
            for _, c in ipairs(dropScroll:GetChildren()) do
                if c:IsA("TextButton") then
                    c.BackgroundColor3 = Color3.fromRGB(22,22,28)
                    local cl = c:FindFirstChildOfClass("TextLabel"); local cb = c:FindFirstChildOfClass("Frame")
                    if cl then cl.TextColor3 = C.textDim end; if cb then cb.Visible = false end
                end
            end
            curIdx = captI; bar.Visible = true; itemLbl.TextColor3 = C.primary
            item.BackgroundColor3 = Color3.fromRGB(30,28,45)
            selLbl.Text = preset.name; closeDDev()
            if getgenv().DeviceSpoofAPI then
                getgenv().DeviceSpoofAPI.Set(preset.device)
            end
        end)
    end

    selBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen; dropList.Visible = isOpen; chevLbl.Text = isOpen and "▴" or "▾"
        if isOpen then
            TweenService:Create(selBtn, TweenInfo.new(0.08), {BackgroundColor3 = C.surfaceHov}):Play()
        end
    end)
end

----------------------------------------------------
-- OTHERS PAGE
----------------------------------------------------
do
local OthersPage=Pages["Others"]
local oo=0; local function OO() oo=oo+1; return oo end

local function othSection(label,order)
    local f=Instance.new("Frame",OthersPage)
    f.Size=UDim2.new(1,0,0,20); f.BackgroundTransparency=1; f.LayoutOrder=order
    local l=Instance.new("TextLabel",f); l.Size=UDim2.new(1,0,1,0)
    l.BackgroundTransparency=1; l.FontFace=SILK; l.TextSize=9
    l.TextColor3=C.textSub; l.TextXAlignment=Enum.TextXAlignment.Left; l.Text=label
end

local function othToggle(label,iconId,order,initVal,onToggle)
    local card=Instance.new("Frame",OthersPage)
    card.Size=UDim2.new(1,0,0,52); card.BackgroundColor3=C.card
    card.BorderSizePixel=0; card.LayoutOrder=order
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,7)
    Instance.new("UIStroke",card).Color=C.border
    local ico=Instance.new("ImageLabel",card)
    ico.Size=UDim2.fromOffset(18,18); ico.Position=UDim2.new(0,10,0,10)
    ico.BackgroundTransparency=1; ico.Image="rbxassetid://"..iconId
    ico.ImageColor3=C.primary; ico.ScaleType=Enum.ScaleType.Fit
    local lbl=Instance.new("TextLabel",card)
    lbl.Size=UDim2.new(1,-100,0,20); lbl.Position=UDim2.fromOffset(34,6)
    lbl.BackgroundTransparency=1; lbl.FontFace=SILK; lbl.TextSize=10
    lbl.TextColor3=C.text; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=label
    local desc=Instance.new("TextLabel",card)
    desc.Size=UDim2.new(1,-54,0,18); desc.Position=UDim2.fromOffset(10,28)
    desc.BackgroundTransparency=1; desc.FontFace=SILK; desc.TextSize=8
    desc.TextColor3=C.textDim; desc.TextXAlignment=Enum.TextXAlignment.Left; desc.Text=""
    local st={on=initVal or false}
    local track=Instance.new("TextButton",card)
    track.Size=UDim2.fromOffset(42,22); track.Position=UDim2.new(1,-54,0,8)
    track.BackgroundColor3=st.on and C.primary or C.surface
    track.BorderSizePixel=0; track.Text=""; track.AutoButtonColor=false
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
    Instance.new("UIStroke",track).Color=C.border
    local thumb=Instance.new("Frame",track)
    thumb.Size=UDim2.fromOffset(16,16)
    thumb.Position=st.on and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)
    thumb.BackgroundColor3=Color3.new(1,1,1); thumb.BorderSizePixel=0
    Instance.new("UICorner",thumb).CornerRadius=UDim.new(1,0)
    track.MouseButton1Click:Connect(function()
        st.on=not st.on
        TweenService:Create(track,TweenInfo.new(0.12),{BackgroundColor3=st.on and C.primary or C.surface}):Play()
        TweenService:Create(thumb,TweenInfo.new(0.12),{Position=st.on and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)}):Play()
        if onToggle then pcall(onToggle,st.on) end
        if getgenv().ShadowNotif then
            local c=st.on and Color3.fromRGB(34,197,94) or Color3.fromRGB(239,68,68)
            getgenv().ShadowNotif(label, st.on and "✓  Activé" or "✗  Désactivé", c)
        end
    end)
    return card,st,desc
end

othSection("INTERFACE (UI)",OO())

local _hideUIState=false; local _hideUIConns={}
local function applyHideUI(on)
    _hideUIState=on
    for _,c in pairs(_hideUIConns) do pcall(function() c:Disconnect() end) end; _hideUIConns={}
    pcall(function()
        local pgui=Player:FindFirstChildOfClass("PlayerGui"); if not pgui then return end
        for _,gui in ipairs(pgui:GetChildren()) do
            if gui~=ScreenGui and gui.Name~="ShadowCursorGui" and gui.Name~="ShadowCrosshairV2"
               and gui.Name~="ShadowHUD" and gui.Name~="ShadowFilter2" then
                pcall(function() gui.Enabled=not on end)
            end
        end
        if on then
            local c=pgui.ChildAdded:Connect(function(g)
                if g.Name~="ShadowCursorGui" and g.Name~="ShadowCrosshairV2" and g.Name~="ShadowHUD" then
                    pcall(function() task.wait(0.05); if _hideUIState then g.Enabled=false end end)
                end
            end)
            table.insert(_hideUIConns,c)
        end
    end)
end
local huCard,_,huDesc=othToggle("Hide UI","9405931578",OO(),false,applyHideUI)
huDesc.Text="Cache toute l'interface - Utile pour l'immersion"
huDesc.Size=UDim2.new(1,-54,0,18)

othSection("INTERFACE RIVALS",OO())

local _hideFeedEnabled=false; local _hideFeedConn=nil
local function applyHideKillFeed(on)
    _hideFeedEnabled=on
    if _hideFeedConn then _hideFeedConn:Disconnect(); _hideFeedConn=nil end
    if not on then
        pcall(function()
            for _,gui in ipairs(Player.PlayerGui:GetDescendants()) do
                local n=gui.Name:lower()
                if n:find("kill") or n:find("elim") or n:find("feed") or n:find("death")
                   or n:find("combat") or n:find("notif") then
                    if gui:IsA("Frame") or gui:IsA("ScrollingFrame")
                       or gui:IsA("TextLabel") or gui:IsA("CanvasGroup") then
                        pcall(function() gui.Visible=true end)
                    end
                end
            end
        end); return
    end
    local function scanAndHide()
        pcall(function()
            local pgui=Player.PlayerGui
            for _,desc in ipairs(pgui:GetDescendants()) do
                local n=desc.Name:lower()
                if n:find("kill") or n:find("elim") or n:find("feed")
                   or n:find("death") or n:find("combat") or n:find("notif") then
                    if desc:IsA("Frame") or desc:IsA("ScrollingFrame") or desc:IsA("CanvasGroup") then
                        pcall(function() desc.Visible=false end)
                    end
                end
                if (desc:IsA("TextLabel") or desc:IsA("TextButton")) and desc.Visible then
                    local txt=""; pcall(function() txt=desc.Text or "" end)
                    if txt:find("Eliminated") or txt:find("liminé") or txt:find("killed by")
                       or txt:lower():find("elim") or txt:lower():find("knocked") then
                        pcall(function() desc.Visible=false end)
                    end
                end
            end
        end)
    end
    scanAndHide()
    _hideFeedConn=RunService.Heartbeat:Connect(function()
        if not _hideFeedEnabled then return end; scanAndHide()
    end)
end
local hkDesc=select(3,othToggle("Hide Kill Feed","123908228387675",OO(),false,applyHideKillFeed))
hkDesc.Text="Cache les messages d'élimination"
end

----------------------------------------------------
-- PROFILE SPOOF PAGE
----------------------------------------------------
do
local ProfilePage = Pages["Profile"]
local pp = 0
local function PP() pp=pp+1; return pp end
 
local function pSec(txt)
    local f=Instance.new("Frame",ProfilePage)
    f.Size=UDim2.new(1,0,0,20); f.BackgroundTransparency=1; f.LayoutOrder=PP()
    local l=Instance.new("TextLabel",f)
    l.Size=UDim2.new(1,0,1,0); l.BackgroundTransparency=1
    l.FontFace=SILK; l.TextSize=9; l.TextColor3=C.textSub
    l.TextXAlignment=Enum.TextXAlignment.Left; l.Text=txt
end
 
local function pInput(lTxt, ph)
    local card=Instance.new("Frame",ProfilePage)
    card.Size=UDim2.new(1,0,0,52); card.BackgroundColor3=C.card
    card.BorderSizePixel=0; card.LayoutOrder=PP()
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,7)
    Instance.new("UIStroke",card).Color=C.border
    local lbl=Instance.new("TextLabel",card)
    lbl.Size=UDim2.new(1,-16,0,20); lbl.Position=UDim2.fromOffset(12,6)
    lbl.BackgroundTransparency=1; lbl.FontFace=SILK; lbl.TextSize=10
    lbl.TextColor3=C.textDim; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=lTxt
    local bg=Instance.new("Frame",card)
    bg.Size=UDim2.new(1,-16,0,22); bg.Position=UDim2.fromOffset(8,26)
    bg.BackgroundColor3=C.surface; bg.BorderSizePixel=0
    Instance.new("UICorner",bg).CornerRadius=UDim.new(0,5)
    Instance.new("UIStroke",bg).Color=C.border
    local inp=Instance.new("TextBox",bg)
    inp.Size=UDim2.new(1,-8,1,0); inp.Position=UDim2.fromOffset(4,0)
    inp.BackgroundTransparency=1; inp.FontFace=SILK; inp.TextSize=10
    inp.TextColor3=C.text; inp.PlaceholderText=ph
    inp.PlaceholderColor3=C.textSub; inp.TextXAlignment=Enum.TextXAlignment.Left
    inp.ClearTextOnFocus=false; inp.Text=""
    return card, inp
end
 
local function pRow(page, onA, onU)
    local row=Instance.new("Frame",page)
    row.Size=UDim2.new(1,0,0,32); row.BackgroundTransparency=1; row.LayoutOrder=PP()
    local ll=Instance.new("UIListLayout",row)
    ll.FillDirection=Enum.FillDirection.Horizontal
    ll.Padding=UDim.new(0,8); ll.SortOrder=Enum.SortOrder.LayoutOrder
    local aBtn=Instance.new("TextButton",row)
    aBtn.Size=UDim2.new(0.5,-4,1,0); aBtn.BackgroundColor3=C.primary
    aBtn.BorderSizePixel=0; aBtn.FontFace=SILK; aBtn.TextSize=10
    aBtn.TextColor3=Color3.new(1,1,1); aBtn.Text="Apply"; aBtn.AutoButtonColor=false
    Instance.new("UICorner",aBtn).CornerRadius=UDim.new(0,6)
    local uBtn=Instance.new("TextButton",row)
    uBtn.Size=UDim2.new(0.5,-4,1,0); uBtn.BackgroundColor3=Color3.fromRGB(55,55,75)
    uBtn.BorderSizePixel=0; uBtn.FontFace=SILK; uBtn.TextSize=10
    uBtn.TextColor3=Color3.new(1,1,1); uBtn.Text="Unapply"; uBtn.AutoButtonColor=false
    Instance.new("UICorner",uBtn).CornerRadius=UDim.new(0,6)
    aBtn.MouseButton1Click:Connect(function() pcall(onA) end)
    uBtn.MouseButton1Click:Connect(function() pcall(onU) end)
end
 
-- IDENTITÉ
pSec("IDENTITÉ")
do
    local _, inputDN = pInput("Display Name", "Nouveau display name...")
    local _, inputUN = pInput("Username", "Nouveau username...")
    local origDN = Player.DisplayName
    local origUN = Player.Name
    pRow(ProfilePage,
        function()
            pcall(function()
                for _,d in ipairs(Player.PlayerGui:GetDescendants()) do
                    if d:IsA("TextLabel") then
                        if d.Text==Player.DisplayName and inputDN.Text~="" then d.Text=inputDN.Text end
                        if (d.Text==Player.Name or d.Text=="@"..Player.Name) and inputUN.Text~="" then d.Text=inputUN.Text end
                    end
                end
            end)
            if getgenv().ShadowNotif then getgenv().ShadowNotif("Identité","Appliqué ✓",C.primary) end
        end,
        function()
            pcall(function()
                for _,d in ipairs(Player.PlayerGui:GetDescendants()) do
                    if d:IsA("TextLabel") then
                        if inputDN.Text~="" and d.Text==inputDN.Text then d.Text=origDN end
                        if inputUN.Text~="" and d.Text==inputUN.Text then d.Text=origUN end
                    end
                end
            end)
            if getgenv().ShadowNotif then getgenv().ShadowNotif("Identité","Réinitialisé",Color3.fromRGB(130,125,155)) end
        end
    )
end
 
-- STATS
pSec("STATS RIVALS")
do
    local _, inputLvl  = pInput("Level",       "Ex: 100")
    local _, inputELO  = pInput("Ranked ELO",  "Ex: 2000")
    local _, inputRW   = pInput("Ranked Wins", "Ex: 500")
    local _, inputCW   = pInput("Casual Wins", "Ex: 1000")
    local _, inputKeys = pInput("Keys",        "Ex: 999")
    local origStats = {}
    pRow(ProfilePage,
        function()
            pcall(function()
                local KW = {
                    {inp=inputLvl,  keys={"level","lvl","lv"}},
                    {inp=inputELO,  keys={"elo","rating"}},
                    {inp=inputRW,   keys={"ranked win"}},
                    {inp=inputCW,   keys={"casual win"}},
                    {inp=inputKeys, keys={"key"}},
                }
                for _,d in ipairs(Player.PlayerGui:GetDescendants()) do
                    if d:IsA("TextLabel") and d.Text~="" then
                        for _,kw in ipairs(KW) do
                            if kw.inp.Text~="" then
                                local t=d.Text:lower()
                                for _,k in ipairs(kw.keys) do
                                    if t:find(k) then
                                        table.insert(origStats,{obj=d,text=d.Text})
                                        d.Text=kw.inp.Text; break
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            if getgenv().ShadowNotif then getgenv().ShadowNotif("Stats","Appliqué ✓",C.primary) end
        end,
        function()
            pcall(function()
                for _,e in ipairs(origStats) do pcall(function() e.obj.Text=e.text end) end
                origStats={}
            end)
            if getgenv().ShadowNotif then getgenv().ShadowNotif("Stats","Réinitialisé",Color3.fromRGB(130,125,155)) end
        end
    )
end
 
-- MAP FAVORITE
pSec("MAP FAVORITE")
do
    local MAPS={"Dust","Palace","Arena","Rooftop","Factory","Colosseum","Museum","Warehouse","Castle","Bridge","Snow","Desert","City","Forest","Beach","Space","Underground","Neon"}
    local card=Instance.new("Frame",ProfilePage)
    card.Size=UDim2.new(1,0,0,40); card.BackgroundColor3=C.card
    card.BorderSizePixel=0; card.LayoutOrder=PP(); card.ClipsDescendants=false
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,7)
    Instance.new("UIStroke",card).Color=C.border
    local ico=Instance.new("ImageLabel",card)
    ico.Size=UDim2.fromOffset(18,18); ico.Position=UDim2.new(0,10,0.5,-9)
    ico.BackgroundTransparency=1; ico.Image="rbxassetid://4621599120"
    ico.ImageColor3=C.primary; ico.ScaleType=Enum.ScaleType.Fit
    local nLbl=Instance.new("TextLabel",card)
    nLbl.Size=UDim2.fromOffset(90,40); nLbl.Position=UDim2.fromOffset(34,0)
    nLbl.BackgroundTransparency=1; nLbl.FontFace=SILK; nLbl.TextSize=9
    nLbl.TextColor3=C.textDim; nLbl.TextXAlignment=Enum.TextXAlignment.Left; nLbl.Text="MAP FAVORITE"
    local ITEM_H=30; local MAX_V=5
    local selBtn=Instance.new("TextButton",card)
    selBtn.Size=UDim2.new(1,-130,1,0); selBtn.Position=UDim2.fromOffset(128,0)
    selBtn.BackgroundColor3=C.surface; selBtn.BorderSizePixel=0; selBtn.Text=""; selBtn.AutoButtonColor=false
    Instance.new("UICorner",selBtn).CornerRadius=UDim.new(0,5)
    Instance.new("UIStroke",selBtn).Color=C.border
    local sLbl=Instance.new("TextLabel",selBtn)
    sLbl.Size=UDim2.new(1,-30,1,0); sLbl.Position=UDim2.fromOffset(10,0)
    sLbl.BackgroundTransparency=1; sLbl.FontFace=SILK; sLbl.TextSize=10
    sLbl.TextColor3=C.text; sLbl.TextXAlignment=Enum.TextXAlignment.Left; sLbl.Text=MAPS[1]
    local chev=Instance.new("TextLabel",selBtn)
    chev.Size=UDim2.fromOffset(24,40); chev.Position=UDim2.new(1,-24,0,0)
    chev.BackgroundTransparency=1; chev.FontFace=SILK; chev.TextSize=12; chev.TextColor3=C.textDim; chev.Text="▾"
    local dList=Instance.new("Frame",card)
    dList.Size=UDim2.new(1,-128,0,MAX_V*ITEM_H); dList.Position=UDim2.new(0,128,1,4)
    dList.BackgroundColor3=Color3.fromRGB(22,22,28); dList.BorderSizePixel=0
    dList.ZIndex=30; dList.Visible=false; dList.ClipsDescendants=true
    Instance.new("UICorner",dList).CornerRadius=UDim.new(0,6)
    local dStr=Instance.new("UIStroke",dList); dStr.Color=C.primary; dStr.Thickness=1
    local dScroll=Instance.new("ScrollingFrame",dList)
    dScroll.Size=UDim2.new(1,0,1,0); dScroll.BackgroundTransparency=1
    dScroll.BorderSizePixel=0; dScroll.ScrollBarThickness=3
    dScroll.ScrollBarImageColor3=C.primary; dScroll.ZIndex=31
    dScroll.CanvasSize=UDim2.new(0,0,0,#MAPS*ITEM_H)
    local dLL=Instance.new("UIListLayout",dScroll)
    dLL.SortOrder=Enum.SortOrder.LayoutOrder; dLL.Padding=UDim.new(0,0)
    local curM=1; local isOpen=false
    local function closeM()
        isOpen=false; dList.Visible=false; chev.Text="▾"
        TweenService:Create(selBtn,TweenInfo.new(0.08),{BackgroundColor3=C.surface}):Play()
    end
    local function buildMapItem(i, mapName)
        local item=Instance.new("TextButton",dScroll)
        item.Size=UDim2.new(1,0,0,ITEM_H); item.BackgroundColor3=Color3.fromRGB(22,22,28)
        item.BorderSizePixel=0; item.Text=""; item.AutoButtonColor=false; item.ZIndex=32; item.LayoutOrder=i
        local bar=Instance.new("Frame",item)
        bar.Size=UDim2.fromOffset(3,ITEM_H-8); bar.Position=UDim2.new(0,0,0.5,-((ITEM_H-8)/2))
        bar.BackgroundColor3=C.primary; bar.BorderSizePixel=0; bar.ZIndex=33
        Instance.new("UICorner",bar).CornerRadius=UDim.new(0,2); bar.Visible=(i==1)
        local iLbl=Instance.new("TextLabel",item)
        iLbl.Size=UDim2.new(1,-16,1,0); iLbl.Position=UDim2.fromOffset(12,0)
        iLbl.BackgroundTransparency=1; iLbl.FontFace=SILK; iLbl.TextSize=10
        iLbl.TextColor3=i==1 and C.primary or C.textDim
        iLbl.TextXAlignment=Enum.TextXAlignment.Left; iLbl.Text=mapName; iLbl.ZIndex=33
        item.MouseEnter:Connect(function()
            if i~=curM then
                TweenService:Create(item,TweenInfo.new(0.06),{BackgroundColor3=Color3.fromRGB(32,32,42)}):Play()
                iLbl.TextColor3=C.text
            end
        end)
        item.MouseLeave:Connect(function()
            if i~=curM then
                TweenService:Create(item,TweenInfo.new(0.06),{BackgroundColor3=Color3.fromRGB(22,22,28)}):Play()
                iLbl.TextColor3=C.textDim
            end
        end)
        item.MouseButton1Click:Connect(function()
            for _,c in ipairs(dScroll:GetChildren()) do
                if c:IsA("TextButton") then
                    c.BackgroundColor3=Color3.fromRGB(22,22,28)
                    local cl=c:FindFirstChildOfClass("TextLabel")
                    local cb=c:FindFirstChildOfClass("Frame")
                    if cl then cl.TextColor3=C.textDim end
                    if cb then cb.Visible=false end
                end
            end
            curM=i; bar.Visible=true; iLbl.TextColor3=C.primary
            item.BackgroundColor3=Color3.fromRGB(30,28,45); sLbl.Text=mapName; closeM()
            pcall(function()
                local rem=game:GetService("ReplicatedStorage"):FindFirstChild("Remotes",true)
                if rem then
                    local r=rem:FindFirstChild("SetFavoriteMap",true) or rem:FindFirstChild("UpdateProfile",true)
                    if r then r:FireServer({FavoriteMap=mapName}) end
                end
            end)
            if getgenv().ShadowNotif then getgenv().ShadowNotif("Map Favorite",mapName.." ✓",C.primary) end
        end)
    end
    for i,mapName in ipairs(MAPS) do buildMapItem(i,mapName) end
    selBtn.MouseButton1Click:Connect(function()
        isOpen=not isOpen; dList.Visible=isOpen; chev.Text=isOpen and "▴" or "▾"
        if isOpen then TweenService:Create(selBtn,TweenInfo.new(0.08),{BackgroundColor3=C.surfaceHov}):Play()
        else TweenService:Create(selBtn,TweenInfo.new(0.08),{BackgroundColor3=C.surface}):Play() end
    end)
end
 
-- ARMES PRÉFÉRÉES
pSec("ARMES PRÉFÉRÉES")
do
    local WCATS={
        {label="WEAPON 1  (Principal)",   wlist={"Assault Rifle","SMG","Shotgun","Sniper","LMG","DMR","Burst Rifle"}},
        {label="WEAPON 2  (Secondaire)",  wlist={"Pistol","Deagle","Revolver","Auto Pistol","Hand Cannon"}},
        {label="WEAPON 3  (Corps/Corps)", wlist={"Knife","Sword","Bat","Axe","Wrench","Fists"}},
        {label="WEAPON 4  (Utilitaire)",  wlist={"Grenade","Flash","Smoke","Molotov","Claymore","Shield"}},
    }
    local function buildWItem(i, wn, ci, dScroll, curWRef, sLbl, closeW)
        local IH=28
        local item=Instance.new("TextButton",dScroll)
        item.Size=UDim2.new(1,0,0,IH); item.BackgroundColor3=Color3.fromRGB(22,22,28)
        item.BorderSizePixel=0; item.Text=""; item.AutoButtonColor=false; item.ZIndex=32+ci; item.LayoutOrder=i
        local bar=Instance.new("Frame",item)
        bar.Size=UDim2.fromOffset(3,IH-6); bar.Position=UDim2.new(0,0,0.5,-((IH-6)/2))
        bar.BackgroundColor3=C.primary; bar.BorderSizePixel=0; bar.ZIndex=33+ci
        Instance.new("UICorner",bar).CornerRadius=UDim.new(0,2); bar.Visible=(i==1)
        local iLbl=Instance.new("TextLabel",item)
        iLbl.Size=UDim2.new(1,-12,1,0); iLbl.Position=UDim2.fromOffset(10,0)
        iLbl.BackgroundTransparency=1; iLbl.FontFace=SILK; iLbl.TextSize=9
        iLbl.TextColor3=i==1 and C.primary or C.textDim
        iLbl.TextXAlignment=Enum.TextXAlignment.Left; iLbl.Text=wn; iLbl.ZIndex=33+ci
        item.MouseEnter:Connect(function()
            if i~=curWRef[1] then
                TweenService:Create(item,TweenInfo.new(0.06),{BackgroundColor3=Color3.fromRGB(32,32,42)}):Play()
                iLbl.TextColor3=C.text
            end
        end)
        item.MouseLeave:Connect(function()
            if i~=curWRef[1] then
                TweenService:Create(item,TweenInfo.new(0.06),{BackgroundColor3=Color3.fromRGB(22,22,28)}):Play()
                iLbl.TextColor3=C.textDim
            end
        end)
        item.MouseButton1Click:Connect(function()
            for _,c in ipairs(dScroll:GetChildren()) do
                if c:IsA("TextButton") then
                    c.BackgroundColor3=Color3.fromRGB(22,22,28)
                    local cl=c:FindFirstChildOfClass("TextLabel")
                    local cb=c:FindFirstChildOfClass("Frame")
                    if cl then cl.TextColor3=C.textDim end
                    if cb then cb.Visible=false end
                end
            end
            curWRef[1]=i; bar.Visible=true; iLbl.TextColor3=C.primary
            item.BackgroundColor3=Color3.fromRGB(30,28,45); sLbl.Text=wn; closeW()
            pcall(function()
                local rem=game:GetService("ReplicatedStorage"):FindFirstChild("Remotes",true)
                if rem then
                    local r=rem:FindFirstChild("SetFavoriteWeapon",true) or rem:FindFirstChild("UpdateLoadout",true)
                    if r then r:FireServer({Slot=ci,Weapon=wn}) end
                end
            end)
            if getgenv().ShadowNotif then getgenv().ShadowNotif("Weapon "..ci,wn.." ✓",C.primary) end
        end)
    end
    local function buildWeaponCat(ci, cat)
        local IH=28; local MV=4
        local card=Instance.new("Frame",ProfilePage)
        card.Size=UDim2.new(1,0,0,40); card.BackgroundColor3=C.card
        card.BorderSizePixel=0; card.LayoutOrder=PP(); card.ClipsDescendants=false
        Instance.new("UICorner",card).CornerRadius=UDim.new(0,7)
        Instance.new("UIStroke",card).Color=C.border
        local ico=Instance.new("ImageLabel",card)
        ico.Size=UDim2.fromOffset(18,18); ico.Position=UDim2.new(0,10,0.5,-9)
        ico.BackgroundTransparency=1; ico.Image="rbxassetid://4391741881"
        ico.ImageColor3=C.primary; ico.ScaleType=Enum.ScaleType.Fit
        local nLbl=Instance.new("TextLabel",card)
        nLbl.Size=UDim2.fromOffset(130,40); nLbl.Position=UDim2.fromOffset(34,0)
        nLbl.BackgroundTransparency=1; nLbl.FontFace=SILK; nLbl.TextSize=8
        nLbl.TextColor3=C.textDim; nLbl.TextXAlignment=Enum.TextXAlignment.Left; nLbl.Text=cat.label
        local selBtn=Instance.new("TextButton",card)
        selBtn.Size=UDim2.new(1,-148,1,0); selBtn.Position=UDim2.fromOffset(146,0)
        selBtn.BackgroundColor3=C.surface; selBtn.BorderSizePixel=0; selBtn.Text=""; selBtn.AutoButtonColor=false
        Instance.new("UICorner",selBtn).CornerRadius=UDim.new(0,5)
        Instance.new("UIStroke",selBtn).Color=C.border
        local sLbl=Instance.new("TextLabel",selBtn)
        sLbl.Size=UDim2.new(1,-22,1,0); sLbl.Position=UDim2.fromOffset(6,0)
        sLbl.BackgroundTransparency=1; sLbl.FontFace=SILK; sLbl.TextSize=9
        sLbl.TextColor3=C.text; sLbl.TextXAlignment=Enum.TextXAlignment.Left; sLbl.Text=cat.wlist[1]
        local chev=Instance.new("TextLabel",selBtn)
        chev.Size=UDim2.fromOffset(18,40); chev.Position=UDim2.new(1,-18,0,0)
        chev.BackgroundTransparency=1; chev.FontFace=SILK; chev.TextSize=11
        chev.TextColor3=C.textDim; chev.Text="▾"
        local dList=Instance.new("Frame",card)
        dList.Size=UDim2.new(1,-146,0,MV*IH); dList.Position=UDim2.new(0,146,1,4)
        dList.BackgroundColor3=Color3.fromRGB(22,22,28); dList.BorderSizePixel=0
        dList.ZIndex=30+ci; dList.Visible=false; dList.ClipsDescendants=true
        Instance.new("UICorner",dList).CornerRadius=UDim.new(0,6)
        local dStr=Instance.new("UIStroke",dList); dStr.Color=C.primary; dStr.Thickness=1
        local dScroll=Instance.new("ScrollingFrame",dList)
        dScroll.Size=UDim2.new(1,0,1,0); dScroll.BackgroundTransparency=1
        dScroll.BorderSizePixel=0; dScroll.ScrollBarThickness=2
        dScroll.ScrollBarImageColor3=C.primary; dScroll.ZIndex=31+ci
        dScroll.CanvasSize=UDim2.new(0,0,0,#cat.wlist*IH)
        local dLL=Instance.new("UIListLayout",dScroll)
        dLL.SortOrder=Enum.SortOrder.LayoutOrder; dLL.Padding=UDim.new(0,0)
        local curWRef={1}; local isOpen=false
        local function closeW()
            isOpen=false; dList.Visible=false; chev.Text="▾"
            TweenService:Create(selBtn,TweenInfo.new(0.08),{BackgroundColor3=C.surface}):Play()
        end
        for i,wn in ipairs(cat.wlist) do buildWItem(i,wn,ci,dScroll,curWRef,sLbl,closeW) end
        selBtn.MouseButton1Click:Connect(function()
            isOpen=not isOpen; dList.Visible=isOpen; chev.Text=isOpen and "▴" or "▾"
            if isOpen then TweenService:Create(selBtn,TweenInfo.new(0.08),{BackgroundColor3=C.surfaceHov}):Play()
            else TweenService:Create(selBtn,TweenInfo.new(0.08),{BackgroundColor3=C.surface}):Play() end
        end)
    end
    for ci,cat in ipairs(WCATS) do buildWeaponCat(ci,cat) end
end
 
-- BADGES
pSec("BADGES")
do
    local VERIFIED_ICON = "rbxassetid://11478378840"

    local function findRivalsNametag()
        local char = Player.Character
        if not char then return nil, nil end
        local head = char:FindFirstChild("Head")
        if not head then return nil, nil end
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("BillboardGui") and child.Name ~= "ShadowBadgeGui" then
                for _, desc in ipairs(child:GetDescendants()) do
                    if desc:IsA("TextLabel") then
                        if desc.Text == Player.DisplayName
                        or desc.Text == Player.Name
                        or desc.Text:find(Player.DisplayName, 1, true)
                        or desc.Text:find(Player.Name, 1, true) then
                            return child, desc
                        end
                    end
                end
            end
        end
        for _, child in ipairs(head:GetChildren()) do
            if child:IsA("BillboardGui") and child.Name ~= "ShadowBadgeGui" then
                return child, child:FindFirstChildWhichIsA("TextLabel", true)
            end
        end
        return nil, nil
    end

    local verifiedConn = nil
    local playerListConns = {}

    local function applyToNametag()
        local nametag, nameLbl = findRivalsNametag()
        if not nametag or not nameLbl then return false end

        local old = nametag:FindFirstChild("ShadowVerifiedBadge")
        if old then old:Destroy() end

        local SZ = 16

        local badge = Instance.new("ImageLabel")
        badge.Name               = "ShadowVerifiedBadge"
        badge.Image              = VERIFIED_ICON
        badge.BackgroundTransparency = 1
        badge.ScaleType          = Enum.ScaleType.Fit
        badge.ZIndex             = nameLbl.ZIndex + 2
        badge.Size               = UDim2.fromOffset(SZ, SZ)

        if nameLbl.Position.X.Scale > 0 then
            badge.AnchorPoint = Vector2.new(0, 0.5)
            badge.Position = UDim2.new(
                nameLbl.Position.X.Scale + nameLbl.Size.X.Scale,
                nameLbl.Position.X.Offset + 3,
                nameLbl.Position.Y.Scale + nameLbl.Size.Y.Scale * 0.5,
                nameLbl.Position.Y.Offset
            )
        else
            local tx = nameLbl.Position.X.Offset + nameLbl.Size.X.Offset + 3
            local ty = nameLbl.Position.Y.Offset + (nameLbl.Size.Y.Offset - SZ) / 2
            badge.AnchorPoint = Vector2.new(0, 0)
            badge.Position    = UDim2.fromOffset(tx, ty)
        end

        badge.Parent = nametag
        return true
    end

    local function applyToPlayerList(on)
        for _, c in ipairs(playerListConns) do
            pcall(function() c:Disconnect() end)
        end
        playerListConns = {}

        pcall(function()
            for _, gui in ipairs(Player.PlayerGui:GetChildren()) do
                if gui:IsA("ScreenGui") then
                    for _, desc in ipairs(gui:GetDescendants()) do
                        if desc:IsA("TextLabel") then
                            if desc.Text == Player.DisplayName
                            or desc.Text == Player.Name then
                                local slot = desc.Parent
                                if slot then
                                    local oldV = slot:FindFirstChild("ShadowVerifiedPL")
                                    if on and not oldV then
                                        local SZ = 14
                                        local vbadge = Instance.new("ImageLabel", slot)
                                        vbadge.Name              = "ShadowVerifiedPL"
                                        vbadge.Image             = VERIFIED_ICON
                                        vbadge.Size              = UDim2.fromOffset(SZ, SZ)
                                        vbadge.BackgroundTransparency = 1
                                        vbadge.ScaleType         = Enum.ScaleType.Fit
                                        vbadge.ZIndex            = desc.ZIndex + 1
                                        vbadge.AnchorPoint       = Vector2.new(0, 0.5)
                                        vbadge.Position          = UDim2.new(
                                            desc.Position.X.Scale + desc.Size.X.Scale,
                                            desc.Position.X.Offset + desc.AbsoluteSize.X + 4,
                                            desc.Position.Y.Scale,
                                            desc.Position.Y.Offset + desc.Size.Y.Offset / 2
                                        )
                                    elseif not on and oldV then
                                        oldV:Destroy()
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end

    local function removeAll()
        local char = Player.Character
        if char then
            for _, desc in ipairs(char:GetDescendants()) do
                if desc.Name == "ShadowVerifiedBadge" then
                    pcall(function() desc:Destroy() end)
                end
            end
        end
        for _, gui in ipairs(Player.PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                for _, desc in ipairs(gui:GetDescendants()) do
                    if desc.Name == "ShadowVerifiedPL" then
                        pcall(function() desc:Destroy() end)
                    end
                end
            end
        end
        for _, c in ipairs(playerListConns) do
            pcall(function() c:Disconnect() end)
        end
        playerListConns = {}
        if verifiedConn then
            verifiedConn:Disconnect()
            verifiedConn = nil
        end
    end

    local function buildVerifiedCard()
        local card = Instance.new("Frame", ProfilePage)
        card.Size = UDim2.new(1,0,0,38)
        card.BackgroundColor3 = C.card
        card.BorderSizePixel = 0
        card.LayoutOrder = PP()
        Instance.new("UICorner", card).CornerRadius = UDim.new(0,7)
        Instance.new("UIStroke", card).Color = C.border

        local ico = Instance.new("ImageLabel", card)
        ico.Size = UDim2.fromOffset(18,18)
        ico.Position = UDim2.new(0,10,0.5,-9)
        ico.BackgroundTransparency = 1
        ico.Image = VERIFIED_ICON
        ico.ScaleType = Enum.ScaleType.Fit

        local lbl = Instance.new("TextLabel", card)
        lbl.Size = UDim2.new(1,-100,1,0)
        lbl.Position = UDim2.fromOffset(34,0)
        lbl.BackgroundTransparency = 1
        lbl.FontFace = SILK
        lbl.TextSize = 10
        lbl.TextColor3 = C.text
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = "Verified Badge"

        local st = {on = false}

        local track = Instance.new("TextButton", card)
        track.Size = UDim2.fromOffset(42,22)
        track.Position = UDim2.new(1,-54,0.5,-11)
        track.BackgroundColor3 = C.surface
        track.BorderSizePixel = 0
        track.Text = ""
        track.AutoButtonColor = false
        Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)
        Instance.new("UIStroke", track).Color = C.border

        local thumb = Instance.new("Frame", track)
        thumb.Size = UDim2.fromOffset(16,16)
        thumb.Position = UDim2.fromOffset(3,3)
        thumb.BackgroundColor3 = Color3.new(1,1,1)
        thumb.BorderSizePixel = 0
        Instance.new("UICorner", thumb).CornerRadius = UDim.new(1,0)

        track.MouseButton1Click:Connect(function()
            st.on = not st.on
            TweenService:Create(track, TweenInfo.new(0.12), {
                BackgroundColor3 = st.on and C.primary or C.surface
            }):Play()
            TweenService:Create(thumb, TweenInfo.new(0.12), {
                Position = st.on and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)
            }):Play()

            if st.on then
                pcall(applyToNametag)
                pcall(applyToPlayerList, true)

                if verifiedConn then verifiedConn:Disconnect() end
                verifiedConn = RunService.Heartbeat:Connect(function()
                    if not st.on then
                        verifiedConn:Disconnect()
                        verifiedConn = nil
                        return
                    end
                    local nt, _ = findRivalsNametag()
                    if nt and not nt:FindFirstChild("ShadowVerifiedBadge") then
                        pcall(applyToNametag)
                    end
                end)

                Player.CharacterAdded:Connect(function()
                    if st.on then
                        task.wait(2.5)
                        pcall(applyToNametag)
                        pcall(applyToPlayerList, true)
                    end
                end)
            else
                removeAll()
            end

            if getgenv().ShadowNotif then
                getgenv().ShadowNotif(
                    "Verified Badge",
                    st.on and "Active" or "Desactive",
                    st.on and C.primary or Color3.fromRGB(130,125,155)
                )
            end
        end)
    end

    local function buildPremiumCard()
        local PREM_ICON = "rbxassetid://4038140816"
        local card = Instance.new("Frame", ProfilePage)
        card.Size = UDim2.new(1,0,0,38)
        card.BackgroundColor3 = C.card
        card.BorderSizePixel = 0
        card.LayoutOrder = PP()
        Instance.new("UICorner", card).CornerRadius = UDim.new(0,7)
        Instance.new("UIStroke", card).Color = C.border

        local ico = Instance.new("ImageLabel", card)
        ico.Size = UDim2.fromOffset(18,18)
        ico.Position = UDim2.new(0,10,0.5,-9)
        ico.BackgroundTransparency = 1
        ico.Image = PREM_ICON
        ico.ImageColor3 = C.primary
        ico.ScaleType = Enum.ScaleType.Fit

        local lbl = Instance.new("TextLabel", card)
        lbl.Size = UDim2.new(1,-100,1,0)
        lbl.Position = UDim2.fromOffset(34,0)
        lbl.BackgroundTransparency = 1
        lbl.FontFace = SILK
        lbl.TextSize = 10
        lbl.TextColor3 = C.text
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = "Premium Badge"

        local st = {on = false}

        local track = Instance.new("TextButton", card)
        track.Size = UDim2.fromOffset(42,22)
        track.Position = UDim2.new(1,-54,0.5,-11)
        track.BackgroundColor3 = C.surface
        track.BorderSizePixel = 0
        track.Text = ""
        track.AutoButtonColor = false
        Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)
        Instance.new("UIStroke", track).Color = C.border

        local thumb = Instance.new("Frame", track)
        thumb.Size = UDim2.fromOffset(16,16)
        thumb.Position = UDim2.fromOffset(3,3)
        thumb.BackgroundColor3 = Color3.new(1,1,1)
        thumb.BorderSizePixel = 0
        Instance.new("UICorner", thumb).CornerRadius = UDim.new(1,0)

        track.MouseButton1Click:Connect(function()
            st.on = not st.on
            TweenService:Create(track, TweenInfo.new(0.12), {
                BackgroundColor3 = st.on and C.primary or C.surface
            }):Play()
            TweenService:Create(thumb, TweenInfo.new(0.12), {
                Position = st.on and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)
            }):Play()
            if getgenv().ShadowNotif then
                getgenv().ShadowNotif(
                    "Premium Badge",
                    st.on and "Active" or "Desactive",
                    st.on and C.primary or Color3.fromRGB(130,125,155)
                )
            end
        end)
    end

    buildPremiumCard()
    buildVerifiedCard()
end
 
-- SKIN
pSec("SKIN")
do
    local _, inputSkin = pInput("Username (@)", "Ex: Builderman")

    local function morphToUsername(username)
        username = username:gsub("@",""):gsub("%s","")
        if username == "" then
            if getgenv().ShadowNotif then
                getgenv().ShadowNotif("Skin", "Entre un @username !", Color3.fromRGB(239,68,68))
            end
            return
        end

        -- Trouve le userId (joueur connecte ou pas)
        local foundTarget = nil
        for _, v in ipairs(Players:GetPlayers()) do
            if v.Name:lower() == username:lower() or v.DisplayName:lower() == username:lower() then
                foundTarget = v
                break
            end
        end
        if not foundTarget then
            local ok, uid = pcall(function()
                return Players:GetUserIdFromNameAsync(username)
            end)
            if ok and uid then
                foundTarget = {UserId = uid, Name = username}
            end
        end

        if not foundTarget then
            if getgenv().ShadowNotif then
                getgenv().ShadowNotif("Skin", "Joueur introuvable !", Color3.fromRGB(239,68,68))
            end
            return
        end

        local userId = foundTarget.UserId

        -- Charge la description
        local ok2, desc = pcall(function()
            return Players:GetHumanoidDescriptionFromUserId(userId)
        end)
        if not ok2 or not desc then
            if getgenv().ShadowNotif then
                getgenv().ShadowNotif("Skin", "Erreur chargement avatar !", Color3.fromRGB(239,68,68))
            end
            return
        end

        local char = Player.Character or Player.CharacterAdded:Wait()
        local hum  = char:WaitForChild("Humanoid", 10)
        if not hum then
            if getgenv().ShadowNotif then
                getgenv().ShadowNotif("Skin", "Humanoid introuvable !", Color3.fromRGB(239,68,68))
            end
            return
        end

        -- Nettoie exactement comme akuramaa
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic")
            or obj:IsA("Accessory") or obj:IsA("BodyColors") then
                obj:Destroy()
            end
        end
        local head = char:FindFirstChild("Head")
        if head then
            for _, d in ipairs(head:GetChildren()) do
                if d:IsA("Decal") then d:Destroy() end
            end
        end

        -- Applique exactement comme akuramaa
        local ok3 = pcall(function()
            hum:ApplyDescriptionClientServer(desc)
        end)

        if ok3 then
            if getgenv().ShadowNotif then
                getgenv().ShadowNotif("Skin Spoof", "Applique : @"..username, C.primary)
            end
        else
            if getgenv().ShadowNotif then
                getgenv().ShadowNotif("Skin", "Echec !", Color3.fromRGB(239,68,68))
            end
        end
    end

    local function restoreOwnSkin()
        local ok, desc = pcall(function()
            return Players:GetHumanoidDescriptionFromUserId(Player.UserId)
        end)
        if not ok or not desc then return end

        local char = Player.Character or Player.CharacterAdded:Wait()
        local hum  = char:WaitForChild("Humanoid", 10)
        if not hum then return end

        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic")
            or obj:IsA("Accessory") or obj:IsA("BodyColors") then
                obj:Destroy()
            end
        end
        local head = char:FindFirstChild("Head")
        if head then
            for _, d in ipairs(head:GetChildren()) do
                if d:IsA("Decal") then d:Destroy() end
            end
        end

        pcall(function()
            hum:ApplyDescriptionClientServer(desc)
        end)

        if getgenv().ShadowNotif then
            getgenv().ShadowNotif("Skin", "Restore !", Color3.fromRGB(130,125,155))
        end
    end

    pRow(ProfilePage,
        function() task.spawn(function() morphToUsername(inputSkin.Text) end) end,
        function() task.spawn(function() restoreOwnSkin() end) end
    )
end
 
end -- fin Profile Spoof
 
----------------------------------------------------
-- GAME SPOOF PAGE
----------------------------------------------------
do
local GameSpoofPage = Pages["GameSpoof"]
local gp = 0
local function GP() gp=gp+1; return gp end
 
local function gSec(txt)
    local f=Instance.new("Frame",GameSpoofPage)
    f.Size=UDim2.new(1,0,0,20); f.BackgroundTransparency=1; f.LayoutOrder=GP()
    local l=Instance.new("TextLabel",f)
    l.Size=UDim2.new(1,0,1,0); l.BackgroundTransparency=1
    l.FontFace=SILK; l.TextSize=9; l.TextColor3=C.textSub
    l.TextXAlignment=Enum.TextXAlignment.Left; l.Text=txt
end
 
local function gInput(lTxt, ph)
    local card=Instance.new("Frame",GameSpoofPage)
    card.Size=UDim2.new(1,0,0,52); card.BackgroundColor3=C.card
    card.BorderSizePixel=0; card.LayoutOrder=GP()
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,7)
    Instance.new("UIStroke",card).Color=C.border
    local lbl=Instance.new("TextLabel",card)
    lbl.Size=UDim2.new(1,-16,0,20); lbl.Position=UDim2.fromOffset(12,6)
    lbl.BackgroundTransparency=1; lbl.FontFace=SILK; lbl.TextSize=10
    lbl.TextColor3=C.textDim; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=lTxt
    local bg=Instance.new("Frame",card)
    bg.Size=UDim2.new(1,-16,0,22); bg.Position=UDim2.fromOffset(8,26)
    bg.BackgroundColor3=C.surface; bg.BorderSizePixel=0
    Instance.new("UICorner",bg).CornerRadius=UDim.new(0,5)
    Instance.new("UIStroke",bg).Color=C.border
    local inp=Instance.new("TextBox",bg)
    inp.Size=UDim2.new(1,-8,1,0); inp.Position=UDim2.fromOffset(4,0)
    inp.BackgroundTransparency=1; inp.FontFace=SILK; inp.TextSize=10
    inp.TextColor3=C.text; inp.PlaceholderText=ph
    inp.PlaceholderColor3=C.textSub; inp.TextXAlignment=Enum.TextXAlignment.Left
    inp.ClearTextOnFocus=false; inp.Text=""
    return card, inp
end
 
local function gRow(onA, onU)
    local row=Instance.new("Frame",GameSpoofPage)
    row.Size=UDim2.new(1,0,0,32); row.BackgroundTransparency=1; row.LayoutOrder=GP()
    local ll=Instance.new("UIListLayout",row)
    ll.FillDirection=Enum.FillDirection.Horizontal
    ll.Padding=UDim.new(0,8); ll.SortOrder=Enum.SortOrder.LayoutOrder
    local aBtn=Instance.new("TextButton",row)
    aBtn.Size=UDim2.new(0.5,-4,1,0); aBtn.BackgroundColor3=C.primary
    aBtn.BorderSizePixel=0; aBtn.FontFace=SILK; aBtn.TextSize=10
    aBtn.TextColor3=Color3.new(1,1,1); aBtn.Text="Apply"; aBtn.AutoButtonColor=false
    Instance.new("UICorner",aBtn).CornerRadius=UDim.new(0,6)
    local uBtn=Instance.new("TextButton",row)
    uBtn.Size=UDim2.new(0.5,-4,1,0); uBtn.BackgroundColor3=Color3.fromRGB(55,55,75)
    uBtn.BorderSizePixel=0; uBtn.FontFace=SILK; uBtn.TextSize=10
    uBtn.TextColor3=Color3.new(1,1,1); uBtn.Text="Unapply"; uBtn.AutoButtonColor=false
    Instance.new("UICorner",uBtn).CornerRadius=UDim.new(0,6)
    aBtn.MouseButton1Click:Connect(function() pcall(onA) end)
    uBtn.MouseButton1Click:Connect(function() pcall(onU) end)
end
 
gSec("LEADERBOARD RIVALS")
do
    local _, inputPos  = gInput("Position dans le classement (1-100)", "Ex: 1")
    local _, inputVal  = gInput("Valeur ELO / Score a afficher",       "Ex: 99999")
    local _, inputName = gInput("Pseudo affiche (vide = le tien)",     "Ex: SmurfPeak")

    do
        local ic = Instance.new("Frame", GameSpoofPage)
        ic.Size = UDim2.new(1,0,0,34)
        ic.BackgroundColor3 = Color3.fromRGB(20,20,28)
        ic.BorderSizePixel = 0
        ic.LayoutOrder = GP()
        Instance.new("UICorner", ic).CornerRadius = UDim.new(0,7)
        Instance.new("UIStroke", ic).Color = C.border
        local il = Instance.new("TextLabel", ic)
        il.Size = UDim2.new(1,-16,1,0)
        il.Position = UDim2.fromOffset(8,0)
        il.BackgroundTransparency = 1
        il.FontFace = SILK
        il.TextSize = 9
        il.TextColor3 = Color3.fromRGB(167,139,250)
        il.TextXAlignment = Enum.TextXAlignment.Left
        il.Text = "Ouvre le Leaderboard Rivals avant d'appliquer"
    end

    local lbActive      = false
    local lbPersistConn = nil
    local lbParams      = {pos=1, val="", name=""}

    -- Trouve TOUS les containers leaderboard actifs
    local function getAllContainers()
        local containers = {}
        local pg = Player.PlayerGui
        for _, child in ipairs(pg:GetChildren()) do
            if child.Name == "LeaderboardGui" then
                local list = child:FindFirstChild("List")
                if list then
                    local cont = list:FindFirstChild("Container")
                    if cont then
                        table.insert(containers, cont)
                    end
                end
            end
        end
        return containers
    end

    -- Detecte le type d'un TextLabel dans un slot
    -- Retourne "rank", "score", "displayname", "username", "other"
    local function detectType(text)
        if not text or text == "" then return "other" end
        local clean = text:gsub(",",""):gsub(" ",""):gsub("%.","")
        -- Rang : #1 / 1. / #12 etc
        if text:match("^#?%d+%.?$") then return "rank" end
        -- Score : nombre pur (peut avoir virgules/espaces)
        if tonumber(clean) ~= nil then return "score" end
        -- Username : commence par @
        if text:match("^@") then return "username" end
        -- DisplayName : texte alphanum
        if text:match("^[%w%s_%-%.]+$") and #text >= 2 then return "displayname" end
        return "other"
    end

    local function applyLBToContainer(container)
        local targetPos  = lbParams.pos
        local targetVal  = lbParams.val
        local myDisplay  = lbParams.name ~= "" and lbParams.name or Player.DisplayName
        local myUsername = "@" .. (lbParams.name ~= "" and lbParams.name or Player.Name)

        -- Trie les slots par position Y
        local slots = {}
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Frame") and child.Visible then
                table.insert(slots, child)
            end
        end
        table.sort(slots, function(a, b)
            return a.AbsolutePosition.Y < b.AbsolutePosition.Y
        end)

        local slot = slots[targetPos]
        if not slot then return end

        for _, desc in ipairs(slot:GetDescendants()) do
            if desc:IsA("TextLabel") and desc.Text ~= "" then
                local t = detectType(desc.Text)
                if t == "rank" then
                    desc.Text = "#" .. tostring(targetPos)
                elseif t == "score" and targetVal ~= "" then
                    -- Formate le score avec virgules si c'est un nombre
                    local num = tonumber(targetVal)
                    if num then
                        -- Format avec virgules : 99999 -> 99,999
                        local s = tostring(math.floor(num))
                        local result = ""
                        local count = 0
                        for i = #s, 1, -1 do
                            count = count + 1
                            result = s:sub(i,i) .. result
                            if count % 3 == 0 and i > 1 then
                                result = "," .. result
                            end
                        end
                        desc.Text = result
                    else
                        desc.Text = targetVal
                    end
                elseif t == "displayname" then
                    desc.Text = myDisplay
                elseif t == "username" then
                    desc.Text = myUsername
                end
            end
        end
    end

    local function applyLB()
        local containers = getAllContainers()
        for _, cont in ipairs(containers) do
            pcall(applyLBToContainer, cont)
        end
    end

    local function refreshRealLeaderboard()
        -- Fire le remote RequestLeaderboards pour recharger le vrai LB
        pcall(function()
            local remote = game:GetService("ReplicatedStorage")
                :FindFirstChild("Remotes")
                and game:GetService("ReplicatedStorage").Remotes
                :FindFirstChild("Misc")
                and game:GetService("ReplicatedStorage").Remotes.Misc
                :FindFirstChild("RequestLeaderboards")
            if remote then
                remote:FireServer()
            end
        end)
        -- Aussi essaie LeaderboardRefreshed
        pcall(function()
            local remote = game:GetService("ReplicatedStorage").Remotes.Misc.LeaderboardRefreshed
            if remote then
                remote:FireServer()
            end
        end)
    end

    local function startPersist()
        if lbPersistConn then
            lbPersistConn:Disconnect()
            lbPersistConn = nil
        end
        lbPersistConn = RunService.Heartbeat:Connect(function()
            if not lbActive then
                lbPersistConn:Disconnect()
                lbPersistConn = nil
                return
            end
            pcall(applyLB)
        end)
    end

    local function stopPersist()
        lbActive = false
        if lbPersistConn then
            lbPersistConn:Disconnect()
            lbPersistConn = nil
        end
        -- Refresh le vrai leaderboard
        refreshRealLeaderboard()
    end

    gRow(
        function()
            local pos = tonumber(inputPos.Text)
            if not pos then
                if getgenv().ShadowNotif then
                    getgenv().ShadowNotif(
                        "Leaderboard",
                        "Indique une position entre 1 et 100",
                        Color3.fromRGB(239,68,68)
                    )
                end
                return
            end

            lbParams.pos  = math.clamp(math.floor(pos), 1, 100)
            lbParams.val  = inputVal.Text
            lbParams.name = inputName.Text

            lbActive = true
            startPersist()

            local displayName = lbParams.name ~= "" and lbParams.name or Player.DisplayName

            if getgenv().ShadowNotif then
                getgenv().ShadowNotif(
                    "Leaderboard",
                    "#" .. tostring(lbParams.pos) .. " " .. displayName .. " — " .. lbParams.val,
                    C.primary
                )
            end
        end,
        function()
            stopPersist()
            if getgenv().ShadowNotif then
                getgenv().ShadowNotif(
                    "Leaderboard",
                    "Reinitialise",
                    Color3.fromRGB(130,125,155)
                )
            end
        end
    )
end
end -- fin Game Spoof
 
----------------------------------------------------
-- WEAPONS SPOOF PAGE
----------------------------------------------------
do
local WeaponsSpoofPage = Pages["WeaponsSpoof"]
local wp = 0
local function WP() wp=wp+1; return wp end
 
local function wSec(txt)
    local f=Instance.new("Frame",WeaponsSpoofPage)
    f.Size=UDim2.new(1,0,0,20); f.BackgroundTransparency=1; f.LayoutOrder=WP()
    local l=Instance.new("TextLabel",f)
    l.Size=UDim2.new(1,0,1,0); l.BackgroundTransparency=1
    l.FontFace=SILK; l.TextSize=9; l.TextColor3=C.textSub
    l.TextXAlignment=Enum.TextXAlignment.Left; l.Text=txt
end
 
local function wInput(lTxt, ph)
    local card=Instance.new("Frame",WeaponsSpoofPage)
    card.Size=UDim2.new(1,0,0,52); card.BackgroundColor3=C.card
    card.BorderSizePixel=0; card.LayoutOrder=WP()
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,7)
    Instance.new("UIStroke",card).Color=C.border
    local lbl=Instance.new("TextLabel",card)
    lbl.Size=UDim2.new(1,-16,0,20); lbl.Position=UDim2.fromOffset(12,6)
    lbl.BackgroundTransparency=1; lbl.FontFace=SILK; lbl.TextSize=10
    lbl.TextColor3=C.textDim; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.Text=lTxt
    local bg=Instance.new("Frame",card)
    bg.Size=UDim2.new(1,-16,0,22); bg.Position=UDim2.fromOffset(8,26)
    bg.BackgroundColor3=C.surface; bg.BorderSizePixel=0
    Instance.new("UICorner",bg).CornerRadius=UDim.new(0,5)
    Instance.new("UIStroke",bg).Color=C.border
    local inp=Instance.new("TextBox",bg)
    inp.Size=UDim2.new(1,-8,1,0); inp.Position=UDim2.fromOffset(4,0)
    inp.BackgroundTransparency=1; inp.FontFace=SILK; inp.TextSize=10
    inp.TextColor3=C.text; inp.PlaceholderText=ph
    inp.PlaceholderColor3=C.textSub; inp.TextXAlignment=Enum.TextXAlignment.Left
    inp.ClearTextOnFocus=false; inp.Text=""
    return card, inp
end
 
local function wRow(onA, onU)
    local row=Instance.new("Frame",WeaponsSpoofPage)
    row.Size=UDim2.new(1,0,0,32); row.BackgroundTransparency=1; row.LayoutOrder=WP()
    local ll=Instance.new("UIListLayout",row)
    ll.FillDirection=Enum.FillDirection.Horizontal
    ll.Padding=UDim.new(0,8); ll.SortOrder=Enum.SortOrder.LayoutOrder
    local aBtn=Instance.new("TextButton",row)
    aBtn.Size=UDim2.new(0.5,-4,1,0); aBtn.BackgroundColor3=C.primary
    aBtn.BorderSizePixel=0; aBtn.FontFace=SILK; aBtn.TextSize=10
    aBtn.TextColor3=Color3.new(1,1,1); aBtn.Text="Apply"; aBtn.AutoButtonColor=false
    Instance.new("UICorner",aBtn).CornerRadius=UDim.new(0,6)
    local uBtn=Instance.new("TextButton",row)
    uBtn.Size=UDim2.new(0.5,-4,1,0); uBtn.BackgroundColor3=Color3.fromRGB(55,55,75)
    uBtn.BorderSizePixel=0; uBtn.FontFace=SILK; uBtn.TextSize=10
    uBtn.TextColor3=Color3.new(1,1,1); uBtn.Text="Unapply"; uBtn.AutoButtonColor=false
    Instance.new("UICorner",uBtn).CornerRadius=UDim.new(0,6)
    aBtn.MouseButton1Click:Connect(function() pcall(onA) end)
    uBtn.MouseButton1Click:Connect(function() pcall(onU) end)
end
 
wSec("STATS DE L'ARME ACTUELLE")
do
    do
        local ic=Instance.new("Frame",WeaponsSpoofPage)
        ic.Size=UDim2.new(1,0,0,34); ic.BackgroundColor3=Color3.fromRGB(20,20,28)
        ic.BorderSizePixel=0; ic.LayoutOrder=WP()
        Instance.new("UICorner",ic).CornerRadius=UDim.new(0,7)
        Instance.new("UIStroke",ic).Color=C.border
        local il=Instance.new("TextLabel",ic)
        il.Size=UDim2.new(1,-16,1,0); il.Position=UDim2.fromOffset(8,0)
        il.BackgroundTransparency=1; il.FontFace=SILK; il.TextSize=9
        il.TextColor3=Color3.fromRGB(167,139,250); il.TextXAlignment=Enum.TextXAlignment.Left
        il.Text="ℹ  Ouvrez l'interface d'une arme dans Rivals avant Apply"
    end
    local _, inPT  = wInput("Playtime",                 "Ex: 120.5")
    local _, inW   = wInput("Wins",                     "Ex: 99999")
    local _, inL   = wInput("Losses",                   "Ex: 0")
    local _, inWP  = wInput("Win%",                     "Ex: 99.9")
    local _, inDMG = wInput("Damage",                   "Ex: 9999999")
    local _, inEL  = wInput("Eliminations",             "Ex: 99999")
    local _, inD   = wInput("Deaths",                   "Ex: 0")
    local _, inAS  = wInput("Assists",                  "Ex: 9999")
    local _, inH   = wInput("Hits",                     "Ex: 99999")
    local _, inHP  = wInput("Hit%",                     "Ex: 99.9")
    local _, inXP  = wInput("XP",                      "Ex: 999999")
    local _, inWL  = wInput("Level  (MAX = max level)", "Ex: 50 ou MAX")
    local origWS = {}
    wRow(
        function()
            local KW={
                {inp=inPT,  keys={"playtime","time played"}},
                {inp=inW,   keys={"wins"}},
                {inp=inL,   keys={"losses","loss"}},
                {inp=inWP,  keys={"win%","win rate","winrate"}},
                {inp=inDMG, keys={"damage","dmg"}},
                {inp=inEL,  keys={"elimination","elim","kill"}},
                {inp=inD,   keys={"death"}},
                {inp=inAS,  keys={"assist"}},
                {inp=inH,   keys={"hits"}},
                {inp=inHP,  keys={"hit%","hit rate","accuracy"}},
                {inp=inXP,  keys={"xp","experience"}},
                {inp=inWL,  keys={"level","lvl"}},
            }
            pcall(function()
                for _,d in ipairs(Player.PlayerGui:GetDescendants()) do
                    if d:IsA("TextLabel") and d.Text~="" then
                        for _,kw in ipairs(KW) do
                            if kw.inp.Text~="" then
                                local t=d.Text:lower()
                                for _,k in ipairs(kw.keys) do
                                    if t:find(k) then
                                        table.insert(origWS,{obj=d,text=d.Text})
                                        d.Text=kw.inp.Text; break
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            pcall(function()
                local rem=game:GetService("ReplicatedStorage"):FindFirstChild("Remotes",true)
                if rem then
                    local r=rem:FindFirstChild("SetWeaponStats",true) or rem:FindFirstChild("UpdateWeapon",true)
                    if r then r:FireServer({Playtime=tonumber(inPT.Text),Wins=tonumber(inW.Text),Losses=tonumber(inL.Text),WinPct=tonumber(inWP.Text),Damage=tonumber(inDMG.Text),Eliminations=tonumber(inEL.Text),Deaths=tonumber(inD.Text),Assists=tonumber(inAS.Text),Hits=tonumber(inH.Text),HitPct=tonumber(inHP.Text),XP=tonumber(inXP.Text),Level=inWL.Text=="MAX" and 999 or tonumber(inWL.Text)}) end
                end
            end)
            if getgenv().ShadowNotif then getgenv().ShadowNotif("Weapon Stats","Appliqué ✓",C.primary) end
        end,
        function()
            pcall(function()
                for _,e in ipairs(origWS) do pcall(function() e.obj.Text=e.text end) end
                origWS={}
            end)
            if getgenv().ShadowNotif then getgenv().ShadowNotif("Weapon Stats","Réinitialisé",Color3.fromRGB(130,125,155)) end
        end
    )
end
end -- fin Weapons Spoof

local currentKeybind = Enum.KeyCode.K
local panicKeybind = nil

----------------------------------------------------
-- SETTINGS PAGE
----------------------------------------------------
do
local SettingsPage = Pages["Settings"]
local so = 0; local function SO() so = so+1; return so end

local function setSection(label, order)
    local f = Instance.new("Frame", SettingsPage)
    f.Size = UDim2.new(1,0,0,20); f.BackgroundTransparency = 1; f.LayoutOrder = order
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1,0,1,0)
    l.BackgroundTransparency = 1; l.FontFace = SILK; l.TextSize = 9
    l.TextColor3 = C.textSub; l.TextXAlignment = Enum.TextXAlignment.Left; l.Text = label
end

local function setToggle(label, iconId, order, initVal, onToggle)
    local card = Instance.new("Frame", SettingsPage)
    card.Size = UDim2.new(1,0,0,52); card.BackgroundColor3 = C.card
    card.BorderSizePixel = 0; card.LayoutOrder = order
    Instance.new("UICorner", card).CornerRadius = UDim.new(0,7)
    Instance.new("UIStroke", card).Color = C.border
    local ico = Instance.new("ImageLabel", card)
    ico.Size = UDim2.fromOffset(18,18); ico.Position = UDim2.new(0,10,0,10)
    ico.BackgroundTransparency = 1; ico.Image = "rbxassetid://"..iconId
    ico.ImageColor3 = C.primary; ico.ScaleType = Enum.ScaleType.Fit
    local lbl = Instance.new("TextLabel", card)
    lbl.Size = UDim2.new(1,-100,0,20); lbl.Position = UDim2.fromOffset(34,6)
    lbl.BackgroundTransparency = 1; lbl.FontFace = SILK; lbl.TextSize = 10
    lbl.TextColor3 = C.text; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.Text = label
    local desc = Instance.new("TextLabel", card)
    desc.Size = UDim2.new(1,-54,0,18); desc.Position = UDim2.fromOffset(10,28)
    desc.BackgroundTransparency = 1; desc.FontFace = SILK; desc.TextSize = 8
    desc.TextColor3 = C.textDim; desc.TextXAlignment = Enum.TextXAlignment.Left; desc.Text = ""
    local st = {on = initVal or false}
    local track = Instance.new("TextButton", card)
    track.Size = UDim2.fromOffset(42,22); track.Position = UDim2.new(1,-54,0,8)
    track.BackgroundColor3 = st.on and C.primary or C.surface
    track.BorderSizePixel = 0; track.Text = ""; track.AutoButtonColor = false
    Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)
    Instance.new("UIStroke", track).Color = C.border
    local thumb = Instance.new("Frame", track)
    thumb.Size = UDim2.fromOffset(16,16)
    thumb.Position = st.on and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)
    thumb.BackgroundColor3 = Color3.new(1,1,1); thumb.BorderSizePixel = 0
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(1,0)
    track.MouseButton1Click:Connect(function()
        st.on = not st.on
        TweenService:Create(track, TweenInfo.new(0.12), {BackgroundColor3 = st.on and C.primary or C.surface}):Play()
        TweenService:Create(thumb, TweenInfo.new(0.12), {Position = st.on and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)}):Play()
        if onToggle then pcall(onToggle, st.on) end
        if getgenv().ShadowNotif then
            local c=st.on and Color3.fromRGB(34,197,94) or Color3.fromRGB(239,68,68)
            getgenv().ShadowNotif(label, st.on and "✓  Activé" or "✗  Désactivé", c)
        end
    end)
    return card, st, desc
end

local function applyStreamerMode(on)
    if on then
        WelcomeLbl.Text          = "Bienvenue **** !"
        infoDisplayNameLbl.Text  = "***"
        infoUsernameLbl.Text     = "***"
        infoUserIdLbl.Text       = "***"
    else
        WelcomeLbl.Text          = "Bienvenue "..Player.DisplayName.." !"
        infoDisplayNameLbl.Text  = Player.DisplayName
        infoUsernameLbl.Text     = "@"..Player.Name
        infoUserIdLbl.Text       = tostring(Player.UserId)
    end
end

setSection("MENU", SO())

do
    local kbCard = Instance.new("Frame", SettingsPage)
    kbCard.Size = UDim2.new(1,0,0,38); kbCard.BackgroundColor3 = C.card
    kbCard.BorderSizePixel = 0; kbCard.LayoutOrder = SO()
    Instance.new("UICorner", kbCard).CornerRadius = UDim.new(0,7)
    Instance.new("UIStroke", kbCard).Color = C.border

    local ico = Instance.new("ImageLabel", kbCard)
    ico.Size = UDim2.fromOffset(18,18); ico.Position = UDim2.new(0,10,0.5,-9)
    ico.BackgroundTransparency = 1; ico.Image = "rbxassetid://121529191602274"
    ico.ImageColor3 = C.primary; ico.ScaleType = Enum.ScaleType.Fit

    local lbl = Instance.new("TextLabel", kbCard)
    lbl.Size = UDim2.new(1,-160,1,0); lbl.Position = UDim2.fromOffset(34,0)
    lbl.BackgroundTransparency = 1; lbl.FontFace = SILK; lbl.TextSize = 10
    lbl.TextColor3 = C.text; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = "Keybind"

    local kbBtn = Instance.new("TextButton", kbCard)
    kbBtn.Size = UDim2.fromOffset(70,24); kbBtn.Position = UDim2.new(1,-82,0.5,-12)
    kbBtn.BackgroundColor3 = C.surface; kbBtn.BorderSizePixel = 0
    kbBtn.FontFace = SILK; kbBtn.TextSize = 10; kbBtn.TextColor3 = C.primary
    kbBtn.AutoButtonColor = false; kbBtn.Text = "K"
    Instance.new("UICorner", kbBtn).CornerRadius = UDim.new(0,5)
    Instance.new("UIStroke", kbBtn).Color = C.border

    local listening = false
    kbBtn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        kbBtn.Text = "..."; kbBtn.TextColor3 = C.accent
        TweenService:Create(kbBtn, TweenInfo.new(0.08), {BackgroundColor3 = C.surfaceHov}):Play()
        local conn
        conn = UIS.InputBegan:Connect(function(i, gp)
            if gp then return end
            if i.UserInputType == Enum.UserInputType.Keyboard then
                currentKeybind = i.KeyCode
                kbBtn.Text = i.KeyCode.Name
                kbBtn.TextColor3 = C.primary
                TweenService:Create(kbBtn, TweenInfo.new(0.08), {BackgroundColor3 = C.surface}):Play()
                listening = false; conn:Disconnect()
                if getgenv().ShadowNotif then getgenv().ShadowNotif("Keybind", "Touche : "..i.KeyCode.Name, Color3.fromRGB(139,92,246)) end
            end
        end)
    end)
    kbBtn.MouseEnter:Connect(function()
        if not listening then TweenService:Create(kbBtn, TweenInfo.new(0.08), {BackgroundColor3 = C.surfaceHov}):Play() end
    end)
    kbBtn.MouseLeave:Connect(function()
        if not listening then TweenService:Create(kbBtn, TweenInfo.new(0.08), {BackgroundColor3 = C.surface}):Play() end
    end)
end

do
    local pkCard = Instance.new("Frame", SettingsPage)
    pkCard.Size = UDim2.new(1,0,0,38)
    pkCard.BackgroundColor3 = C.card
    pkCard.BorderSizePixel = 0
    pkCard.LayoutOrder = SO()
    Instance.new("UICorner", pkCard).CornerRadius = UDim.new(0,7)
    Instance.new("UIStroke", pkCard).Color = C.border

    local ico = Instance.new("ImageLabel", pkCard)
    ico.Size = UDim2.fromOffset(18,18)
    ico.Position = UDim2.new(0,10,0.5,-9)
    ico.BackgroundTransparency = 1
    ico.Image = "rbxassetid://121529191602274"
    ico.ImageColor3 = C.primary
    ico.ScaleType = Enum.ScaleType.Fit

    local lbl = Instance.new("TextLabel", pkCard)
    lbl.Size = UDim2.new(1,-160,1,0)
    lbl.Position = UDim2.fromOffset(34,0)
    lbl.BackgroundTransparency = 1
    lbl.FontFace = SILK
    lbl.TextSize = 10
    lbl.TextColor3 = C.text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = "Panic Key"

    local pkBtn = Instance.new("TextButton", pkCard)
    pkBtn.Size = UDim2.fromOffset(70,24)
    pkBtn.Position = UDim2.new(1,-82,0.5,-12)
    pkBtn.BackgroundColor3 = C.surface
    pkBtn.BorderSizePixel = 0
    pkBtn.FontFace = SILK
    pkBtn.TextSize = 10
    pkBtn.TextColor3 = C.primary
    pkBtn.AutoButtonColor = false
    pkBtn.Text = "None"
    Instance.new("UICorner", pkBtn).CornerRadius = UDim.new(0,5)
    Instance.new("UIStroke", pkBtn).Color = C.border

    local listening = false

    pkBtn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        pkBtn.Text = "..."
        pkBtn.TextColor3 = C.accent
        TweenService:Create(pkBtn, TweenInfo.new(0.08), {BackgroundColor3 = C.surfaceHov}):Play()
        local conn
        conn = UIS.InputBegan:Connect(function(i, gp)
            if gp then return end
            if i.UserInputType == Enum.UserInputType.Keyboard then
                panicKeybind = i.KeyCode
                pkBtn.Text = i.KeyCode.Name
                pkBtn.TextColor3 = C.primary
                TweenService:Create(pkBtn, TweenInfo.new(0.08), {BackgroundColor3 = C.surface}):Play()
                listening = false
                conn:Disconnect()
                if getgenv().ShadowNotif then getgenv().ShadowNotif("Panic Key", "Touche : "..i.KeyCode.Name, Color3.fromRGB(239,68,68)) end
            end
        end)
    end)

    pkBtn.MouseEnter:Connect(function()
        if not listening then
            TweenService:Create(pkBtn, TweenInfo.new(0.08), {BackgroundColor3 = C.surfaceHov}):Play()
        end
    end)

    pkBtn.MouseLeave:Connect(function()
        if not listening then
            TweenService:Create(pkBtn, TweenInfo.new(0.08), {BackgroundColor3 = C.surface}):Play()
        end
    end)
end

do
    local siCard = Instance.new("Frame", SettingsPage)
    siCard.Size = UDim2.new(1,0,0,38); siCard.BackgroundColor3 = C.card
    siCard.BorderSizePixel = 0; siCard.LayoutOrder = SO()
    Instance.new("UICorner", siCard).CornerRadius = UDim.new(0,7)
    Instance.new("UIStroke", siCard).Color = C.border
    local ico = Instance.new("ImageLabel", siCard)
    ico.Size = UDim2.fromOffset(18,18); ico.Position = UDim2.new(0,10,0.5,-9)
    ico.BackgroundTransparency = 1; ico.Image = "rbxassetid://13492317602"
    ico.ImageColor3 = C.primary; ico.ScaleType = Enum.ScaleType.Fit
    local lbl = Instance.new("TextLabel", siCard)
    lbl.Size = UDim2.new(1,-160,1,0); lbl.Position = UDim2.fromOffset(34,0)
    lbl.BackgroundTransparency = 1; lbl.FontFace = SILK; lbl.TextSize = 10
    lbl.TextColor3 = C.text; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = "Silent Exécute"
    local siOn = getgenv().ShadowSilentMode == true
    local track = Instance.new("TextButton", siCard)
    track.Size = UDim2.fromOffset(42,22); track.Position = UDim2.new(1,-54,0.5,-11)
    track.BackgroundColor3 = siOn and C.primary or C.surface
    track.BorderSizePixel = 0; track.Text = ""; track.AutoButtonColor = false
    Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)
    Instance.new("UIStroke", track).Color = C.border
    local thumb = Instance.new("Frame", track)
    thumb.Size = UDim2.fromOffset(16,16)
    thumb.Position = siOn and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)
    thumb.BackgroundColor3 = Color3.new(1,1,1); thumb.BorderSizePixel = 0
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(1,0)
    track.MouseButton1Click:Connect(function()
        siOn = not siOn
        getgenv().ShadowSilentMode = siOn
        TweenService:Create(track,TweenInfo.new(0.12),{BackgroundColor3=siOn and C.primary or C.surface}):Play()
        TweenService:Create(thumb,TweenInfo.new(0.12),{Position=siOn and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)}):Play()
        if siOn then Main.Visible=false; stopCursor() end
    end)
end

do
    local nnCard = Instance.new("Frame", SettingsPage)
    nnCard.Size = UDim2.new(1,0,0,38); nnCard.BackgroundColor3 = C.card
    nnCard.BorderSizePixel = 0; nnCard.LayoutOrder = SO()
    Instance.new("UICorner", nnCard).CornerRadius = UDim.new(0,7)
    Instance.new("UIStroke", nnCard).Color = C.border
    local ico = Instance.new("ImageLabel", nnCard)
    ico.Size = UDim2.fromOffset(18,18); ico.Position = UDim2.new(0,10,0.5,-9)
    ico.BackgroundTransparency = 1; ico.Image = "rbxassetid://81868571746318"
    ico.ImageColor3 = C.primary; ico.ScaleType = Enum.ScaleType.Fit
    local lbl = Instance.new("TextLabel", nnCard)
    lbl.Size = UDim2.new(1,-160,1,0); lbl.Position = UDim2.fromOffset(34,0)
    lbl.BackgroundTransparency = 1; lbl.FontFace = SILK; lbl.TextSize = 10
    lbl.TextColor3 = C.text; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = "No Notifications"
    local nnOn = getgenv().ShadowNoNotif == true
    local track = Instance.new("TextButton", nnCard)
    track.Size = UDim2.fromOffset(42,22); track.Position = UDim2.new(1,-54,0.5,-11)
    track.BackgroundColor3 = nnOn and C.primary or C.surface
    track.BorderSizePixel = 0; track.Text = ""; track.AutoButtonColor = false
    Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)
    Instance.new("UIStroke", track).Color = C.border
    local thumb = Instance.new("Frame", track)
    thumb.Size = UDim2.fromOffset(16,16)
    thumb.Position = nnOn and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)
    thumb.BackgroundColor3 = Color3.new(1,1,1); thumb.BorderSizePixel = 0
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(1,0)
    track.MouseButton1Click:Connect(function()
        nnOn = not nnOn
        getgenv().ShadowNoNotif = nnOn
        TweenService:Create(track,TweenInfo.new(0.12),{BackgroundColor3=nnOn and C.primary or C.surface}):Play()
        TweenService:Create(thumb,TweenInfo.new(0.12),{Position=nnOn and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)}):Play()
        if nnOn then
            pcall(function()
                local sg=game:GetService("StarterGui")
                sg:SetCore("SendNotification",{Title="",Text="",Duration=0.01})
            end)
        end
    end)
end

do
    local aeOn = false
    pcall(function() aeOn = isfile("autoexec/ShadowGUI.lua") end)
    local aeCard = Instance.new("Frame", SettingsPage)
    aeCard.Size = UDim2.new(1,0,0,38); aeCard.BackgroundColor3 = C.card
    aeCard.BorderSizePixel = 0; aeCard.LayoutOrder = SO()
    Instance.new("UICorner", aeCard).CornerRadius = UDim.new(0,7)
    Instance.new("UIStroke", aeCard).Color = C.border
    local ico = Instance.new("ImageLabel", aeCard)
    ico.Size = UDim2.fromOffset(18,18); ico.Position = UDim2.new(0,10,0.5,-9)
    ico.BackgroundTransparency = 1; ico.Image = "rbxassetid://111380546906150"
    ico.ImageColor3 = C.primary; ico.ScaleType = Enum.ScaleType.Fit
    local lbl = Instance.new("TextLabel", aeCard)
    lbl.Size = UDim2.new(1,-160,1,0); lbl.Position = UDim2.fromOffset(34,0)
    lbl.BackgroundTransparency = 1; lbl.FontFace = SILK; lbl.TextSize = 10
    lbl.TextColor3 = C.text; lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = "Auto Exécute"
    local track = Instance.new("TextButton", aeCard)
    track.Size = UDim2.fromOffset(42,22); track.Position = UDim2.new(1,-54,0.5,-11)
    track.BackgroundColor3 = aeOn and C.primary or C.surface
    track.BorderSizePixel = 0; track.Text = ""; track.AutoButtonColor = false
    Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)
    Instance.new("UIStroke", track).Color = C.border
    local thumb = Instance.new("Frame", track)
    thumb.Size = UDim2.fromOffset(16,16)
    thumb.Position = aeOn and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)
    thumb.BackgroundColor3 = Color3.new(1,1,1); thumb.BorderSizePixel = 0
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(1,0)
    track.MouseButton1Click:Connect(function()
        aeOn = not aeOn
        TweenService:Create(track,TweenInfo.new(0.12),{BackgroundColor3=aeOn and C.primary or C.surface}):Play()
        TweenService:Create(thumb,TweenInfo.new(0.12),{Position=aeOn and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)}):Play()
        pcall(function()
            if aeOn then
                local src=""
                pcall(function() src=getscriptsource() end)
                if src~="" then writefile("autoexec/ShadowGUI.lua",src) end
            else
                delfile("autoexec/ShadowGUI.lua")
            end
        end)
    end)
end

setSection("GÉNÉRAL", SO())
local _,_,smDesc = setToggle("Streamer Mode", "9405931578", SO(), false, applyStreamerMode)
smDesc.Text = "Masque les infos du profil à l'écran"
end

----------------------------------------------------
-- KEYBINDS
----------------------------------------------------
task.defer(function()
    for _,obj in ipairs(ScreenGui:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            pcall(function() obj.FontFace=SILK end)
        end
    end
    ScreenGui.DescendantAdded:Connect(function(obj)
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            pcall(function() obj.FontFace=SILK end)
        end
    end)
end)

UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if panicKeybind and i.KeyCode == panicKeybind then
        stopCursor()
        pcall(function() CursorGui:Destroy() end)
        pcall(function() HudGui:Destroy() end)
        pcall(function() CrosshairGui:Destroy() end)
        pcall(function() FilterGui2:Destroy() end)
        pcall(function() Main:Destroy() end)
        pcall(function() ScreenGui:Destroy() end)
        return
    end
    if i.KeyCode==currentKeybind then
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            Main.Visible=false
            if _G.SB_SecretMain then _G.SB_SecretMain.Visible=not _G.SB_SecretMain.Visible end
        else
            Main.Visible=not Main.Visible
        end; return
    end
    if i.KeyCode==Enum.KeyCode.RightControl then Main.Visible=not Main.Visible; return end
    if i.KeyCode==Enum.KeyCode.Delete then stopCursor(); Main:Destroy(); ScreenGui:Destroy() end
end)
