local requests = require("requests")

local available_args = {
    "empty",
    "body",
    "header",
    "query",
    "url",
}

vim.api.nvim_create_user_command("Requests", function(command)
    if vim.g.requests_win then
        vim.api.nvim_set_current_win(vim.g.requests_win)
        return
    end
    if not vim.g.requests_setup then
        requests.setup()
    end
    local arg = command.fargs[1]
    if arg == "empty" then
        requests.open("query", true)
        return
    end
    requests.open(arg)
end, {
    desc = "Open Requests dashboard",
    nargs = "?",
    complete = function(arg)
        return vim.tbl_filter(function(value)
            return vim.startswith(value, arg)
        end, available_args)
    end,
})
