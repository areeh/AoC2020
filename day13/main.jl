using Underscores
using BenchmarkTools

function read_input(path)
    lines = readlines(path)
    target = parse(Int, lines[1])
    schedule = @_ lines[2] |> split(__, ',') |> map(tryparse(Int, _), __)
    return (target=target, schedule=schedule)
end

function chineseremainder(n, a)
    """
    Apply the Chinese Remainder Theorem
    ref: https://rosettacode.org/wiki/Chinese_remainder_theorem

    x ≡ a₁ (mod n₁)
    x ≡ a₁ (mod n₁)
    ...
    x ≡ aₖ (mod nₖ)
    """
    Π = prod(n)
    mod(sum(aᵢ * invmod(Π ÷ nᵢ, nᵢ) * (Π ÷ nᵢ) for (nᵢ, aᵢ) in zip(n, a)), Π)
end

function main1(path)
    d = read_input(path)
    schedule = @_ filter(!isnothing(_), d.schedule)
    best_times = @_ d |> map(fld1(__.target, _) * _, schedule)
    best = minimum(best_times)
    bus_id = schedule[findfirst(isequal(best), best_times)]
    return (best - d.target) * bus_id
end

function main2(path)
    d = read_input(path)
    a = [-i+1 for (i, a)=enumerate(d.schedule) if !isnothing(a)]
    n = @_ filter(!isnothing(_), d.schedule)
    t = chineseremainder(n, a)
end

@btime main1("day13/input_sample.txt")
@btime main1("day13/input.txt")
@btime main2("day13/input_sample.txt")
@btime main2("day13/input_sample2.txt")
@btime main2("day13/input.txt")