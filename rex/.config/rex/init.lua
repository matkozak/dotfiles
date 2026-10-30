-- Rex: tmux keymap on cmd+space (tmux itself keeps ctrl+space in containers)

local P = "cmd+space>"

-- Splits (mnemonic: / and -)
rex.bind(P .. "/", "pane.split.right")
rex.bind(P .. "-", "pane.split.down")

-- Pane navigation (vim-style)
rex.bind(P .. "h", "pane.focus.left")
rex.bind(P .. "j", "pane.focus.down")
rex.bind(P .. "k", "pane.focus.up")
rex.bind(P .. "l", "pane.focus.right")

rex.bind(P .. "z", "pane.zoom")
rex.bind(P .. "x", "client.close") -- pane, then tab (like cmd+w)

-- Tabs (= tmux windows)
rex.bind(P .. "c", "client.tab.new")
rex.bind(P .. "n", "client.tab.next")
rex.bind(P .. "p", "client.tab.previous")
for i = 1, 9 do
  rex.bind(P .. tostring(i), "client.tab.goto", { index = i })
end

-- Sessions (c = tab, C = session)
rex.bind(P .. "shift+c", "session.new")
rex.bind(P .. "s", "session.switch")

-- Rename (tmux: $ session, comma window, here a tab)
rex.bind(P .. "shift+4", "session.rename")
rex.bind(P .. ",", "client.tab.rename")

rex.bind(P .. "r", "client.config.reload")

-- Double-tap sends a literal cmd+space
rex.bind(P .. "cmd+space", "pane.send_key", { key = "cmd+space" })
