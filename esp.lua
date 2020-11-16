local module = {}
module.Targets = {}

local Size = Vector3.new(2,3,0)
local Player = game.Players.LocalPlayer

function module.esp(Target)
    local BillboardGui = Instance.new("BillboardGui")
    local TextLabel = Instance.new("TextLabel")
    module.Targets[Target] = {
        Box = Drawing.new'Quad';
        Text = TextLabel
    }
    module.Targets[Target].Box.Thickness = 2
    module.Targets[Target].Box.Color = Color3.fromRGB(255,0,0)
    BillboardGui.Name = 'ESP'
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Size = UDim2.new(0, 5, 0, 5)
    BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)

    TextLabel.Parent = BillboardGui
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1
    TextLabel.BorderSizePixel = 0
    TextLabel.Size = UDim2.new(1, 0, 10, 0)
    TextLabel.Position = UDim2.new(0,0,0,-40)
    TextLabel.Font = Enum.Font.SourceSansBold
    TextLabel.FontSize = 'Size14'
    TextLabel.ZIndex = 10
    TextLabel.Text = Target.Name
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
end

local function getPositionFromIndex(Table, Index)
    local Num = 0
    for i, _ in next, Table do
        Num = Num + 1
        if i == Index then
            return Num
        end
    end
    return nil
end

local function findTable(Table, Value) -- checks the index too (NOT FULLY USELESS)
    for i, v in next, Table do
        if i == Value or v == Value then
            return getPositionFromIndex(Table, i)
        end
    end
    return nil
end

function module.unesp(Target)
    if module.Targets[Target] then
        local Table = module.Targets[Target]
        module.Targets[Target] = nil
        for i, Drawing in next, Table do
            Drawing:Remove()
        end
    end
end

local function FindFirstChild(self, Object)
    return self.FindFirstChild(self, Object)
end

local function WorldToViewportPoint(Pos)
    return workspace.CurrentCamera.WorldToViewportPoint(workspace.CurrentCamera, Pos)
end

game:GetService'RunService'.Stepped:Connect(function()
    for target, Table in next, module.Targets do
        if target and target.Character and Player and Player.Character and FindFirstChild(Player.Character, 'Torso') then
            local Root = FindFirstChild(target.Character, 'HumanoidRootPart') or FindFirstChild(target.Character, 'Torso')
            if not FindFirstChild(target.Character, 'Humanoid') or not Root then return end
            local TL, Visible = WorldToViewportPoint((Root.CFrame * CFrame.new(Size.X, Size.Y, 0)).Position)
            local TR = WorldToViewportPoint((Root.CFrame * CFrame.new(-Size.X, Size.Y, 0)).Position)
            local BL = WorldToViewportPoint((Root.CFrame * CFrame.new(Size.X, -Size.Y, 0)).Position)
            local BR = WorldToViewportPoint((Root.CFrame * CFrame.new(-Size.X, -Size.Y, 0)).Position)

            local Box, Label = Table.Box, Table.Text

            if Visible and Box and Label then
                Box.Visible = true
                Label.TextTransparency = 0
                Label.Parent.Parent = Root
                Label.Parent.Adornee = Root
                Label.Text = target.Name .. ' [' .. math.floor(target.Character.Humanoid.Health) .. '/' .. math.floor(target.Character.Humanoid.MaxHealth) .. '] [' .. math.floor(target:DistanceFromCharacter(Player.Character.Torso.Position)) .. ']'
                Box.PointA = Vector2.new(TL.X, TL.Y)
                Box.PointB = Vector2.new(TR.X, TR.Y)
                Box.PointC = Vector2.new(BR.X, BR.Y)
                Box.PointD = Vector2.new(BL.X, BL.Y)
            else
                Box.Visible = false
                Label.TextTransparency = 1
            end
        end
    end
end)
