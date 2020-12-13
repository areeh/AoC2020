function get_ans_any(path::String)::Vector{Set{Char}}
    out::Vector{Set{Char}} = []
    curr_group::Set{Char} = Set()
    for line in eachline(path)
        line = string(line)
        if strip(line) == ""
            push!(out, curr_group)
            curr_group = Set()
        else
            for c in line
                push!(curr_group, c)
            end
        end
    end
    if length(curr_group) > 0
        push!(out, curr_group)
    end
    return out
end

function get_ans_all(path::String)::Vector{Vector{Set{Char}}}
    out::Vector{Vector{Set{Char}}} = []
    curr_group::Vector{Set{Char}} = []
    for line in eachline(path)
        line = string(line)
        if strip(line) == ""
            push!(out, curr_group)
            curr_group = []
        else
            push!(curr_group, Set([c for c in line]))
        end
    end
    if length(curr_group) > 0
        push!(out, curr_group)
    end
    return out
end

function get_sample_any()
    get_ans_any("day6/input_sample.txt")
end

function get_input_any()
    get_ans_any("day6/input.txt")
end

function get_sample_all()
    get_ans_all("day6/input_sample.txt")
end

function get_input_all()
    get_ans_all("day6/input.txt")
end


function all_intersect(v::Vector{Set{Char}})::Set{Char}
    if length(v) == 0
        return Set()
    end

    out = v[1]
    for s in v
        out = intersect(out, s)
    end
    return out
end

function main_sample()
    answers = get_sample_any()
    sum([length(s) for s in answers])
end

function main()
    answers = get_input_any()
    sum([length(s) for s in answers])
end

function main_sample2()
    answers = get_sample_all()
    out = 0
    for ans in answers
        out += length(all_intersect(ans))
    end
    println(out)
    return out
end

function main2()
    answers = get_input_all()
    out = 0
    for ans in answers
        out += length(all_intersect(ans))
    end
    return out
end

@time main_sample()
@time main()
@time main_sample2()
@time main2()