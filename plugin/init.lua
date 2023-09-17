local requests = require("requests")

vim.api.nvim_create_user_command("Requests", function()
    if vim.g.requests_win then
        vim.api.nvim_set_current_win(vim.g.requests_win)
        return
    end
    if not vim.g.requests_setup then
        requests.setup()
    end
    -- TODO: add autocomplete to go to specific View
    requests.open("query")
end, { desc = "Open Requests dashboard" })
