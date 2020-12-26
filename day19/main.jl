using BenchmarkTools
using ResumableFunctions

function read_input(path)
    rules::Dict{Int,Union{Char,Array}} = Dict()
    
    lines = readlines(path)
    (l, idx) = iterate(lines)
    while l != ""
        (key, rule) = split(l, ": ")
        key = parse(Int, key)
        if rule[1] == '"'
            rules[key] = rule[2]
        else
            r = []
            sequences = if occursin(" | ", rule) split(rule, " | ") else [rule] end
            for seq in sequences
                if isa(seq, Char)
                    val = parse(Int, seq)
                elseif occursin(' ', seq) 
                    val = parse.(Int, split(seq))
                else 
                    val = parse.(Int, seq)
                end
                push!(r, val)
            end
            rules[key] = r            
        end
        (l, idx) = iterate(lines, idx)
    end
    (rules = rules, strings = lines[idx:end])
end

@resumable function and(rules, seq, str)
    if isempty(seq)
        @yield str
    else
        (key, seq) = Iterators.peel(seq)
        for str in rule(rules, key, str)
            for val in and(rules, seq, str)
                @yield val
            end
        end
    end
end

@resumable function or(rules, alt, str)
    for seq in alt
        for val in and(rules, seq, str)
            @yield val
        end
    end
end

@resumable function rule(rules, key, str)
    if isa(rules[key], Vector)
        for val in or(rules, rules[key], str)
            @yield val
        end
    else
        if str != "" && str[1] == rules[key]
            @yield str[2:end]
        end
    end
end
            

function is_valid(rules, str)
    any(m == "" for m=rule(rules, 0, str))
end

function count_valid(rules, strings)
    sum(is_valid(rules, str) for str=strings)
end

function main1(path)
    t = read_input(path)
    count_valid(t.rules, t.strings)
end

function main2(path)
    t = read_input(path)
    t.rules[8] = [[42], [42, 8]]
    t.rules[11] = [[42, 31], [42, 11, 31]]
    count_valid(t.rules, t.strings)
end

main1("day19/input_sample.txt")
@btime main1("day19/input.txt")
main2("day19/input_sample2.txt")
@btime main2("day19/input.txt")