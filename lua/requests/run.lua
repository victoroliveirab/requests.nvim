local curl = require("plenary.curl")

---Parse array of strings to kv pairs
---@param arr string[] Array of strings of format key:value
---@return table<string, string>
local parse_array = function(arr)
    local parsed_tbl = {}
    for _, item in ipairs(arr) do
        local parsed = vim.split(item, ":", { plain = true, trimempty = true })
        local raw_key, value = unpack(parsed)
        local key = not vim.startswith(raw_key or "", "//") and raw_key or nil
        -- TODO: add option to treat // as comment after value
        -- local value =
        --     unpack(vim.split(vim.trim(raw_value or ""), "//", { plain = true, trimempty = true }))
        if key and value then
            parsed_tbl[key] = value
        end
    end
    return parsed_tbl
end

---@class RunParams
---@field headers string[] HTTP Headers
---@field query string[] HTTP Query Parameters
---@field url string[] Endpoint's URL

---Run the HTTP request
---@param params RunParams
---@return { status: number, body: string }
local run = function(params)
    local headers = parse_array(params.headers)
    local query = parse_array(params.query)
    local url = params.url[1]
    local method = string.lower(params.url[2])
    local response = curl[method](url, { headers = headers, query = query })
    local status = response.exit ~= 0 and 500 or response.status
    local body = response.body
    return {
        status = status,
        body = body,
    }
end

return run
