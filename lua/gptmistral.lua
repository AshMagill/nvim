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
    -- Create a new buffer and set its contents to the concatenated text
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
      max_tokens = 3000,
      temperature = 0,
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
    -- Convert the body table to a curl string
    local curlString = "curl -X POST -H 'Content-Type: application/json' -H 'Authorization: Bearer " .. api_key .. "' -d '" .. vim.fn.json_encode(body) .. "' " .. url
    -- Send the curl request
    local response_body = {}
local handle = io.popen(curlString)
local result = handle:read("*a")
handle:close()
-- Check if the API call was successful
if result then
    print(result)
else
    print("API call failed")
end
end
return M
