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
    local concatenatedText = ""
    for i = 1, 3 do
        local file = logsFolder .. files[i]
        local contents = vim.fn.readfile(file)
        concatenatedText = concatenatedText .. table.concat(contents, "\n") .. "\n"
    end
    -- Create a new buffer and set its contents to the concatenated text
    vim.cmd("enew")
    vim.fn.append(0, concatenatedText)
end
return M

