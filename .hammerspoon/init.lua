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

--[[ Install:andUse("TextClipboardHistory",
               {
                 -- disable = true,
                 config = {
                   show_in_menubar = false,
                 },
                 hotkeys = {
                   toggle_clipboard = { { "cmd", "shift" }, "v" }
                 },
                 start = true,
               }
) ]]

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

Install:andUse("Caffeine", {
                 start = true,
                 hotkeys = {
                   toggle = { hyper, "1" }
                 },
                -- fn = BTT_caffeine_widget,
})
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
local delete = hs.hotkey.new({"cmd"}, "delete", nil, function() hs.eventtap.keyStroke({"option"}, "delete") end)

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
    end)
    :subscribe(hs.window.filter.windowUnfocused, function()
        up:disable()
        down:disable()
    end)

-- Slack
local slack_k = hs.hotkey.new({"ctrl"}, "k", nil, function() hs.eventtap.keyStroke({"cmd"}, "k") end)
local Slack_Hotkey = hs.window.filter.new("Slack")

Slack_Hotkey
    :subscribe(hs.window.filter.windowFocused, function()
        slack_k:enable()
        delete:enable()
    end)
    :subscribe(hs.window.filter.windowUnfocused, function()
        slack_k:disable()
        delete:disable()
    end)

-- Chrome
local Firefox = hs.window.filter.new("Firefox")
Firefox
    :subscribe(hs.window.filter.windowFocused, function()
        up:enable()
        down:enable()
        delete:enable()
    end)
    :subscribe(hs.window.filter.windowUnfocused, function()
        delete:disable()
        up:disable()
        down:disable()
    end)
