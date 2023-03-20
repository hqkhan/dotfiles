local workdirs = {
  vim.loop.cwd(),
  -- runtime path
  vim.opt.runtimepath._info.default:match("/[^,]+runtime"),
  "~/.config/nvim",
  "~/workspace",
  "/local/home/hqkhan/workspace/json-mainline/src/ElastiCacheRedisJSONModule",
  "/local/home/hqkhan/workspace/search-mainline/src/ElastiCacheSearch",
  "~/Sources/nvim/express_line.nvim",
  vim.fn.stdpath("data") .. "/site/pack/packer",
  vim.fn.stdpath("data") .. "/lazy",
}

return workdirs
