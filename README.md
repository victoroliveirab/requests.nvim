# Requests.nvim

A small plugin to make cURL requests to test http servers.

## Installation

With [packer](https://github.com/wbthomason/packer.nvim), add the following to your plugins:

```lua
use({
    "victoroliveirab/requests.nvim",
    config = function()
        require("requests").setup({
            -- Your settings
        })
    end,
})
```

## Settings

This plugin comes with the following default options:

```lua
{
    default_headers = {
        "accept:application/json, text/plain, */*",
        "cache-control:no-cache",
        "pragma:no-cache",
    },
    default_queries = {
        "key1:true",
        "key2:42"
    },
    default_body = "",
    default_url = "http://localhost:8080/",
    default_method = "GET"
}
```
By default it doesn't set a keymap to open the plugin window, but you are free to set one in your config.

## Usage

In order to use this plugin, either pass a keymap to the settings table or issue the command `:Requests`.
I personally use `<leader>r` as my keymap, so I have `keymap = "<leader>r"` in the config table.

> Add screenshots to showcase how to use and features.
