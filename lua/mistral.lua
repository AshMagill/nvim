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
    local concatenatedText = 'You are a secretary called Merina, you call me Mr Magill, go through the following information to give me an itinary for the work day, do not inlcude times, do not share raw data from csv files,you may share relevant links with me but only urls. Only use 50 or less words'
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
    --print(concatenatedText)

    function replaceGapsAndSpacesWithComma(str)
    local result = string.gsub(str, "%s+", ",")
    return result
end
local outputString = replaceGapsAndSpacesWithComma(concatenatedText)

    local model = "dolphin-mixtral"
    local command = string.format('curl --silent --no-buffer -X POST http://localhost:11434/api/generate -d \'{"model":"%s","prompt":"%s","stream":false}\'', model,outputString)
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

