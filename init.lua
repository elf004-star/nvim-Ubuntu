-- ==========================================
-- 1. 剪贴板：本地用系统剪贴板（xclip），SSH 时用 OSC 52 同步到本地
-- ==========================================
-- 本地 GNOME Terminal (VTE) 不支持 OSC 52，强制启用会导致 y 复制不到系统剪贴板
-- 只有 SSH 会话才需要 OSC 52 把文本经终端同步回本地
if vim.env.SSH_CONNECTION or vim.env.SSH_TTY then
    vim.g.clipboard = "osc52"
end

-- ==========================================
-- 2. 加载插件管理器与基础设置
-- ==========================================
require("config.lazy")

-- 延迟设置 clipboard，防止被 LazyVim 的 VeryLazy 回调覆盖（SSH 环境下 LazyVim 会清空 clipboard）
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        vim.o.clipboard = "unnamedplus"
    end,
})
