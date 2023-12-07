using Test
using DelimitedFiles
using StatsBase

const order = reverse("AKQJT98765432")
const new_order = reverse("AKQT98765432J")

function rank_card(card::Vector{Int}; jokers=false)::Float16
    counts = StatsBase.counts(card)
    rank = maximum(counts)
    sum(>(1), counts) > 1 && (rank += .5) # two pairs and full house as intermediate ranks
    jokers || return rank

    n_jokers = count(==(1), card)  # ==(1) J is lowest card at index 1
    5 > n_jokers >= 1 && (rank += 1)
    return 5 > n_jokers >= 2 ? ceil(rank) : rank
end

function solve(path::String; jokers=false)::Int
    cards, bids = eachcol(readdlm(path))
    cards = map(cards) do card
        findfirst.(collect(string(card)), jokers ? new_order : order)
    end

    ranks = rank_card.(cards, jokers=jokers)
    sorted = sortslices([ranks cards bids], dims=1)

    foreach(eachrow(sorted)) do row
        println(row)
    end

    return sum(sorted[:, 3] .* (1:length(bids)))
end

@test solve("examples/07.txt") == 6440
@test solve("examples/07.txt", jokers=true) == 5905
@test solve("data/07.txt") == 247823654
@test solve("data/07.txt", jokers=true) == 245461700
