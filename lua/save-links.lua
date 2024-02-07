local M = {}
function M.save_link()
    -- Get the top line of the document
    local top_line = vim.fn.getline(1)
    -- Prompt the user to choose between workspace and workflow
    local choice = vim.fn.input('Save in workspace or workflow? (w/f): ')
    -- Set the base directory based on the user's choice
    local base_dir
    if choice == 'w' then
        base_dir = '~/Workspace'
    elseif choice == 'f' then
        base_dir = '~/Documents/Workflow'
    else
        print('Invalid choice')
        return
    end
    -- Map through subdirectories and display them to the user
    local subdirs = vim.fn.globpath(base_dir, '*', 1, 1)
    local subdir_choice_index = vim.fn.inputlist(subdirs)
    local subdir_choice = vim.fn.fnamemodify(subdirs[subdir_choice_index], ':t')
    -- Prompt the user for a name and description
    local name = vim.fn.input('Enter a name: ')
    local description = vim.fn.input('Enter a description: ')
    -- Get the current date and time
    local time_date = os.date('%Y-%m-%d %H:%M:%S')
    -- Append the line to the CSV file
    local csv_file = base_dir .. '/' .. subdir_choice .. '/Links/links.csv'
    local csv_line = top_line .. ',' .. name .. ',' .. description .. ',' .. time_date .. '\n'
    local csv_file_handle = io.open(vim.fn.expand(csv_file), 'a')
    if csv_file_handle then
        csv_file_handle:write(csv_line)
        csv_file_handle:close()
    else
        print('Failed to open CSV file')
        return
    end
    -- Update the bookmarks file for qutebrowser
    local bookmarks_file = os.getenv('HOME') .. '/.config/qutebrowser/bookmarks/urls'
    local bookmarks_line = top_line .. ' | ' .. subdir_choice .. ' | ' .. name .. ' | ' .. description .. ' | ' .. time_date .. '\n'
    local bookmarks_file_handle = io.open(bookmarks_file, 'a')
    if bookmarks_file_handle then
        bookmarks_file_handle:write(bookmarks_line)
        bookmarks_file_handle:close()
    else
        print('Failed to open bookmarks file')
        return
    end
    print('Link saved successfully')
end
return M

