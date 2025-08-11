--https://github.com/lunarmodules/luasocket/blob/master/src/url.lua
--[[
LICENSE

Copyright (C) 2004-2022 Diego Nehab

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
]]

-----------------------------------------------------------------------------
-- URI parsing, composition and relative URL resolution
-- LuaSocket toolkit.
-- Author: Diego Nehab
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Declare module
-----------------------------------------------------------------------------
local _M = {}


-----------------------------------------------------------------------------
-- Module version
-----------------------------------------------------------------------------
_M._VERSION = "URL 1.0.3"

-----------------------------------------------------------------------------
-- Encodes a string into its escaped hexadecimal representation
-- Input
--   s: binary string to be encoded
-- Returns
--   escaped representation of string binary
-----------------------------------------------------------------------------
function _M.escape(s)
	return (string.gsub(s, "([^A-Za-z0-9_])", function(c)
		return string.format("%%%02x", string.byte(c))
	end))
end

-----------------------------------------------------------------------------
-- Protects a path segment, to prevent it from interfering with the
-- url parsing.
-- Input
--   s: binary string to be encoded
-- Returns
--   escaped representation of string binary
-----------------------------------------------------------------------------
local function make_set(t)
	local s = {}
	for i,v in ipairs(t) do
		s[t[i]] = 1
	end
	return s
end

-- these are allowed within a path segment, along with alphanum
-- other characters must be escaped
local segment_set = make_set {
	"-", "_", ".", "!", "~", "*", "'", "(",
	")", ":", "@", "&", "=", "+", "$", ",",
}

local function protect_segment(s)
	return string.gsub(s, "([^A-Za-z0-9_])", function (c)
		if segment_set[c] then return c
		else return string.format("%%%02X", string.byte(c)) end
	end)
end

-----------------------------------------------------------------------------
-- Unencodes a escaped hexadecimal string into its binary representation
-- Input
--   s: escaped hexadecimal string to be unencoded
-- Returns
--   unescaped binary representation of escaped hexadecimal  binary
-----------------------------------------------------------------------------
function _M.unescape(s)
	return (string.gsub(s, "%%(%x%x)", function(hex)
		return string.char(tonumber(hex, 16))
	end))
end

-----------------------------------------------------------------------------
-- Removes '..' and '.' components appropriately from a path.
-- Input
--   path
-- Returns
--   dot-normalized path
local function remove_dot_components(path)
	local marker = string.char(1)
	repeat
		local was = path
		path = path:gsub('//', '/'..marker..'/', 1)
	until path == was
	repeat
		local was = path
		path = path:gsub('/%./', '/', 1)
	until path == was
	repeat
		local was = path
		path = path:gsub('[^/]+/%.%./([^/]+)', '%1', 1)
	until path == was
	path = path:gsub('[^/]+/%.%./*$', '')
	path = path:gsub('/%.%.$', '/')
	path = path:gsub('/%.$', '/')
	path = path:gsub('^/%.%./', '/')
	path = path:gsub(marker, '')
	return path
end
-----------------------------------------------------------------------------

--https://stackoverflow.com/a/28921280
function ParseQuery(Query)
	local Data = {}

	for Index, Value in Query:gmatch('([^&=?]-)=([^&=?]+)' ) do
		Data[Index] = _M.unescape(Value)
	end

	return Data
end

-----------------------------------------------------------------------------
-- Builds a path from a base path and a relative path
-- Input
--   base_path
--   relative_path
-- Returns
--   corresponding absolute path
-----------------------------------------------------------------------------
local function absolute_path(base_path, relative_path)
	if string.sub(relative_path, 1, 1) == "/" then
		return remove_dot_components(relative_path) end
	base_path = base_path:gsub("[^/]*$", "")
	if not base_path:find'/$' then base_path = base_path .. '/' end
	local path = base_path .. relative_path
	path = remove_dot_components(path)
	return path
end

-----------------------------------------------------------------------------
-- Parses a url and returns a table with all its parts according to RFC 2396
-- The following grammar describes the names given to the URL parts
-- <url> ::= <scheme>://<authority>/<path>;<params>?<query>#<fragment>
-- <authority> ::= <userinfo>@<host>:<port>
-- <userinfo> ::= <user>[:<password>]
-- <path> :: = {<segment>/}<segment>
-- Input
--   url: uniform resource locator of request
--   default: table with default values for each field
-- Returns
--   table with the following fields, where RFC naming conventions have
--   been preserved:
--     scheme, authority, userinfo, user, password, host, port,
--     path, params, query, fragment
-- Obs:
--   the leading '/' in {/<path>} is considered part of <path>
-----------------------------------------------------------------------------
function _M.parse(url, default)
	-- initialize default parameters
	local parsed = {}
	for i,v in pairs(default or parsed) do parsed[i] = v end
	-- empty url is parsed to nil
	if not url or url == "" then return nil, "invalid url" end
	-- remove whitespace
	-- url = string.gsub(url, "%s", "")
	-- get scheme
	url = string.gsub(url, "^([%w][%w%+%-%.]*)%:",
		function(s) parsed.scheme = s; return "" end)
	-- get authority
	url = string.gsub(url, "^//([^/%?#]*)", function(n)
		parsed.authority = n
		return ""
	end)
	-- get fragment
	url = string.gsub(url, "#(.*)$", function(f)
		parsed.fragment = f
		return ""
	end)
	-- get query string
	url = string.gsub(url, "%?(.*)", function(q)
		parsed.query = ParseQuery(q)
		return ""
	end)
	-- get params
	url = string.gsub(url, "%;(.*)", function(p)
		parsed.params = p
		return ""
	end)
	-- path is whatever was left
	if url ~= "" then parsed.path = url end
	local authority = parsed.authority
	if not authority then return parsed end
	authority = string.gsub(authority,"^([^@]*)@",
		function(u) parsed.userinfo = u; return "" end)
	authority = string.gsub(authority, ":([^:%]]*)$",
		function(p) parsed.port = p; return "" end)
	if authority ~= "" then
		-- IPv6?
		parsed.host = string.match(authority, "^%[(.+)%]$") or authority
	end
	local userinfo = parsed.userinfo
	if not userinfo then return parsed end
	userinfo = string.gsub(userinfo, ":([^:]*)$",
		function(p) parsed.password = p; return "" end)
	parsed.user = userinfo
	return parsed
end

return _M