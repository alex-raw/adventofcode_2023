using Test

function f(vec::Vector{Int})::Int
    c = 0
    while !iszero(vec)
        c += last(vec)
        vec = diff(vec)
    end
    return c
end

# # recursive version
# f(x) = iszero(x) ? 0 : x[end] + f(diff(x))

function solve(path::String)::Tuple{Int, Int}
    nums = map(line -> parse.(Int, split(line)), eachline(path))
    return sum(f, nums), sum(f, reverse!.(nums))
end

@test solve("examples/09.txt") == (114, 2)
@test solve("data/09.txt") == (1641934234, 975)
@time solve("data/09.txt"); @time solve("data/09.txt")

# golfed
# f(x)=iszero(x) ? 0 : x[end]+f(diff(x));map(l->parse.(Int,split(l)),eachline())|>v->(sum(f,v),sum(f,reverse.(v)))

