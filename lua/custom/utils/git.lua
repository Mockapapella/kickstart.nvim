local M = {}

-- Generate commit message using Hyperbolic API
function M.generate_commit_message()
  local api_key = os.getenv('HYPERBOLIC_API_KEY')
  if not api_key then
    vim.api.nvim_echo({ {
      'HYPERBOLIC_API_KEY environment variable is not set',
      'ErrorMsg',
    } }, true, {})
    return
  end

  local current_line = vim.api.nvim_get_current_line()
  local diff_win = vim.fn.winnr('j')
  vim.cmd(diff_win .. 'wincmd w')
  local diff_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')

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

  local request_body = vim.fn.json_encode({
    messages = {
      {
        role = 'system',
        content = '<|im_start|>system\nYou are a Principal Machine Learning Engineer tasked with generating commit messages. Write with clarity and persuasion. Keep sentences simple. Avoid marketing speak purple prose, hyperbole, and flowery language. Use ordinary words where possible, and technical terms only when needed for precision. Remember: simple writing is persuasive writing.<|im_end|>',
      },
      {
        role = 'user',
        content = '<|im_start|>user\n' .. prompt_template .. '<|im_end|>',
      },
    },
    model = 'Qwen/Qwen2.5-Coder-32B-Instruct',
    max_tokens = 8192,
    temperature = 0.7,
    top_p = 0.8,
    top_k = 20,
    repetition_penalty = 1.05,
  })

  local curl_command = string.format(
    "curl -s -X POST 'https://api.hyperbolic.xyz/v1/chat/completions' "
      .. "-H 'Authorization: Bearer %s' "
      .. "-H 'Content-Type: application/json' "
      .. "-d '%s'",
    api_key,
    request_body:gsub("'", "'\\''")
  )

  -- Write request to debug file
  local debug_file = io.open('/tmp/nvim_commit_debug.json', 'w')
  if debug_file then
    debug_file:write('REQUEST:\n')
    debug_file:write(request_body)
    debug_file:write('\n\nRESPONSE:\n')
  end

  local handle = io.popen(curl_command)
  local response = handle:read('*a')
  handle:close()

  -- Append response to debug file
  if debug_file then
    debug_file:write(response)
    debug_file:close()
  end

  if response == '' then
    vim.api.nvim_echo({ { 'API call failed', 'ErrorMsg' } }, true, {})
    return
  end

  local ok, parsed_response = pcall(vim.fn.json_decode, response)
  if not ok then
    vim.api.nvim_echo({ { 'Failed to parse API response', 'ErrorMsg' } }, true, {})
    vim.api.nvim_echo({ { 'Raw response: ' .. response, 'Normal' } }, true, {})
    return
  end

  if not parsed_response.choices or not parsed_response.choices[1].message then
    vim.api.nvim_echo({ { 'Missing message in API response', 'ErrorMsg' } }, true, {})
    return
  end

  local commit_message = parsed_response.choices[1].message.content:gsub('<|im_start|>assistant\n', ''):gsub('<|im_end|>', '')
  local commit_win = vim.fn.winnr('k')
  vim.cmd(commit_win .. 'wincmd w')

  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor_pos[1] - 1, cursor_pos[2]
  vim.api.nvim_buf_set_text(0, row, col, row, col, vim.split(commit_message, '\n'))
end

-- Open GitHub
function M.open_github(start_line, end_line)
  local file_path = vim.fn.expand('%:p')
  local git_root = vim.fn.system('git -C ' .. vim.fn.expand('%:p:h') .. ' rev-parse --show-toplevel'):gsub('[\n\r]+', '')
  local relative_file_path = file_path:sub(#git_root + 2)
  local branch = vim.fn.system('git branch --show-current'):gsub('[\n\r]+', '')
  local remote_url = vim.fn.system('git remote get-url origin'):gsub('[\n\r]+', '')
  local github_url = remote_url:gsub('git@github.com:', 'https://github.com/'):gsub('.git$', '')
  local url = github_url .. '/blob/' .. branch .. '/' .. relative_file_path

  if start_line and end_line then
    url = url .. '#L' .. start_line .. '-L' .. end_line
  else
    local line_number = vim.fn.line('.')
    url = url .. '#L' .. line_number
  end

  local open_command
  if vim.fn.has('mac') == 1 then
    open_command = 'open "' .. url .. '"'
  elseif vim.fn.has('unix') == 1 then
    open_command = 'xdg-open "' .. url .. '"'
  elseif vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1 then
    open_command = 'start "" "' .. url .. '"'
  end

  if open_command then
    vim.fn.system(open_command)
  else
    print('Unsupported system for opening URLs')
  end
end

function M.open_github_visual()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line, end_line = start_pos[2], end_pos[2]
  M.open_github(start_line, end_line)
end

function M.setup()
  -- Register keymaps
  vim.keymap.set('n', 'gh', M.open_github, { noremap = true, silent = true })
  vim.keymap.set('v', 'gh', ':<C-U>lua require("custom.utils.git").open_github_visual()<CR>', { noremap = true, silent = true })
  vim.keymap.set('n', '<leader>gai', M.generate_commit_message, { noremap = true, silent = false })
end

return M
