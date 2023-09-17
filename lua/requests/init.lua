local views = require("requests.views")
local M = {}

-- TODO: eventually this will receive parameters to control initial view, initial contents etc
---Setup requests.nvim
M.setup = function()
    vim.g.requests_setup = 1
    views.register_view({
        id = "query",
        initial = { "name:victor", "key1:true", "key2:42" },
        title = " Query Params ",
    })
    views.register_view({
        id = "headers",
        initial = {
            "accept:application/json, text/plain, */*",
            "cache-control:no-cache",
            "pragma:no-cache",
        },
        title = " Headers ",
    })
    views.register_view({ id = "body", title = " Body " })
    views.register_view({
        id = "url",
        initial = { "http://localhost:8080/", "GET" },
        title = " URL ",
    })
end

---Open plugin
---@param initial_view string? Initial View ID
M.open = function(initial_view)
    local view = initial_view or "query"
    views.open(view)
end

return M
