--this doesnt work yet
local chatgpt = require('chatgpt')

-- Define your custom chat configuration
local custom_chat_config = {
  welcome_message = "Your custom welcome message",
  loading_text = "Loading, please wait ...",
  question_sign = "", -- 🙂
  answer_sign = "ﮧ", -- 🤖
  max_line_length = 120,
  sessions_window = {
    border = {
      style = "rounded",
      text = {
        top = " Sessions ",
      },
    },
    win_options = {
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
  },
}

-- Define your custom openai_params configuration
local custom_openai_params = {
  model = "your_custom_model", -- Change to your desired model name
  frequency_penalty = 0.5, -- Adjust the frequency_penalty value as needed
  presence_penalty = 0.5, -- Adjust the presence_penalty value as needed
  max_tokens = 400, -- Change the maximum token limit as needed
  temperature = 0.7, -- Adjust the temperature value as needed
  top_p = 0.9, -- Adjust the top_p value as needed
  n = 2, -- Change the number of completions (n) as needed
}

-- Set up the ChatGPT plugin with your custom configurations
chatgpt.setup({
  chat = custom_chat_config,
  openai_params = custom_openai_params,
  -- Other chat-related and OpenAI configurations can be added here if needed

})
