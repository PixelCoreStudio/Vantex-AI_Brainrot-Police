return {
	-- Fonts
	Font = Enum.Font.GothamMedium,
	FontBold = Enum.Font.GothamBold,

	-- Corner rounding
	CornerRadius = UDim.new(0, 8),
	ElementRadius = UDim.new(0, 8),

	-- Core colors
	Background = Color3.fromRGB(11, 11, 14),
	Topbar = Color3.fromRGB(26, 26, 46),
	TabBar = Color3.fromRGB(26, 26, 46),
	ElementBg = Color3.fromRGB(26, 26, 46),
	ElementHoverBg = Color3.fromRGB(42, 33, 64),

	-- Text colors
	Text = Color3.fromRGB(255, 255, 255),
	SubText = Color3.fromRGB(143, 143, 143),

	-- Accent / toggle colors
	Accent = Color3.fromRGB(160, 32, 240),
	ToggleOn = Color3.fromRGB(160, 32, 240),
	ToggleOff = Color3.fromRGB(50, 50, 64),

	-- Transparencies (0 = fully opaque, 1 = fully invisible)
	PanelTransparency = 0.30,
	ElementTransparency = 0.35,
	ElementHoverTransparency = 0.08,
	StrokeTransparency = 1,
	StrokeHoverTransparency = 0.35,
	WindowStrokeTransparency = 0.45,

	WindowSize = UDim2.new(0, 550, 0, 350),
	WindowPosition = UDim2.new(0.5, -275, 0.5, -175),

	-- Layout metrics
	TopbarHeight = 40,
	TabBarWidth = 130,
	ElementHeight = 36,
}
