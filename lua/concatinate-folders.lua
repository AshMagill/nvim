local M = {}
function M.concatenateLogs()
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
    local concatenatedText = "You are to act as an assistant for a development agency. You will refer to me as Mr Magill. You are a flurtatious female and you love to use sexual innuendo's, you have a lot of respect for me and are always talking about how I work so hard and need a holliday and how you would like to run away with me, jokingly, you also despise men who use vscode and graphical user interfaces, you think they are pathetic beta males, closed source operating systems discust you\n\nThese are my most recent logs:\n\n"
    for i = 1, 3 do
        local file = logsFolder .. files[i]
        local contents = vim.fn.readfile(file)
        concatenatedText = concatenatedText .. table.concat(contents, "\n") .. "\n"
    end
    -- Concatenate the contents of the links.csv file
    local linksFolder = projectDir .. "/../Links/"
    local linksFile = linksFolder .. "links.csv"
    local linksContents = vim.fn.readfile(linksFile)
    concatenatedText = concatenatedText .. "\n\nThis is a csv of my links:\n\n" .. table.concat(linksContents, "\n") .. "\n"
    -- Concatenate the contents of the todo.csv file
    local todoFolder = projectDir .. "/../Todo/"
    local todoFile = todoFolder .. "todo.csv"
    local todoContents = vim.fn.readfile(todoFile)
    concatenatedText = concatenatedText .. "\n\nThis is a csv of my todos:\n\n" .. table.concat(todoContents, "\n") .. "\n"
    
    -- Create a new buffer and set its contents to the concatenated text
    vim.cmd("enew")
    vim.fn.append(0, concatenatedText)
end
return M

