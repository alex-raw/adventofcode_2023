using Test

function getnums(line::String)::Int
    nums = filter(isnumeric, line)
    return parse(Int, first(nums) * last(nums))
end

function getnums(line::String, r::Regex, lookup::Vector{String})::Int
    m = collect(eachmatch(r, line))
    f = @something tryparse(Int, first(m).match) findfirst(==(first(m).match), lookup)
    l = @something tryparse(Int, last(m).match) findlast(==(last(m).match), lookup)
    return f * 10 + l
end

function solve(path::String)::Tuple{Int, Int}
    words = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    r = Regex(join([words; "\\d"], '|'))
    return sum(getnums, eachline(path)),
           sum(x -> getnums(x, r, words), eachline(path))
end

@test solve("data/01.txt") == (53334, 52834)
@time solve("data/01.txt")
