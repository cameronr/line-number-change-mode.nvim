# line-number-change-mode.nvim

A Neovim plugin that allows you to change the color and text decoration of a line number when the mode changes.  Accepts anything that `vim.api.nvim_set_hl()` accepts!

[line-number-change-mode.webm](https://github.com/user-attachments/assets/3248d489-7787-479b-9313-86e38f392466)

Example using `lazy`:

```lua
return {
    'sethen/line-number-change-mode.nvim',
    config = function()
        require('catppuccin').setup({
            flavour = 'mocha',
        });
        local palette = require('catppuccin.palettes').get_palette('mocha')

        if (palette == nil) then
            return nil
        end

        require("line-number-change-mode").setup({
            mode = {
                i = {
                    bg = palette.green,
                    fg = palette.mantle,
                    bold = true,
                },
                n = {
                    bg = palette.blue,
                    fg = palette.mantle,
                    bold = true,
                },
                R = {
                    bg = palette.maroon,
                    fg = palette.mantle,
                    bold = true,
                },
                v = {
                    bg = palette.mauve,
                    fg = palette.mantle,
                    bold = true,
                },
                V = {
                    bg = palette.mauve,
                    fg = palette.mantle,
                    bold = true,
                },
            },
            hide_inactive_cursorline = false,
        })
    end
}
```

## Hiding inactive cursorlines

It's off by defaut, but if you set `hide_inactive_cursorline = true`, then this plugin will hide the cursorline for inactive windows so the mode highlight will only be shown in the currently active window:

![Screenshot 2024-10-24 at 12 16 58](https://github.com/user-attachments/assets/2286df66-af72-43e7-b4fc-305f696ad206)

Note: if you're lazy loading this plugin and want to hide inactive window cursorlines, make sure `event` is either set to `VeryLazy` or as follows:

```lua
return {
  'sethen/line-number-change-mode.nvim',
  event = { 'ModeChanged', 'WinEnter', 'WinLeave' },
...
}
```

# Similar Plugins ❤️
* [Moody](https://github.com/svampkorg/moody.nvim)
* [Modicator](https://github.com/mawkler/modicator.nvim)
