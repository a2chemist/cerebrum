-- A registry file.

return {{
    name = "devs",
    description = "Lists all developers!",
    arguments = {},
    response = function(ctx)
        local env = require(".env")
        local devs = {}
        
        for i, v in ipairs(env.devs) do
            local user = ctx._client:getUser(v)

            if user then
                devs[i] = ("`%s`"):format(user.tag)
            end
        end

        if #devs == 0 then
            ctx:reply("None of the devs were fetchable.")
        else
            ctx:reply(table.concat(devs, ", "))
        end
    end
}, {
    name = "interpret",
    description = "Interprets BrainFuck!",
    arguments = {{
        name = "brainfuck",
        description = "The BrainFuck code to interpret.",
        required = true,
        type = 3
    }, {
        name = "keys",
        description = "The keys to match any input prompts (separate with spaces).",
        required = false,
        type = 3
    }},
    response = function(ctx)
        local interpret = require(".interpreter")
        local data = interpret(ctx._arguments.brainfuck, ctx._arguments.keys)

        if not data.ran then
            ctx:reply(("%s `(CELL #%d)`"):format(data.msg, data.ptr))
        else
            local scan = data.scan
            local cells = {}
            
            for i, v in ipairs(data.cells) do
                cells[i] = ("{%d}"):format(v)
            end
            
            if #cells < 2000 and #scan < 2000 then
                ctx:reply(("```ini\n[Interpreted String]\n%s\n\n[Memory Cells (%d)]\n%s\n```"):format(scan, #cells, table.concat(cells)))
            else
                ctx:reply {
                    files = {
                        "interpreted.txt",
                        ("[Interpreted String]\n%s\n\n[Memory Cells]\n%s"):format(scan, table.concat(cells))
                    }
                }
            end
        end
    end
}}