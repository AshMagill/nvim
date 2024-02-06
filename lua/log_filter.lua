local M = {}
function M.getLogs()
    local logsPath = "/home/ash/Documents/Workflow"
    local logsBuffer = vim.api.nvim_create_buf(false, true)
    -- Concatenate logs from a specific folder into the buffer
    local function concatLogs(folderPath)
        local logFiles = vim.fn.readdir(folderPath)
        local sortedFiles = {}
        for _, file in ipairs(logFiles) do
            local filePath = folderPath .. "/" .. file
            if vim.fn.isdirectory(filePath) == 0 then
                table.insert(sortedFiles, {file = file, path = filePath, mtime = vim.fn.getftime(filePath)})
            end
        end
        table.sort(sortedFiles, function(a, b)
            return a.mtime < b.mtime
        end)
        for _, fileInfo in ipairs(sortedFiles) do
            local header = vim.fn.fnamemodify(fileInfo.file, ":t:r")
            --header = header .. " - " .. vim.fn.fnamemodify(vim.fn.fnamemodify(folderPath, ":h"), ":t")
            vim.api.nvim_buf_set_lines(logsBuffer, -1, -1, false, {""})
            vim.api.nvim_buf_set_lines(logsBuffer, -1, -1, false, {header})
            vim.api.nvim_buf_set_lines(logsBuffer, -1, -1, false, {""})
            vim.api.nvim_buf_set_lines(logsBuffer, -1, -1, false, vim.fn.readfile(fileInfo.path))
        end
    end
    local function traverseDirectory(directory)
        local subfolders = vim.fn.readdir(directory)
        local sortedSubfolders = {}
        for _, subfolder in ipairs(subfolders) do
            local subfolderPath = directory .. "/" .. subfolder
            if vim.fn.isdirectory(subfolderPath) == 1 then
                local logsFolderPath = subfolderPath .. "/Logs"
                if vim.fn.isdirectory(logsFolderPath) == 1 then
                    table.insert(sortedSubfolders, {path = logsFolderPath, mtime = vim.fn.getftime(logsFolderPath), folder = subfolder})
                end
            end
        end
        table.sort(sortedSubfolders, function(a, b)
            return a.mtime > b.mtime
        end)
        return sortedSubfolders
    end
    -- Prompt for folder selection
    local folders = traverseDirectory(logsPath)
    local selectedFolders = {}
    local allOption = "1. All"
    table.insert(selectedFolders, allOption)
    for i, folderInfo in ipairs(folders) do
        table.insert(selectedFolders, i +1 .. ". " .. folderInfo.folder)
    end
    local selectedFolderIndex = vim.fn.inputlist(selectedFolders)
    if selectedFolderIndex <= 0 or selectedFolderIndex > #selectedFolders then
        return nil
    end
    -- Concatenate logs based on folder selection
    if selectedFolderIndex == 1 then
        -- Concatenate logs for all folders
        for i, folderInfo in ipairs(folders) do
            local folderHeader = "=== " .. i .. ". " .. folderInfo.folder .. " ==="
            vim.api.nvim_buf_set_lines(logsBuffer, -1, -1, false, {""})
            vim.api.nvim_buf_set_lines(logsBuffer, -1, -1, false, {folderHeader})
            vim.api.nvim_buf_set_lines(logsBuffer, -1, -1, false, {""})
            concatLogs(folderInfo.path)
        end
    else
        -- Concatenate logs for the selected folder index
        local selectedFolderPath = logsPath .. "/" .. folders[selectedFolderIndex - 1].folder .. "/Logs"
        if vim.fn.isdirectory(selectedFolderPath) == 1 then
            local folderHeader = "=== " .. selectedFolderIndex .. ". " .. folders[selectedFolderIndex - 1].folder .. " ==="
            vim.api.nvim_buf_set_lines(logsBuffer, -1, -1, false, {""})
            vim.api.nvim_buf_set_lines(logsBuffer, -1, -1, false, {folderHeader})
            vim.api.nvim_buf_set_lines(logsBuffer, -1, -1, false, {""})
            concatLogs(selectedFolderPath)
        else
            print("Folder not found.")
            return nil
        end
    end
    -- Open the logs buffer and jump to the bottom
    vim.api.nvim_command("split")
    vim.api.nvim_command("buffer " .. logsBuffer)
    vim.api.nvim_command("normal! G")
    -- Set buffer options
    vim.api.nvim_buf_set_option(logsBuffer, "modifiable", false)
    vim.api.nvim_buf_set_option(logsBuffer, "buftype", "nofile")
    vim.api.nvim_buf_set_option(logsBuffer, "bufhidden", "wipe")
    return logsBuffer
end
return M
