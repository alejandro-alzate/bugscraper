-- Dependencies:
-- - Run at the top level, so it can access the tree of files.
-- - I wanted to use some luarocks tools but on windows that's
-- annoying to setup, so vanilla lua so my windows bros don't
-- suffer with it.
--
-- Notes:
-- - This code will break if there's dots on the name.
-- I have not tested it for this case, hence no proofs,
-- but I don't have doubts it will break.
-- - It will use a random file on /tmp or C:\TMP so it only
-- writes to the final file only if my spaghetti survives long
-- enough hence the creation of a temporary file.

-- Config / Constants
local output_filename = "lang.csv"
local output_path = "./_tools/language_validation/"
local blacklist_keys = {
	"__test_DONOTTRANSLATE" -- Annoyingly long line.
}

-- Helpers
local flatten = require("_tools.language_validation.flatten")
local sort = require("_tools.language_validation.sort")
local get_key = require("_tools.language_validation.get_key")
local header = require("_tools.language_validation.header")

-- Target files
local lang_path = "data.lang"
local main_lang = "en"
local lang_list = { "es", "fr", "pl", "pt_BR", "zh_Hans" }

-- Require lists
local req_main_lang = require(string.format("%s.%s", lang_path, main_lang))
local req_lang_list = {}

for _, lang_code in ipairs(lang_list) do
	req_lang_list[lang_code] = require(string.format("%s.%s", lang_path, lang_code))
end

-- Scratchpad
local buffer = io.tmpfile()
if buffer then
	---===================================---
	---HEADER                             ---
	---===================================---
	-- Expected: [["Path", "Reference", "Lang 1", "Lang 2", "Lang n"]]
	buffer:write(header(req_lang_list))

	-- Order and make a flat copy of the reference language
	-- (Brute force approach honestly)
	local flat_main_lang = flatten(req_main_lang)
	local ordered_flat_main_lang = sort(flat_main_lang)


	---===================================---
	---ENTRY                              ---
	---===================================---
	for _, reference in pairs(ordered_flat_main_lang) do
		local is_blacklisted_key = false
		for _, blacklist_key in ipairs(blacklist_keys) do
			if reference.key == blacklist_key then
				is_blacklisted_key = true
				break
			end
		end

		--Filtering
		if not is_blacklisted_key then
			local entry = string.format([["%s", "%s", ]], reference.key, reference.value)

			-- I fear it might desync with the header
			-- but tests show it consistent, unordered but consitent.
			-- I might need to refractor this also with brute force ordering.
			for _, lang_table in pairs(req_lang_list) do
				entry = string.format([[%s"%s", ]], entry, get_key(lang_table, reference.key) or "")
			end

			buffer:write(entry .. "\n")
		end
	end

	buffer:flush()
	buffer:seek("set", 0)

	local output_file = io.open(output_path .. output_filename, "w")
	if output_file then
		output_file:write(buffer:read("*a"))
		local count = output_file:seek("cur")
		print(string.format("Wrote: %sKB", math.floor(count / 1024)))
		output_file:close()
	end

	buffer:close() -- Pointless but why not
end
