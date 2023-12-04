using Test

function solve(path::String)::Tuple{Int, Int}
    part1, part2 = 0, 0

    digits = [["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];
              string.('1':'9')]
    r = Regex("\\d|" * join(digits, '|'))

    for line in eachline(path)
        nums = replace(line, r"\D" => "")
        part1 += parse(Int, first(nums) * last(nums))

        m = collect(eachmatch(r, line, overlap=true))
        f = findfirst(==(first(m).match), digits)
        l = findlast(==(last(m).match), digits)
        part2 += mod1(f, 9) * 10 + mod1(l, 9)
    end

    return part1, part2
end

@test solve("data/01.txt") == (53334, 52834)
@time solve("data/01.txt")
