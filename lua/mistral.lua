local M = {}
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

    local concatenatedText = 'Your name is Merna. You are a sassy, happy, chatty, cheerful secretary whose objective is to assist in workload management for me: Mr. Magill, owner of Magill Mega Corp, the greatest tech company ever created! After reviewing the provided information, you will compile a comprehensive workload for the day. It is important to note that specific times and raw data from CSV files will not be included. However, if there are any urgent tasks or recent logs, you will provide relevant links. The following output for you to give information on is a concatenated string, including logs, todos, and links. Links will be formatted as: URL, Name, Description, and Time-Date. Todos will be formatted as: Name, Description, Time-Date, and Urgency.'
    for i = 1, 3
do
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
    -- Create a new buffer and set its contents to the concatenated text
    function replaceGapsAndSpacesWithComma(str)
    local result = string.gsub(str, "%s+", " ")
    return result
end
local plainText = replaceGapsAndSpacesWithComma(concatenatedText)
    local model = "dolphin-mixtral:8x7b-v2.5-q8_0"

local function makeAPICall(model, plainText)
    local command = string.format('curl --silent --no-buffer -X POST http://localhost:11434/api/generate -d \'{"model":"%s","prompt":"%s","stream":false}\'', model,plainText)
    local response = vim.fn.system(command)
    -- Extract the response from the string
    local start_index = string.find(response, '"response":"') + 12
    local end_index = string.find(response, '","done":true', start_index) - 1
    local parsed_response = string.sub(response, start_index, end_index)
    -- Open response in a new buffer
    local foo = parsed_response:gsub("\\([nt])", {n="\n", t="\t"})
    foo = foo:gsub("\\([nt])", {n="\n", t="\"\t"})
    -- Create a new buffer and split it
    if foo then
        vim.cmd("new")
        local bufnr = vim.api.nvim_create_buf(false, true) -- Create a temporary buffer
        local lines = vim.split(foo, "\n")
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
        vim.api.nvim_set_current_buf(bufnr) -- Set the current
        vim.cmd("setlocal buftype=nofile")
-- Set the buffer type to "nofile" to indicate it's a temporary buffer
    else
        print("API call failed: No response received")
    end
  end
makeAPICall(model, plainText)
end
return M
