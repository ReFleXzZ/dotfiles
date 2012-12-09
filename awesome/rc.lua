------------------------------------
-- AwesomeWM 3.5rc1 config        --
-- based on: github.com/tdy/dots/ --
------------------------------------

local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
beautiful.init(awful.util.getdir("config") .. "/themes/dust/theme.lua")
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")
local wi = require("wi")

-- Compositing
awful.util.spawn_with_shell("xcompmgr -cF &")

-- {{{ Error handling
-- Startup
if awesome.startup_errors then
  naughty.notify({ preset = naughty.config.presets.critical,
      title = "Oops, there were errors during startup!",
      text = awesome.startup_errors })
end

-- Runtime
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err)
      if in_error then return end
      in_error = true

      naughty.notify({ preset = naughty.config.presets.critical,
          title = "Oops, an error happened!",
          text = err })
      in_error = false
    end)
end
-- }}}

-- {{{ Variables
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
pianobar_cmd = os.getenv("HOME") .. "bin/control-pianobar.sh "
pianobar_toggle   = pianobar_cmd .. "p"
pianobar_next     = pianobar_cmd .. "n"
pianobar_like     = pianobar_cmd .. "l"
pianobar_ban      = pianobar_cmd .. "b"
pianobar_tired    = pianobar_cmd .. "t"
pianobar_history  = pianobar_cmd .. "h"
pianobar_upcoming = pianobar_cmd .. "u"
pianobar_station  = pianobar_cmd .. "ss"
pianobar_playing  = pianobar_cmd .. "c"
pianobar_quit     = pianobar_cmd .. "q && screen -S pianobar -X quit"
pianobar_screen   = "screen -Sdm pianobar && screen -S pianobar -X screen " .. pianobar_toggle
modkey = "Mod4"
altkey = "Mod1"
-- }}}

-- {{{ Layouts
local layouts =
{
  awful.layout.suit.floating,
  awful.layout.suit.tile,
  awful.layout.suit.tile.left,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  awful.layout.suit.fair,
  awful.layout.suit.fair.horizontal,
  awful.layout.suit.spiral,
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier
}
-- }}}

-- {{{ Naughty presets
naughty.config.defaults.timeout = 5
naughty.config.defaults.screen = 1
naughty.config.defaults.position = "top_right"
naughty.config.defaults.margin = 8
naughty.config.defaults.gap = 1
naughty.config.defaults.ontop = true
naughty.config.defaults.font = "Monaco 18"
naughty.config.defaults.icon = nil
naughty.config.defaults.icon_size = 256
naughty.config.defaults.fg = beautiful.fg_tooltip
naughty.config.defaults.bg = beautiful.bg_tooltip
naughty.config.defaults.border_color = beautiful.border_tooltip
naughty.config.defaults.border_width = 2
naughty.config.defaults.hover_timeout = nil
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
  for s = 1, screen.count() do
    gears.wallpaper.maximized(beautiful.wallpaper, s, true)
  end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}

-- {{{ Shutdown
mylauncher = wibox.widget.imagebox()
mylauncher:set_image(beautiful.awesome_icon)
mylauncher:buttons(awful.util.table.join(
  awful.button({ }, 1, function () awful.util.spawn_with_shell("reboot.sh") end),
  awful.button({ modkey }, 1, function () awful.util.spawn_with_shell("shutdown.sh") end)
))
-- }}}

-- Menubar
menubar.utils.terminal = terminal

-- Clock
mytextclock = awful.widget.textclock("<span color='" .. beautiful.fg_em .. "'>%a %m/%d</span> @ %I:%M %p")

-- {{{ Wiboxes
mywibox = {}
mygraphbox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
  awful.button({ }, 1, awful.tag.viewonly),
  awful.button({ modkey }, 1, awful.client.movetotag),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, awful.client.toggletag),
  awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
  awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
  awful.button({ }, 1, function (c)
      if c == client.focus then
        c.minimized = true
      else
        c.minimized = false
        if not c:isvisible() then
          awful.tag.viewonly(c:tags()[1])
        end
        client.focus = c
        c:raise()
      end
    end),
  awful.button({ }, 3, function ()
      if instance then
        instance:hide()
        instance = nil
      else
        instance = awful.menu.clients({ width=250 })
      end
    end),
  awful.button({ }, 4, function ()
      awful.client.focus.byidx(1)
      if client.focus then client.focus:raise() end
    end),
  awful.button({ }, 5, function ()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
    end))

for s = 1, screen.count() do
  mypromptbox[s] = awful.widget.prompt()

  -- Layoutbox
  mylayoutbox[s] = awful.widget.layoutbox(s)
  mylayoutbox[s]:buttons(awful.util.table.join(
      awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
      awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
      awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
      awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

  -- Taglist
  mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

  -- Tasklist
  mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

  -- Wibox
  mywibox[s] = awful.wibox({ position = "top", height = 24, screen = s })

  local left_wibox = wibox.layout.fixed.horizontal()
  left_wibox:add(mytaglist[s])
  left_wibox:add(space)
  left_wibox:add(mypromptbox[s])
  left_wibox:add(mylayoutbox[s])
  left_wibox:add(space)

  local right_wibox = wibox.layout.fixed.horizontal()
  right_wibox:add(space)
  if s == 1 then right_wibox:add(wibox.widget.systray()) end
  right_wibox:add(mpdicon)
  right_wibox:add(mpdwidget)
  right_wibox:add(pacicon)
  right_wibox:add(pacwidget)
  right_wibox:add(baticon)
  right_wibox:add(batpct)
  right_wibox:add(volicon)
  right_wibox:add(volpct)
  right_wibox:add(volspace)
  right_wibox:add(mytextclock)

  local wibox_layout = wibox.layout.align.horizontal()
  wibox_layout:set_left(left_wibox)
  wibox_layout:set_middle(mytasklist[s])
  wibox_layout:set_right(right_wibox)

  mywibox[s]:set_widget(wibox_layout)

  -- Graphbox
  mygraphbox[s] = awful.wibox({ position = "bottom", height = 22, screen = s })

  local left_graphbox = wibox.layout.fixed.horizontal()
  left_graphbox:add(mylauncher)
  left_graphbox:add(space)
  left_graphbox:add(cpufreq)
  left_graphbox:add(cpugraph0)
  left_graphbox:add(cpupct0)
  left_graphbox:add(cpugraph1)
  left_graphbox:add(cpupct1)
  left_graphbox:add(cpugraph2)
  left_graphbox:add(cpupct2)
  left_graphbox:add(tab)
  left_graphbox:add(memused)
  left_graphbox:add(membar)
  left_graphbox:add(mempct)
  --[[ left_graphbox:add(tab)
  left_graphbox:add(rootfsused)
  left_graphbox:add(rootfsbar)
  left_graphbox:add(rootfspct)
  left_graphbox:add(tab)
  left_graphbox:add(txwidget)
  left_graphbox:add(upgraph)
  left_graphbox:add(upwidget)
  left_graphbox:add(tab)
  left_graphbox:add(rxwidget)
  left_graphbox:add(downgraph)
  left_graphbox:add(downwidget)
  --]]

  local right_graphbox = wibox.layout.fixed.horizontal()
  right_graphbox:add(weather)
  right_graphbox:add(space)
  right_graphbox:add(space)

  local graphbox_layout = wibox.layout.align.horizontal()
  graphbox_layout:set_left(left_graphbox)
  graphbox_layout:set_right(right_graphbox)

  mygraphbox[s]:set_widget(graphbox_layout)
end
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
  awful.key({ modkey, }, "Left", awful.tag.viewprev ),
  awful.key({ modkey, }, "Right", awful.tag.viewnext ),
  awful.key({ modkey, }, "Escape", awful.tag.history.restore),

  awful.key({ altkey, }, "Tab",
    function ()
      awful.client.focus.byidx( 1)
      if client.focus then client.focus:raise() end
    end),
  awful.key({ modkey, "Shift" }, "Tab",
    function ()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
    end),

  -- Layout manipulation
  awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.byidx( 1) end),
  awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.byidx(-1) end),
  awful.key({ modkey, }, "Tab", function () awful.screen.focus_relative( 1) end),
  awful.key({ modkey, "Shift" }, "Tab", function () awful.screen.focus_relative(-1) end),
  awful.key({ modkey, }, "u", awful.client.urgent.jumpto),
  awful.key({ modkey, }, "p", function() menubar.show() end),
  
  -- Standard program
  awful.key({ modkey, }, "Return", function () awful.util.spawn(terminal) end),
  awful.key({ modkey, "Control" }, "r", awesome.restart),
  awful.key({ modkey, "Shift" }, "q", awesome.quit),

  awful.key({ modkey, }, "l", function () awful.tag.incmwfact( 0.05) end),
  awful.key({ modkey, }, "h", function () awful.tag.incmwfact(-0.05) end),
  awful.key({ modkey, }, "k", function () awful.client.incwfact( 0.03) end),
  awful.key({ modkey, }, "j", function () awful.client.incwfact(-0.03) end),
  awful.key({ modkey, "Shift" }, "h", function () awful.tag.incnmaster( 1) end),
  awful.key({ modkey, "Shift" }, "l", function () awful.tag.incnmaster(-1) end),
  awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol( 1) end),
  awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1) end),
  awful.key({ modkey, }, "space", function () awful.layout.inc(layouts, 1) end),
  awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(layouts, -1) end),

  awful.key({ modkey, "Control" }, "n", awful.client.restore),

  -- Prompt
  awful.key({ altkey }, "F2", function () mypromptbox[mouse.screen]:run() end),

  awful.key({ modkey }, "x",
    function ()
      awful.prompt.run({ prompt = "Run Lua code: " },
        mypromptbox[mouse.screen].widget,
        awful.util.eval, nil,
        awful.util.getdir("cache") .. "/history_eval")
    end),

  -- Menubar
  awful.key({ modkey }, "r", function() menubar.show() end),

  -- {{{ Pianobar
  awful.key({ modkey }, "XF86AudioPrev", function ()
      awful.util.spawn_with_shell(pianobar_history)
    end),
  awful.key({ modkey }, "XF86AudioNext", function ()
      awful.util.spawn_with_shell(pianobar_next)
    end),
  awful.key({ modkey }, "XF86AudioPlay", function ()
      local f = io.popen("pgrep pianobar")
      p = f:read("*line")
      if p then
        awful.util.spawn_with_shell(pianobar_toggle)
      else
        awful.util.spawn_with_shell(pianobar_screen)
      end
    end),
  awful.key({ modkey, "Shift" }, "XF86AudioPlay", function ()
      awful.util.spawn_with_shell(pianobar_quit)
    end),
  awful.key({ modkey }, "=", function ()
      awful.util.spawn_with_shell(pianobar_like)
    end),
  awful.key({ modkey }, "-", function ()
      awful.util.spawn_with_shell(pianobar_ban)
    end),
  awful.key({ modkey, "Shift" }, "-", function ()
      awful.util.spawn_with_shell(pianobar_tired)
    end),
  awful.key({ modkey }, "[", function ()
      awful.util.spawn_with_shell(pianobar_station)
    end),
  awful.key({ modkey }, "]", function ()
      awful.util.spawn_with_shell(pianobar_upcoming)
    end),
  awful.key({ modkey }, "\\", function ()
      awful.util.spawn_with_shell(pianobar_playing)
    end),
  -- }}}

  -- {{{ Tag 0
  awful.key({ modkey }, 0,
    function ()
      local screen = mouse.screen
      if tags[screen][10].selected then
        awful.tag.history.restore(screen)
      elseif tags[screen][10] then
        awful.tag.viewonly(tags[screen][10])
      end
    end),
  awful.key({ modkey, "Control" }, 0,
    function ()
      local screen = mouse.screen
      if tags[screen][10] then
        tags[screen][10].selected = not tags[screen][10].selected
      end
    end),
  awful.key({ modkey, "Shift" }, 0,
    function ()
      if client.focus and tags[client.focus.screen][10] then
        awful.client.movetotag(tags[client.focus.screen][10])
      end
    end),
  awful.key({ modkey, "Control", "Shift" }, 0,
    function ()
      if client.focus and tags[client.focus.screen][10] then
        awful.client.toggletag(tags[client.focus.screen][10])
      end
    end)
  -- }}}
)

clientkeys = awful.util.table.join(
  awful.key({ modkey, }, "f", function (c) c.fullscreen = not c.fullscreen end),
  awful.key({ modkey, "Shift" }, "c", function (c) c:kill() end),
  awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle ),
  awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
  awful.key({ modkey, }, "o", awful.client.movetoscreen ),
  awful.key({ modkey, }, "t", function (c) c.ontop = not c.ontop end),
  awful.key({ modkey, }, "n",
    function (c)
      c.minimized = true
    end),
  awful.key({ modkey, }, "m",
    function (c)
      c.maximized_horizontal = not c.maximized_horizontal
      c.maximized_vertical = not c.maximized_vertical
    end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
  keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
  globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey }, "#" .. i + 9,
      function ()
        local screen = mouse.screen
        if tags[screen][i].selected then
          awful.tag.history.restore(screen)
        elseif tags[screen][i] then
          awful.tag.viewonly(tags[screen][i])
        end
      end),
    awful.key({ modkey, "Control" }, "#" .. i + 9,
      function ()
        local screen = mouse.screen
        if tags[screen][i] then
          awful.tag.viewtoggle(tags[screen][i])
        end
      end),
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
      function ()
        if client.focus and tags[client.focus.screen][i] then
          awful.client.movetotag(tags[client.focus.screen][i])
        end
      end),
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
      function ()
        if client.focus and tags[client.focus.screen][i] then
          awful.client.toggletag(tags[client.focus.screen][i])
        end
      end))
end

clientbuttons = awful.util.table.join(
  awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
  -- All clients will match this rule.
  { rule = { },
    properties = { border_width = beautiful.border_width,
     border_color = beautiful.border_normal,
     focus = awful.client.focus.filter,
     keys = clientkeys,
     buttons = clientbuttons } },
  { rule = { class = "MPlayer" },
      properties = { floating = true } },
  { rule = { class = "pinentry" },
    properties = { floating = true } },
  { rule = { class = "gimp" },
    properties = { floating = true } },
-- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
  -- Fullscreen flash
  { rule = { class = "Exe"}, properties = {floating = true} }
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
      -- Set the windows at the slave
      awful.client.setslave(c)

      -- Put windows in a smart way, only if they does not set an initial position
      if not c.size_hints.user_position and not c.size_hints.program_position then
        awful.placement.no_overlap(c)
        awful.placement.no_offscreen(c)
      end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
      local left_layout = wibox.layout.fixed.horizontal()
      left_layout:add(awful.titlebar.widget.iconwidget(c))

      local right_layout = wibox.layout.fixed.horizontal()
      right_layout:add(awful.titlebar.widget.floatingbutton(c))
      right_layout:add(awful.titlebar.widget.maximizedbutton(c))
      right_layout:add(awful.titlebar.widget.stickybutton(c))
      right_layout:add(awful.titlebar.widget.ontopbutton(c))
      right_layout:add(awful.titlebar.widget.closebutton(c))

      local title = awful.titlebar.widget.titlewidget(c)
      title:buttons(awful.util.table.join(
          awful.button({ }, 1, function()
              client.focus = c
              c:raise()
              awful.mouse.client.move(c)
            end),
          awful.button({ }, 3, function()
              client.focus = c
              c:raise()
              awful.mouse.client.resize(c)
            end)
      ))

      local layout = wibox.layout.align.horizontal()
      layout:set_left(left_layout)
      layout:set_right(right_layout)
      layout:set_middle(title)

      awful.titlebar(c):set_widget(layout)
    end
  end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}