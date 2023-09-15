local requests = require("requests")

vim.api.nvim_create_user_command("Requests", function()
    if not vim.g.requests_setup then
        requests.setup()
    end
    print("Done")
end, { desc = "Open Requests dashboard" })
