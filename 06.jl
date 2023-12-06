using Test

solve_brute(t::Int, d::Int)::Int = sum((1:t) .* (t .- (1:t)) .> d)

function solve(t::Int, d::Int)::Int
    lower = (t + sqrt(t^2 - 4 * d)) / 2
    upper = (t - sqrt(t^2 - 4 * d)) / 2
    return ceil(lower - 1) - floor(upper + 1) + 1
end

function solve(path::String)::Tuple{Int, Int}
    t, d = eachline(path) .|>
    line -> eachmatch(r"\d+", line) .|>
    num -> parse(Int, num.match)

    part1 = prod(solve.(t, d))
    part2 = solve(parse(Int, join(t)), parse(Int, join(d)))
    return part1, part2
end

@test solve("examples/06.txt") == (288, 71503)
@test solve("data/06.txt") == (1195150, 42550411)
@time solve("data/06.txt")
