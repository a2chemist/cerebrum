-- Load all libraries, files, and processes.
local discordia = require("discordia")
local bot = discordia.Client { logLevel = 0 }
local struct = require("slashCommands").SlashCommand
local registry = require(".registry")
local env = require(".env")
local commands = {}

-- Create slash commands using the registry.
for _, v in ipairs(registry) do
    local pass, body = pcall(struct, bot, v.name, v.description)

    if not pass then
        print(body)
        os.exit()
    else
        for _, v in ipairs(v.arguments) do
            body:argument(v.name, v.description, v.type, {
                required = v.required,
                choices = v.choices,
                type = v.type
            })
        end

        body:execute(v.response)

        commands[#commands + 1] = body
    end
end

-- Notify when bot is ready.
bot:once("ready", function ()
    for _, v in ipairs(commands) do
        v:commit()
    end

    print("Worm is alive!")
end)

-- Login with the bot's token.
bot:run(env.token)