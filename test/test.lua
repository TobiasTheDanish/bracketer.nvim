local test = "TEST"

local bar = test:len()

local table = {
	foo = 123,
}

bar = bar + table["foo"]

print(bar)

local baz = {
	field1 = "foo",
	field2 = "bar",
	field3 = "baz",
}

print(vim.inspect(baz))


local testing = {

}

local tes2 = {
	field = function(param)
		print("Hello world")
	end
}

local test3 = {
	this = "works",
}

local test4 = {}

local test5 = {
}

local test6 = {
}

local test7 = {
}

baz["field1"] = 123

print("HELL YEAH!")

print("STILL WORKS")

