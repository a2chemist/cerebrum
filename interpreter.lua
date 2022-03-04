-- A brainfuck interpreter file.

return function(code, keys)
    local answers = {}

    if keys then
        for v in keys:gmatch("%S+") do
            answers[#answers + 1] = v
        end
    end

    local scan = ""
    local cells = {0}
    local loops = {}
    local brainfuck = {}
    local i = 1
    local ptr = 1
    local chars = {}

    for _, v in ipairs({"+", "-", "<", ">", "[", "]", ".", ","}) do
        chars[v] = true
    end

    for v in code:gsub("%s+", ""):gsub("%c+", ""):gmatch(".") do
        if not chars[v] then
            return {
                ran = false,
                ptr = ptr,
                msg = "Attempted to interpret with an invalid character."
            }
        end

        brainfuck[#brainfuck + 1] = v
    end

    while (i < (#code + 1)) do
        local v = brainfuck[i]
        
        if v == ">" then
            ptr = ptr + 1
            cells[ptr] = (cells[ptr] or 0)
        elseif v == "<" then
            if ptr == 0 then
                return {
                    ran = false,
                    ptr = ptr,
                    msg = "Attempted to access an inexistent cell."
                }
            end
        
            ptr = ptr - 1
            cells[ptr] = (cells[ptr] or 0)
        elseif v == "," then
            if answers[ptr] then
                scan = scan .. answers[ptr]
            end
        elseif v == "+" then
            cells[ptr] = cells[ptr] + 1
        elseif v == "-" then
            cells[ptr] = cells[ptr] - 1
        elseif v == "." then
            scan = scan .. string.char(cells[ptr])
        elseif v == "[" then
            loops[#loops + 1] = i
        elseif v == "]" then
            if cells[ptr] == 0 then
                table.remove(loops, 1)
            else
                i = loops[#loops]
            end
        end

        i = i + 1
    end

    return {
        ran = true,
        scan = scan,
        cells = cells
    }
end