hs.window.animationDuration = 0
hyper       = {"cmd","alt","ctrl"}
shift_hyper = {"cmd","alt","ctrl","shift"}
ctrl_cmd    = {"cmd","ctrl"}

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true
Install=spoon.SpoonInstall

Install:andUse("WindowHalfsAndThirds",
               {
                 config = {
                   use_frame_correctness = true
                 },
                 hotkeys = 'default',
                -- loglevel = 'debug'
               }
)

Install:andUse("ClipboardTool",
               {
                 config = {
                   show_in_menubar = false,
                 },
                 hotkeys = {
                   toggle_clipboard = { { "cmd", "shift" }, "v" }
                 },
                 start = true,
               }
)
--[[ Install:andUse("Caffeine", {
                 start = true,
                 hotkeys = {
                   toggle = { hyper, "1" }
                 },
}) ]]
-- spoon.Caffeine:setState(true) 

Install:andUse("ReloadConfiguration", {
                 start = true,
                 hotkeys = {
                   reloadConfiguration = { ctrl_cmd, "r" }
                 },
})

-- Dismiss outlook events
local DismissHotkey = hs.hotkey.bind({ "cmd", "ctrl" }, "d", function()
    local DismissLoc = {}
    DismissLoc['y'] = 1100
    DismissLoc['x'] = 1750
    hs.eventtap.leftClick(DismissLoc)
end)

-- Normal binds
local select_all = hs.hotkey.new({"ctrl"}, "a", nil, function() hs.eventtap.keyStroke({"cmd"}, "a") end)
local word_left = hs.hotkey.new({"alt"}, "h", nil, function() hs.eventtap.keyStroke({"option"}, "left") end)
local word_right = hs.hotkey.new({"alt"}, "l", nil, function() hs.eventtap.keyStroke({"option"}, "right") end)

local up = hs.hotkey.new({"ctrl"}, "k", nil, function() hs.eventtap.keyStroke({}, "up") end)
local down = hs.hotkey.new({"ctrl"}, "j", nil, function() hs.eventtap.keyStroke({}, "down") end)
local left = hs.hotkey.new({"ctrl"}, "h", nil, function() hs.eventtap.keyStroke({}, "left") end)
local right = hs.hotkey.new({"ctrl"}, "l", nil, function() hs.eventtap.keyStroke({}, "right") end)


-- Outlook
local OutlookCalInbox = hs.window.filter.new("Microsoft Outlook")

-- Subscribe to when your Google Chrome window is focused and unfocused
OutlookCalInbox
    :subscribe(hs.window.filter.windowFocused, function()
        up:enable()
        down:enable()
        word_left:enable()
        word_right:enable()
    end)
    :subscribe(hs.window.filter.windowUnfocused, function()
        up:disable()
        down:disable()
        word_left:disable()
        word_right:disable()
    end)

-- Slack
local Slack_Hotkey = hs.window.filter.new("Slack")

Slack_Hotkey
    :subscribe(hs.window.filter.windowFocused, function()
        word_left:enable()
        word_right:enable()
    end)
    :subscribe(hs.window.filter.windowUnfocused, function()
        word_left:disable()
        word_right:disable()
    end)

-- Chrome
local Firefox = hs.window.filter.new("Firefox")
Firefox
    :subscribe(hs.window.filter.windowFocused, function()
        up:enable()
        down:enable()
        word_left:enable()
        word_right:enable()
    end)
    :subscribe(hs.window.filter.windowUnfocused, function()
        up:disable()
        down:disable()
        word_left:disable()
        word_right:disable()
    end)
