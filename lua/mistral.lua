local M = {}
function M.execute()
    local prompt = "tell me im special in 3 words"
    local model = "dolphin-mixtral"
    local command = string.format('curl --silent --no-buffer -X POST http://localhost:11434/api/generate -d \'{"model":"%s","prompt":"%s","stream":false}\'', model, prompt)
    local response = vim.fn.system(command)
    -- Extract the response from the string
    local start_index = string.find(response, '"response":"') + 12
    local end_index = string.find(response, '","done":true', start_index) - 1
    local parsed_response = string.sub(response, start_index, end_index)
    -- Open response in a new buffer
    vim.cmd('vnew')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {parsed_response})
    vim.cmd('setlocal buftype=nofile')
    vim.cmd('setlocal bufhidden=hide')
    vim.cmd('setlocal noswapfile')
    vim.cmd('setlocal nowrap')
end
return M
