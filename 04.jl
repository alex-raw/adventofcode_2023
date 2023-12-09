using Test

function solve(path::String)::Tuple{Int, Int}
    score = 0
    counts = ones(Int, countlines(path))

    for (i, line) in enumerate(eachline(path))
        win, me = split.(split(chopprefix(line, r".*: "), " | "))
        win, me = parse.(Int, win), parse.(Int, me)
        n = length(win ∩ me)
        n == 0 && continue
        counts[range(i + 1, length=n)] .+= counts[i]
        score += 2^(n - 1)
    end

    return score, sum(counts)
end

@test solve("examples/04.txt") == (13, 30)
@test solve("data/04.txt") == (25183, 5667240)
