local P,R,U,L=game:GetService("Players"),game:GetService("RunService"),game:GetService("UserInputService"),game:GetService("Lighting")
local LP,C=P.LocalPlayer,workspace.CurrentCamera
local S={ESP=true,Walls=false,Potato=false,Menu=true}
local OM,OT,ESP={},{},{}
local SG=Instance.new("ScreenGui") SG.Name,SG.ResetOnSpawn="K",false pcall(function() SG.Parent=game:GetService("CoreGui") end) if not SG.Parent then SG.Parent=LP:WaitForChild("PlayerGui") end
local MB=Instance.new("TextButton",SG) MB.Size,MB.Position,MB.BackgroundColor3,MB.Text,MB.TextColor3,MB.Font,MB.TextSize=UDim2.new(0,60,0,60),UDim2.new(0,20,0,20),Color3.fromRGB(128,0,255),"K",Color3.fromRGB(255,255,255),Enum.Font.GothamBold,24 Instance.new("UICorner",MB).CornerRadius=UDim.new(1,0)
local MF=Instance.new("Frame",SG) MF.Size,MF.Position,MF.BackgroundColor3,MF.BorderSizePixel,MF.Active,MF.Draggable=UDim2.new(0,320,0,300),UDim2.new(0,20,0,40),Color3.fromRGB(25,10,40),0,true,true Instance.new("UICorner",MF).CornerRadius=UDim.new(0,8)
local function CB(txt,y) local b=Instance.new("TextButton",MF) b.Size,b.Position,b.BackgroundColor3,b.Text,b.TextColor3,b.Font,b.TextSize=UDim2.new(0,280,0,35),UDim2.new(0,20,0,y),Color3.fromRGB(50,20,80),txt,Color3.fromRGB(220,220,220),Enum.Font.GothamSemibold,13 Instance.new("UICorner",b).CornerRadius=UDim.new(0,6) return b end
local EB,PotB,WallB=CB("ESP: ON",20),CB("POTATO: OFF",65),CB("X-RAY: OFF",110)
local function UB(b,en,tOn,tOff) b.Text=en and tOn or tOff b.BackgroundColor3=en and Color3.fromRGB(128,0,255) or Color3.fromRGB(50,20,80) end
local function TM() S.Menu=not S.Menu MF.Visible=S.Menu end
MB.MouseButton1Click:Connect(TM) MF.Visible=false
EB.MouseButton1Click:Connect(function() S.ESP=not S.ESP UB(EB,S.ESP,"ESP: ON","ESP: OFF") end)
PotB.MouseButton1Click:Connect(function() S.Potato=not S.Potato UB(PotB,S.Potato,"POTATO: ON","POTATO: OFF") if S.Potato then for _,o in pairs(workspace:GetDescendants()) do if o:IsA("BasePart") then if o.Name:lower():find("grass") or o.Name:lower():find("weed") or o.Name:lower():find("bush") or o.Name:lower():find("leaf") then o.Transparency=1 o.CanCollide=false end if o.Material~=Enum.Material.SmoothPlastic then OT[o]=o.Material o.Material=Enum.Material.SmoothPlastic end end end L.GlobalShadows=false L.FogEnd=100 else for o,m in pairs(OT) do if o and o.Parent then o.Material=m end end OT={} L.GlobalShadows=true end end)
local function ApplyWall() if not S.Walls then return end pcall(function() for _,o in pairs(workspace:GetDescendants()) do if o:IsA("BasePart") and not o:IsDescendantOf(LP.Character) and not o.Parent:FindFirstChild("Humanoid") and not o:IsA("Tool") then if not OM[o] then OM[o]={o.LocalTransparencyModifier,o.Transparency,o.Material} end o.LocalTransparencyModifier,o.Transparency=0.65,0.65 o.Material=Enum.Material.Plastic end end end) end
local function ResetWall() for p,o in pairs(OM) do if p and p.Parent then p.LocalTransparencyModifier,p.Transparency,p.Material=o[1],o[2],o[3] end end OM={} end
WallB.MouseButton1Click:Connect(function() S.Walls=not S.Walls UB(WallB,S.Walls,"X-RAY: ON","X-RAY: OFF") if S.Walls then ApplyWall() else ResetWall() end end)
R.Heartbeat:Connect(function() if S.Walls then ApplyWall() elseif next(OM) then ResetWall() end end)
local function GE(p) if not ESP[p] then local b,n,hB,hF=Drawing.new("Square"),Drawing.new("Text"),Drawing.new("Square"),Drawing.new("Square") b.Thickness,b.Color,b.Filled,b.Transparency=1.5,Color3.fromRGB(255,0,0),false,1 n.Size,n.Center,n.Outline,n.Color,n.Font=16,true,true,Color3.fromRGB(255,255,255),2 hB.Thickness,hB.Color,hB.Filled,hB.Transparency=1,Color3.fromRGB(0,0,0),true,0.5 hF.Thickness,hF.Color,hF.Filled,hF.Transparency=1,Color3.fromRGB(0,255,0),true,1 ESP[p]={Box=b,Name=n,HealthBg=hB,HealthFill=hF} end return ESP[p] end
R.RenderStepped:Connect(function()
    local mc=LP.Character local mh=mc and mc:FindFirstChild("HumanoidRootPart") local mu=mc and mc:FindFirstChild("Humanoid") if not mh or not mu or mu.Health<=0 then return end
    for p,e in pairs(ESP) do e.Box.Visible,e.Name.Visible,e.HealthBg.Visible,e.HealthFill.Visible=false,false,false,false end
    pcall(function()
        for _,p in pairs(P:GetPlayers()) do if p~=LP and p.Character then local h,hd,u=p.Character:FindFirstChild("HumanoidRootPart"),p.Character:FindFirstChild("Head"),p.Character:FindFirstChild("Humanoid") local d=h and math.floor((h.Position-mh.Position).Magnitude) or 0
            if h and hd and u and u.Health>0 then local tS,oS1=C:WorldToViewportPoint(hd.Position+Vector3.new(0,0.5,0)) local bS,oS2=C:WorldToViewportPoint(h.Position-Vector3.new(0,3,0))
                if oS1 and oS2 then local rp=RaycastParams.new() rp.FilterDescendantsInstances={LP.Character,p.Character} rp.FilterType=Enum.RaycastFilterType.Exclude local rr=workspace:Raycast(C.CFrame.Position,((h.Position+Vector3.new(0,0.5,0))-C.CFrame.Position),rp) local iV=not rr local cC=iV and Color3.fromRGB(255,255,0) or Color3.fromRGB(255,0,0)
                    if S.ESP then local e=GE(p) local hp=math.floor(u.Health) local w="Fists" local t=p.Character:FindFirstChildOfClass("Tool") if t then w=t.Name end local hg=bS.Y-tS.Y local wd=hg*0.45 local x=bS.X-(wd/2) local y=tS.Y
                        e.Box.Size,e.Box.Position,e.Box.Color,e.Box.Visible=Vector2.new(wd,hg),Vector2.new(x,y),cC,true local hH=hg*(hp/100) e.HealthBg.Size,e.HealthBg.Position,e.HealthBg.Visible=Vector2.new(2,hg),Vector2.new(x-5,y),true e.HealthFill.Size,e.HealthFill.Position,e.HealthFill.Color,e.HealthFill.Visible=Vector2.new(2,hH),Vector2.new(x-5,y+(hg-hH)),Color3.fromRGB(0,255,0),true e.Name.Text,e.Name.Position,e.Name.Visible=string.format("[%s] HP: %d | %dm",w,hp,d),Vector2.new(bS.X,y-20),true
                    end
                end
            end
        end end
    end)
end)
