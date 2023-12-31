using Test

function solve(path::String)::Tuple{Int, Int}
    part1, part2 = 0, 0

    for (id, line) in enumerate(eachline(path))
        highest = Dict("red" => 0, "green" => 0, "blue" => 0)

        for m in eachmatch(r"(\d+) (\w+)", line)
            n, color = m.captures
            highest[color] = max(parse(Int, n), highest[color])
        end

        if highest["red"] <= 12 && highest["green"] <= 13 && highest["blue"] <= 14
            part1 += id
        end

        part2 += prod(values(highest))
    end

    return part1, part2
end

@test solve("data/02.txt") == (2720, 71535)
@time solve("data/02.txt") == (2720, 71535)
@time solve("data/02.txt") == (2720, 71535)
