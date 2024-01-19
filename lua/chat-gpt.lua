--this doesnt work yet
local chatgpt = require('chatgpt')

-- Define your custom chat configuration
local custom_chat_config = {
  welcome_message = "",
  loading_text = "Loading, please wait ...",
  question_sign = "", -- 🙂
  answer_sign = "ﮧ", -- 🤖
}

-- Define your custom openai_params configuration
local custom_openai_params = {
  model = 'gpt-4-1106-preview'	, -- Change to your desired model name
  --model = 'gpt-3.5-turbo'	, -- Change to your desired model name
}

-- Set up the ChatGPT plugin with your custom configurations
chatgpt.setup({
  chat = custom_chat_config,
  openai_params = custom_openai_params,
  -- Other chat-related and OpenAI configurations can be added here if needed
})
