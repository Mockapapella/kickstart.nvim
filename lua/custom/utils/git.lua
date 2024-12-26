local M = {}

function M.generate_commit_message()
  -- Check API key
  local api_key = os.getenv 'HYPERBOLIC_API_KEY'
  if not api_key then
    vim.api.nvim_echo({ { 'HYPERBOLIC_API_KEY environment variable is not set', 'ErrorMsg' } }, true, {})
    return
  end

  -- Verify git commit window
  if vim.bo.filetype ~= 'gitcommit' then
    vim.api.nvim_echo({ { 'Error: This command must be run from a git commit window', 'ErrorMsg' } }, true, {})
    return
  end

  -- Get current line and diff content
  local current_line = vim.api.nvim_get_current_line()
  local diff_win = vim.fn.winnr 'j'

  -- Switch to diff window
  local ok = pcall(vim.cmd, diff_win .. 'wincmd w')
  if not ok then
    vim.api.nvim_echo({ { 'Error: Could not find git diff window', 'ErrorMsg' } }, true, {})
    return
  end

  -- Get diff content
  local diff_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
  if diff_content == '' then
    vim.api.nvim_echo({ { 'Error: No diff content found', 'ErrorMsg' } }, true, {})
    return
  end

  local prompt_template = [[
Write a commit message for this git diff.

]] .. current_line .. [[

<Example 1>
Update database connection handling

- Switch to connection pooling
- Add timeout settings
- Log failed connections

</Example 1>

<Example 2>
Fix image upload validation

- Enforce maximum file size of 5MB for uploaded images
- Restrict allowed file types to .jpg, .png, .gif
- Return user-friendly error messages for validation failures
- Implement asynchronous upload processing to improve user experience
- Auto-rotate images based on EXIF data
- Optimize image compression on server to reduce file sizes
- Add client-side preview of uploaded images
- Integrate with 3rd party service for advanced image optimization
- Scan uploaded files for viruses/malware and log failures
- Update API docs to reflect new image upload requirements

</Example 2>

<Example 3>
Fix typo in footer
</Example 3>

Keep messages succinct. If there's a single small change, use a one-line message (like in Example 3). For multiple changes, list the key updates (like in Examples 1 and 2).

Do not start your message with things like "Here is a good commit message for this diff:" -- just get straight to writing the commit message.

Here's the Git diff:

]] .. diff_content

  local request_body = vim.fn.json_encode {
    messages = {
      {
        role = 'system',
        content = 'You are a Principal Software Engineer tasked with generating commit messages. Write with clarity and precision. Keep messages succinct and focused on the changes. Use technical terms only when needed. Avoid marketing speak and flowery language.',
      },
      {
        role = 'user',
        content = prompt_template,
      },
    },
    model = 'meta-llama/Meta-Llama-3-70B-Instruct',
    temperature = 0.1,
    top_p = 0.9,
    stream = false,
  }

  -- Make API request
  local curl_command = string.format(
    "curl -s -X POST 'https://api.hyperbolic.xyz/v1/chat/completions' "
      .. "-H 'Content-Type: application/json' "
      .. "-H 'Authorization: Bearer %s' "
      .. "-d '%s'",
    api_key,
    request_body:gsub("'", "'\\''")
  )

  local handle = io.popen(curl_command)
  local response = handle:read '*a'
  handle:close()

  if response == '' then
    vim.api.nvim_echo({ { 'API call failed', 'ErrorMsg' } }, true, {})
    return
  end

  local ok, parsed_response = pcall(vim.fn.json_decode, response)
  if not ok or not parsed_response.choices or not parsed_response.choices[1].message then
    vim.api.nvim_echo({ { 'Failed to parse API response', 'ErrorMsg' } }, true, {})
    return
  end

  -- Insert commit message
  local commit_message = parsed_response.choices[1].message.content:gsub('<|im_start|>assistant\n', ''):gsub('<|im_end|>', '')
  local commit_win = vim.fn.winnr 'k'
  vim.cmd(commit_win .. 'wincmd w')

  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor_pos[1] - 1, cursor_pos[2]
  vim.api.nvim_buf_set_text(0, row, col, row, col, vim.split(commit_message, '\n'))
end

-- Open GitHub
function M.open_github(start_line, end_line)
  local file_path = vim.fn.expand '%:p'
  local git_root = vim.fn.system('git -C ' .. vim.fn.expand '%:p:h' .. ' rev-parse --show-toplevel'):gsub('[\n\r]+', '')
  local relative_file_path = file_path:sub(#git_root + 2)
  local branch = vim.fn.system('git branch --show-current'):gsub('[\n\r]+', '')
  local remote_url = vim.fn.system('git remote get-url origin'):gsub('[\n\r]+', '')
  local github_url = remote_url:gsub('git@github.com:', 'https://github.com/'):gsub('.git$', '')
  local url = github_url .. '/blob/' .. branch .. '/' .. relative_file_path

  if start_line and end_line then
    url = url .. '#L' .. start_line .. '-L' .. end_line
  else
    local line_number = vim.fn.line '.'
    url = url .. '#L' .. line_number
  end

  local open_command
  if vim.fn.has 'mac' == 1 then
    open_command = 'open "' .. url .. '"'
  elseif vim.fn.has 'unix' == 1 then
    open_command = 'xdg-open "' .. url .. '"'
  elseif vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
    open_command = 'start "" "' .. url .. '"'
  end

  if open_command then
    vim.fn.system(open_command)
  else
    print 'Unsupported system for opening URLs'
  end
end

function M.open_github_visual()
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local start_line, end_line = start_pos[2], end_pos[2]
  M.open_github(start_line, end_line)
end

function M.setup()
  -- Register keymaps
  vim.keymap.set('n', 'gh', M.open_github, { noremap = true, silent = true })
  vim.keymap.set('v', 'gh', ':<C-U>lua require("custom.utils.git").open_github_visual()<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<leader>gai', function() M.generate_commit_message() end, { noremap = true, silent = false, desc = 'Generate commit message using AI' })
end

return M
