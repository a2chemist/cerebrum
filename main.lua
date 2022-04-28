local write = io.write
local read = io.read
local open = io.open

print('================== INTERPRETER ==================')
print('[iii] Welcome to the "cerebrum" interpreter!')
print('[iii] "cerebrum" is for the esoteric brainfuck language.')
write('[iii] If you would, please enter your file path:  ')

local path = read()
local mark = os.time()

print('[iii] Okay, now attempting to read your file...')

local file = open(path, 'r')

if not file then
	error('[!!!] Your file path was incorrect.')
end

print('[iii] Your file exists! Now organizing it...')

local script = {}

for a in file:lines() do
	for b in a:gsub('%s+', ''):gmatch('.') do
		table.insert(script, b)
	end
end

print('[iii] Done! Now understanding the program...')
print('==================== SCRIPT ====================')

local i = 1
local arrow = 1
local cells = {0}
local str = ''
local loops = {}

while i < (#script + 1) do
	local c = script[i]

	if c == '+' then
		cells[arrow] = cells[arrow] + 1
	elseif c == '-' then
		cells[arrow] = cells[arrow] - 1
	elseif c == '>' then
		arrow = arrow + 1

		cells[arrow] = cells[arrow] or 0
	elseif c == '<' then
		if arrow == 0 then
			error('[aaa] Negative cell access detected.')
		end

		arrow = arrow - 1
	elseif c == ',' then
		write('[qqq] Enter a character: ')
		
		cells[arrow] = read():match('%S'):byte()
	elseif c == '.' then
		str = str .. string.char(cells[arrow])
	elseif c == '[' then
		table.insert(loops, i)
	elseif c == ']' then
		if cells[arrow] == 0 then
			table.remove(loops, 1)
		else
			i = loops[#loops] or error('[!!!] Unfinished loop detected.')
		end
	else
		i = i + 0
	end

	i = i + 1
end

print(('[iii] Returned output:  "%s"'):format(str))
print(('[iii] Time it took to handle:  %dms'):format(os.time() - mark))
print('================== CREDIT ==================')
print('[iii] Credits to "no5trum" on GitHub.')
print('[iii] Message me on Discord to report any bugs!')
print('[iii] Thanks for using "cerebrum".')
