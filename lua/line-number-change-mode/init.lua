local M = {}

function M.setup(opts)
   opts = opts or {}
   local va = vim.api
   local group = va.nvim_create_augroup("LineNumberChangeMode", {
      clear = true,
   })

   local function set_hl_for_mode(mode)
      if opts.mode[mode] then
         va.nvim_set_hl(0, "CursorLineNr", opts.mode[mode])

         -- The statuscolumn may not repaint when switching to command mode so
         -- we force a redraw here to make sure the color updates
         if (mode == "c") then
            vim.cmd.redraw()
         end
      end

      -- Keep track of mode because we don't get a ModeChanged event when
      -- opening a file from Telescope. See:
      -- https://github.com/sethen/line-number-change-mode.nvim/issues/7
      M.mode = mode
   end

   set_hl_for_mode(va.nvim_get_mode().mode)

   va.nvim_create_autocmd("ModeChanged", {
      group = group,
      callback = function()
         local new_mode = vim.v.event.new_mode

         if opts.debug then
            vim.notify(new_mode, vim.log.levels.DEBUG)
         end

         set_hl_for_mode(new_mode)
      end,
   })

   if opts.hide_inactive_cursorline then
      vim.api.nvim_create_autocmd({ "WinEnter" }, {
         group = group,
         callback = function(_)
            local win = vim.api.nvim_get_current_win()
            -- vim.notify(e.event..', win: '..win..' cl: '..vim.inspect(vim.wo.cursorline)..' had: '..vim.inspect(vim.w[win].hadcursorline))

            -- if the cursorline was supposed to be on, turn it back on
            if vim.w[win].hadcursorline and not vim.wo.cursorline then
               vim.wo.cursorline = true
            end
         end,
      })
   end

   vim.api.nvim_create_autocmd({ "WinLeave" }, {
      group = group,
      callback = function(_)
         if opts.hide_inactive_cursorline then
            -- vim.notify(e.event..', win: '..win..' cl: '..vim.inspect(vim.wo.cursorline)..' had: '..vim.inspect(vim.w[win].hadcursorline))

            -- If the cursorline is on, turn it off but remember that we turned it off
            if vim.wo.cursorline then
               local win = vim.api.nvim_get_current_win()
               vim.wo.cursorline = false
               vim.w[win].hadcursorline = true

               -- vim.notify('turning off cursorline for: '..win..' hadcursorline: '..vim.inspect(vim.w[win].hadcursorline))
            end
         end

         -- If we're leaving a window and we're still in insert mode, schedule 
         -- a callback for the next run of the event loop to make sure the 
         -- correct mode highlight is displayed. See:
         -- https://github.com/sethen/line-number-change-mode.nvim/issues/7
         if M.mode == 'i' then
            vim.schedule(function()
               if opts.debug then
                  vim.notify('in insert mode, will schedule mode set')
               end
               set_hl_for_mode(vim.api.nvim_get_mode().mode)
            end)
         end
      end,
   })

end

return M
