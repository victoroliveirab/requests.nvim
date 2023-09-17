---Attach QuitPre event to buffer
---@param state ViewsState Views handler's state
---@param bufnr number Buffer ID
local attach_quit_pre = function(state, bufnr)
    vim.api.nvim_create_autocmd("QuitPre", {
        callback = function(p)
            ---@type number
            local win = state.win
            state.win = nil
            vim.g.requests_win = nil
            vim.api.nvim_win_close(win, true)
            if state.json_file then
                vim.api.nvim_buf_delete(state.json_file, { force = true })
                state.json_file = nil
            end
            for _, view in pairs(state.views) do
                ---@type number
                local buffer = view.buffer
                if p.buf ~= buffer then
                    vim.api.nvim_buf_delete(buffer, { force = true })
                end
            end
        end,
        buffer = bufnr,
    })
end

return {
    quit_pre = attach_quit_pre,
}
