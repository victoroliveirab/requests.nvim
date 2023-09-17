local run = require("requests.run")

local set_autocmds = require("requests.views.autocmds")

local LSP_TIMEOUT = 3000
local LSP_INTERVAL_CHECK = 200

local set_keymaps
---Set all relevant keymaps to a view
---@param state ViewsState View handler's state
---@param bufnr number Buffer ID
set_keymaps = function(state, bufnr)
    for index, id in ipairs(state.order) do
        vim.keymap.set("n", tostring(index), function()
            state.set_view(id)
        end, { buffer = bufnr })
    end
    vim.keymap.set("n", "0", function()
        state.set_view("response")
    end)

    vim.keymap.set("n", "=", function()
        local tbl = {}
        for _, id in ipairs(state.order) do
            ---@type number
            local buffer = state.views[id].buffer
            local buffer_size = vim.api.nvim_buf_line_count(buffer)
            tbl[id] = vim.api.nvim_buf_get_lines(buffer, 0, buffer_size, false)
        end
        local response = run(tbl)

        if state.json_file then
            vim.api.nvim_buf_delete(state.json_file, { force = true })
        end
        local new_buffer = vim.api.nvim_create_buf(true, false)
        local now = tostring(os.date("%Y-%m-%d:%H:%M:%S"))
        local filename = string.format("%s.json", now)
        vim.api.nvim_buf_set_name(new_buffer, filename)
        vim.api.nvim_buf_set_lines(new_buffer, 0, 0, false, { response.body })
        vim.api.nvim_win_set_buf(state.win, new_buffer)
        vim.api.nvim_win_set_config(state.win, { title = " Response ", title_pos = "center" })
        vim.bo[new_buffer].filetype = "json"

        state.json_file = new_buffer
        set_autocmds.quit_pre(state, new_buffer)
        set_keymaps(state, new_buffer)

        local defer_format = function()
            if #vim.lsp.get_active_clients({ bufnr = new_buffer }) > 0 then
                vim.lsp.buf.format({ async = true, bufnr = new_buffer })
                return true
            end
            return false
        end
        -- Wait for LSP to attach to buffer
        vim.wait(LSP_TIMEOUT, defer_format, LSP_INTERVAL_CHECK)
    end, { buffer = bufnr })
end

return set_keymaps
