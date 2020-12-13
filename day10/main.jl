using DelimitedFiles
using PrettyPrinting
using BenchmarkTools

function get_input(path::String="day10/input.txt")::Array{Int,1}
    readdlm(path)[:]
end

function get_sample1()
    get_input("day10/input_sample1.txt")
end

function get_sample2()
    get_input("day10/input_sample2.txt")
end

function count_diffs(numbers::Array{Int,1})::Int    sort!(numbers)
    diffs = diff(numbers)
    u_counts = [sum(diffs .==1), sum(diffs .==3)]
    
    # simulate adding a 0 and max+3 to avoid mutating Array
    u_counts[2] += 1
    if numbers[1] == 1
        u_counts[1] += 1
    elseif numbers[1] == 3
        u_counts[2] += 1
    end
    
    u_counts[1] * u_counts[2]
end

function counter!(current::Int, remainder::Array{Int,1}, memo::Dict{Int,Int})::Int
    #println("current $current remainder $remainder, memo $memo")
    if haskey(memo, current)
        #println("return memo")
        return memo[current]
    elseif length(remainder) == 0 || remainder[1]-current > 3
        #println("return 0")
        return 0
    else
        #println("ran")
        count = counter!(current, remainder[2:end], memo) + counter!(remainder[1], remainder[2:end], memo)
        memo[current] = count
        return count
    end
end

function count_combinations(numbers::Array{Int,1})::Int
    sort!(numbers)
    memo::Dict{Int,Int} = Dict(maximum(numbers) => 1)
    c = counter!(0, numbers, memo)
    return c
end

function main1_sample()
    numbers = get_sample1()
    count = count_diffs(numbers)
    #println(count)
    return count
end

function main1()
    numbers = get_input()
    count = count_diffs(numbers)
    #println(count)
    return count
end

function main2_sample1()
    numbers = get_sample1()
    count = count_combinations(numbers)
    #println(count)
end

function main2_sample2()
    numbers = get_sample2()
    count = count_combinations(numbers)
    #println(count)
end

function main2()
    numbers = get_input()
    count = count_combinations(numbers)
    #println(count)
end



@btime main1_sample()
@btime main1()
@btime main2_sample1()
@btime main2_sample2()
@btime main2()