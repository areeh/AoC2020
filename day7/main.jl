using BenchmarkTools

function get_rules(path::String)::Dict{String,Vector{Tuple{String,Int}}}
    out = Dict()
    for line in eachline(path)
        words = split(line)

        if words[5:6] == ["no", "other"]
            out[words[1] * words[2]] = []
        else
            out[words[1] * words[2]] = [(words[i + 1] * words[i + 2], parse(Int64, words[i])) for i in 5:4:length(words) - 2]
        end
    end
    return out
end

function get_sample()
    get_rules("day7/input_sample.txt")
end

function get_sample2()
    get_rules("day7/input_sample2.txt")
end

function get_input()
    get_rules("day7/input.txt")
end

function count_has_gold(rules::Dict{String,Set{String}})::Int
    # bag => (bag, count)
    memo::Dict{String,Int} = Dict()
    for bag in keys(rules)
        to_visit::Vector{String} = [bag]
        if haskey(memo, bag)
            continue
        end

        while ~isempty(to_visit)
            curr_bag = pop!(to_visit)

            if haskey(memo, curr_bag)
                memo[bag] = 1
                break
            end

            contents = rules[curr_bag]
            if "shinygold" in contents
                memo[bag] = 1
                memo[curr_bag] = 1
                break
            else
                append!(to_visit, contents)
            end
        end
    end
    return length(memo)
end

function count_bag_memo(bag::String, all_bags::Dict{String,Vector{Tuple{String,Int}}}, memo::Dict{String,Int})::Int
    if haskey(memo, bag)
        return memo[bag]
    end
    contents = all_bags[bag]
    if isempty(contents)
        memo[bag] = 1
        return 1
    else
        val = sum([count * count_bag_memo(inner_bag, all_bags, memo) for (inner_bag, count) = contents])
        val += 1 # count self
        memo[bag] = val
        return val
    end
end

function count_bag(bag::String, all_bags::Dict{String,Vector{Tuple{String,Int}}})::Int
    contents = all_bags[bag]
    if isempty(contents)
        return 1
    else
        val = sum([count * count_bag(inner_bag, all_bags) for (inner_bag, count) = contents])
        val += 1 # count self
        return val
    end
end


function count_bags_memo(bag::String, rules::Dict{String,Vector{Tuple{String,Int}}})::Int
    memo::Dict{String,Int} = Dict()
    cnt = count_bag_memo(bag, rules, memo) - 1  # Don't count outer bag
    return cnt
end

function count_bags(bag::String, rules::Dict{String,Vector{Tuple{String,Int}}})::Int
    cnt = count_bag(bag, rules) - 1  # Don't count outer bag
    return cnt
end

function main_sample1()
    rules = get_sample()
    rules_set::Dict{String,Set{String}} = Dict()
    for (k, v) in rules
        rules_set[k] = Set(c[1] for c in rules[k])
    end
    count_has_gold(rules_set)
end

function main1()
    rules = get_input()
    rules_set::Dict{String,Set{String}} = Dict()
    for (k, v) in rules
        rules_set[k] = Set(c[1] for c in rules[k])
    end
    count = count_has_gold(rules_set)
end

function main_sample2()
    rules = get_sample()
    bag = "shinygold"
    cnt = count_bags_memo(bag, rules)
    return cnt
end

function main_sample2_2()
    rules = get_sample2()
    bag = "shinygold"
    cnt = count_bags_memo(bag, rules)
    return cnt
end

function main2_memo()
    rules = get_input()
    bag = "shinygold"
    cnt = count_bags_memo(bag, rules)
    return cnt
end

function main2()
    rules = get_input()
    bag = "shinygold"
    cnt = count_bags(bag, rules)
    return cnt
end

main_sample1()
@btime main1()
main_sample2()
main_sample2_2()
@btime main2_memo()
@btime main2()