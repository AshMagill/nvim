local M = {}
function M.getLogs()
    local logsPath = "/home/ash/Documents/Workflow"
    local logsBuffer = vim.api.nvim_create_buf(false, true)
    -- Concatenate all log files into a temporary buffer
    local function concatLogs(folderPath)
        local logFiles = vim.fn.readdir(folderPath)
        table.sort(logFiles, function(a, b)
            return vim.fn.getftime(folderPath .. "/" .. a) < vim.fn.getftime(folderPath .. "/" .. b)
        end)
        for _, file in ipairs(logFiles) do
            local filePath = folderPath .. "/" .. file
            if vim.fn.isdirectory(filePath) == 0 then

                local header = vim.fn.fnamemodify(file, ":t:r")
              header = header .. " - " .. vim.fn.fnamemodify(vim.fn.fnamemodify(folderPath, ":h"), ":t")
                vim.api.nvim_buf_set_lines(logsBuffer, -1, -1, false, {header})
                vim.api.nvim_buf_set_lines(logsBuffer, -1, -1, false, vim.fn.readfile(filePath))
                vim.api.nvim_buf_set_lines(logsBuffer, -1, -1, false, {""}) -- Add empty line between files
            end
        end
    end
    -- Traverse the Workflow directory and concatenate logs
    local function traverseDirectory(directory)
        local subfolders = vim.fn.readdir(directory)
        for _, subfolder in ipairs(subfolders) do
            local subfolderPath = directory .. "/" .. subfolder
            if vim.fn.isdirectory(subfolderPath) == 1 then
                local logsFolderPath = subfolderPath .. "/Logs"
                if vim.fn.isdirectory(logsFolderPath) == 1 then
                    concatLogs(logsFolderPath)
                end
            end
        end
    end
    traverseDirectory(logsPath)
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

