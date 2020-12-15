using Underscores
using BenchmarkTools

function get_input(path)
    a = @_ readline(path) |> split(__, ',') |> parse.(Int, __)
end


function main1(path, n=2020)
    numbers = get_input(path)
    memo = Dict(n => i for (i, n) in enumerate(numbers[1:end - 1]))
    prev = numbers[end]
    s = length(numbers)
    val = -1
    for i in s:(n - 1)
        if haskey(memo, prev)
            val = i - memo[prev]
        else
            val = 0
        end
        memo[prev] = i
        prev = val
    end
    prev
end

function main2(path)
    main1(path, 30000000)
end


main1("day15/input_sample.txt")
@btime main1("day15/input.txt")
@btime main2("day15/input.txt")