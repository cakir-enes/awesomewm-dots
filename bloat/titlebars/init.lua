local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

local add_decorations = function(c)
    require("bloat.titlebars.top")(c)
    require("bloat.titlebars.left")(c)
    require("bloat.titlebars.right")(c)
    require("bloat.titlebars.bottom")(c)
end

local enable_tb = function(c)
    if not c.requests_no_titlebar then
        add_decorations(c)
        c.border_width = 0
    end
end

local disable_tb = function(c)
    awful.titlebar.hide(c, "top")
    awful.titlebar.hide(c, "bottom")
    awful.titlebar.hide(c, "right")
    awful.titlebar.hide(c, "left")
    c.border_width = 2
end

client.connect_signal("request::titlebars", function(c)

    client.connect_signal("property::floating", function(c)
        local b = false;
        if c.first_tag ~= nil then
            b = c.first_tag.layout.name == "floating"
        end
        if c.floating or b then
            enable_tb(c)
        else
            if not c.bling_tabbed then disable_tb(c) end
        end
    end)

    client.connect_signal("manage", function(c)
        if c.floating or c.first_tag.layout.name == "floating" then
            enable_tb(c)
        else
            if not c.bling_tabbed then disable_tb(c) end
        end
    end)

    tag.connect_signal("property::layout", function(t)
        local clients = t:clients()
        for k, c in pairs(clients) do
            if c.floating or c.first_tag.layout.name == "floating" then
                enable_tb(c)
            else
                if not c.bling_tabbed then disable_tb(c) end
            end
        end
    end)

end)
