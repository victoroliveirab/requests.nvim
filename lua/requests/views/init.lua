local set_autocmds = require("requests.views.autocmds")
local set_keymaps = require("requests.views.keymaps")

---@class ViewsState
---@field initialized boolean
---@field json_file number?
---@field order string[]
---@field views { buffer: number?, initial_content: string[]?, title: string }[]
---@field win number?
local M = {
    initialized = false,
    json_file = nil,
    order = {},
    views = {},
    win = nil,
}

---Create buffers for all views, set initial content, keymaps and autocmds
M.setup = function()
    for _, id in ipairs(M.order) do
        local buffer = vim.api.nvim_create_buf(false, true)
        M.views[id].buffer = buffer
        local initial = M.views[id].initial_content
        if initial and type(initial) == "table" then
            vim.api.nvim_buf_set_lines(buffer, 0, 0, false, initial)
        end
        set_keymaps(M, buffer)
        set_autocmds.quit_pre(M, buffer)
    end
    M.initialized = true
end

---@class RegisterViewParams
---@field id string
---@field initial string[]?
---@field title string

---Register a view. Only registered views will be created
---@param params RegisterViewParams
M.register_view = function(params)
    local id = params.id
    local initial = params.initial
    local title = params.title
    M.views[id] = {
        buffer = nil,
        initial_content = initial,
        title = title,
    }
    table.insert(M.order, id)
end

---Opens requests.nvim window
---@param view string? View ID to open
M.open = function(view)
    if not M.initialized then
        M.setup()
    end
    M.set_view(view or "query")
end

---Set current requests.nvim view
---@param id string View ID to set
M.set_view = function(id)
    if id == "response" then
        if M.json_file then
            vim.api.nvim_win_set_buf(M.win, M.json_file)
            vim.api.nvim_win_set_config(M.win, { title_pos = "center", title = " Response " })
        end
        return
    end
    if M.win then
        vim.api.nvim_win_set_buf(M.win, M.views[id].buffer)
        vim.api.nvim_win_set_config(M.win, {
            title_pos = "center",
            title = M.views[id].title,
        })
        return
    end
    M.win = vim.api.nvim_open_win(M.views[id].buffer, true, {
        height = 25,
        width = 100,
        relative = "editor",
        border = "double",
        row = 5,
        col = 5,
        style = "minimal",
        title_pos = "center",
        title = M.views[id].title,
    })
    vim.g.requests_win = M.win
end

---Inspect current state
M.debug = function()
    print(vim.inspect(M))
end

return M
