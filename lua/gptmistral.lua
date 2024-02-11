local M = {}
    -- Store the current window and cursor position
function M.execute()
    -- Get the project directory
    local projectDir = vim.fn.finddir('Logs', '.;')
    -- Construct the Logs folder path in the project directory
    local logsFolder = projectDir .. "/"
    -- Get the list of files in the Logs folder
    local files = vim.fn.readdir(logsFolder)
    -- Sort the files by modification time (newest first)
    table.sort(files, function(a, b)
        return vim.fn.getftime(logsFolder .. a) > vim.fn.getftime(logsFolder .. b)
    end)
    -- Concatenate the contents of the three most recent files
    local concatenatedText = "relay my input."
    for i = 1, 3 do
        local file = logsFolder .. files[i]
        local contents = vim.fn.readfile(file)
        -- Remove non-alphanumeric characters from the contents
        local cleanedContents = {}
        for _, line in ipairs(contents) do
            local cleanedLine = line:gsub("[^%w]", " ")
            table.insert(cleanedContents, cleanedLine)
        end
        concatenatedText = concatenatedText .. table.concat(cleanedContents, "\n") .. "\n"
    end
    -- Concatenate the contents of the links.csv file
    local linksFolder = projectDir .. "/../Links/"
    local linksFile = linksFolder .. "links.csv"
    local linksContents = vim.fn.readfile(linksFile)
    -- Remove non-alphanumeric characters from the contents
    local cleanedLinksContents = {}
    for _, line in ipairs(linksContents) do
        local cleanedLine = line:gsub("[^%w]", " ")
        table.insert(cleanedLinksContents, cleanedLine)
    end
    concatenatedText = concatenatedText .. "\n\nThis is a csv of my links:\n\n" .. table.concat(cleanedLinksContents, "\n") .. "\n"
    -- Concatenate the contents of the todo.csv file
    local todoFolder = projectDir .. "/../Todo/"
    local todoFile = todoFolder .. "todo.csv"
    local todoContents = vim.fn.readfile(todoFile)
    -- Remove non-alphanumeric characters from the contents
    local cleanedTodoContents = {}
    for _, line in ipairs(todoContents) do
        local cleanedLine = line:gsub("[^%w]", " ")
        table.insert(cleanedTodoContents, cleanedLine)
    end
    concatenatedText = concatenatedText .. "\n\nThis is a csv of my todos:\n\n" .. table.concat(cleanedTodoContents, "\n") .. "\n"
    function replaceGapsAndSpacesWithComma(str)
        local result = string.gsub(str, "%s+", " ")
        return result
    end
    local outputString = replaceGapsAndSpacesWithComma(concatenatedText)
    -- Make the API call to OpenAI
    local api_key = os.getenv("OPENAI_API_KEY")
    local model = 'gpt-4-1106-preview'	 -- Change to your desired model name
    local url = "https://api.openai.com/v1/chat/completions"
    local headers = {
        "Content-Type: application/json",
        "Authorization: Bearer " .. api_key
    }
    local body = {
      model =  model,
      frequency_penalty = 0,
      presence_penalty = 0,
      max_tokens = 2000,
      temperature = 1,
      top_p = 1,
      n = 1,
        user = "user",
        messages = {
            {
                role = "system",
                content = "assistant"
            },
            {
                role = "user",
                content = outputString
            }
        }
    }
    

local curlString = "curl -s -X POST -H 'Content-Type: application/json' -H 'Authorization: Bearer " .. api_key .. "' -d '" .. vim.fn.json_encode(body) .. "' " .. url

-- Add a prompt or condition to wait for user input

local handle = vim.fn.system(curlString)
local result = tostring(handle) -- Convert handle to a string
-- Check if the API call was successful
if result then
  local foo = string.match(result, '"content": "(.-)"')
  local bar = foo:gsub("\\([nt])", {n="\n", t="\t"})
  -- Create a new buffer and split it
  vim.cmd("vnew")
  local bufnr = vim.api.nvim_create_buf(false, true) -- Create a temporary buffer
  local lines = {}
  for line in bar:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_set_current_buf(bufnr) -- Set the current buffer to the new temporary buffer
  vim.cmd("setlocal buftype=nofile") -- Set the buffer type to "nofile" to indicate it's a temporary buffer
else
  print("API call failed")
end
-- Close the handle
end
return M

