local views = require("requests.views")
local M = {}

---@class SetupParams
---@field hide string[]? Hide specific views
---@field default_headers string[]? Initial set headers when open plugin
---@field default_queries string[]? Initial set queries when open plugin
---@field default_body string? Initial body when open plugin
---@field default_url string? Initial endpoint URL when open plugin
---@field default_method string? Initial HTTP method when open plugin
---@field line_number boolean? Whether to show line numbers
---@field keymap string? Map a key combination to open requests.nvim

-- TODO: eventually this will receive parameters to control initial view, initial contents etc
---Setup requests.nvim
---@param params SetupParams?
M.setup = function(params)
    params = params or {}
    local default_headers = params.default_headers
        or {
            "accept:application/json, text/plain, */*",
            "cache-control:no-cache",
            "pragma:no-cache",
        }
    local default_queries = params.default_queries or { "key1:true", "key2:42" }
    local default_body = { params.default_body or "" }
    local default_url = params.default_url or "http://localhost:8080/"
    local default_method = params.default_method or "GET"
    views.register_view({
        id = "query",
        initial = default_queries,
        title = " Query Params ",
    })
    views.register_view({
        id = "headers",
        initial = default_headers,
        title = " Headers ",
    })
    views.register_view({ id = "body", initial = default_body, title = " Body " })
    views.register_view({
        id = "url",
        initial = { default_url, default_method },
        title = " URL ",
    })

    local keymap = params.keymap
    if keymap then
        vim.keymap.set("n", keymap, function()
            M.open()
        end)
    end

    local line_number = params.line_number
    if line_number then
        views.win_config.number = true
    end
    vim.g.requests_setup = 1
end

---Open plugin
---@param initial_view string? Initial View ID
M.open = function(initial_view)
    local view = initial_view or "query"
    views.open(view)
end

return M
