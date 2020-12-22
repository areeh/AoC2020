using Underscores
using BenchmarkTools

function read_input(path)
    rules::Dict{Int,Union{Char,Vector{Vector{Int}}}} = Dict()
    
    lines = readlines(path)
    (l, line_idx) = iterate(lines)
    while l != ""
        (idx, r) = split(l, ':')
        idx = parse(Int, idx)
        if r[2] == '"'
            rules[idx] = r[3]
        else
            outer::Vector{Vector{Int}} = []
            inner::Vector{Int} = []
            r = split(r)
            for i in eachindex(r)
                v = tryparse(Int, r[i])
                if v !== nothing
                    push!(inner, v)
                else
                    push!(outer, inner)
                    inner = []
                end
            end
            push!(outer, inner)
            rules[idx] = outer
        end
        (l, line_idx) = iterate(lines, line_idx)
    end
    (rules = rules, messages = lines[line_idx:end])
end

function and(s, r, rules, idx)
    match = true
    inner_idx = idx
    for rule in r
        (match, inner_idx) = check_rule(s, rules[rule], rules, inner_idx)
        if !match
            return (match, idx)
        end
    end
    (match, inner_idx)
end

function or(s, r, rules, idx)
    match = false
    inner_idx = idx
    for rule in r
        (match, inner_idx) = check_rule(s, rule, rules, inner_idx)
        if match
            return (match, inner_idx)
        end
    end
    (match, idx)
end

function check_rule(s, r, rules, idx)
    if isa(r, Char)
        if s[idx] == r
            (true, idx + 1)
        else
            (false, idx)
        end
    else
        if isa(r[1], Vector)
            (match, idx) = or(s, r, rules, idx)
        elseif isa(r[1], Int)
            (match, idx) = and(s, r, rules, idx)
        end
    end
end

function count_valid(t)
    count = 0
    match = false
    for m in t.messages
        (match, acc) = check_rule(m, t.rules[0], t.rules, 1)
        if match && acc - 1 == length(m)
            count += 1 
        end
    end
    count
end


function main1(path)
    t = read_input(path)
    count_valid(t)
end

function main2(path)
    t = read_input(path)
    t.rules[8] = [[42], [42, 8]]
    t.rules[11] = [[42, 32], [42, 11, 31]]
    count_valid(t)
end

# main1("day19/input_sample.txt")
# main1("day19/input.txt")
main2("day19/input.txt")