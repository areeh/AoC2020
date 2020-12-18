using Underscores
using BenchmarkTools
using DelimitedFiles

function read_input(path)
    open(path) do io
        rules::Vector{Tuple{String,Vector{Array{Int,1}}}} = []
        line = readline(io)
        while line != ""
            (name, rule) = split(line, ':')
            rule = @_ rule |> split(__[2:end], " or ") |> split.(__, '-') |> map(parse.(Int, _), __)
            push!(rules, (name, rule))
            line = readline(io)
        end

        _ = readline(io)  # "your ticket:"
        your_ticket = @_ readline(io) |> split(__, ',') |> parse.(Int, __)
        
        _ = readline(io) # ""
        _ = readline(io) # "nearby tickets:"
        nearby_tickets = readdlm(io, ',', Int)
        (rules = rules, your_ticket = your_ticket, nearby_tickets = nearby_tickets)
    end
end

function check_tickets_any(tickets, rules)
    invalid::Vector{Int} = []
    s_tickets = size(tickets)
    valid_idxs = trues(s_tickets[1])

    for i in 1:s_tickets[1]
        for j in 1:s_tickets[2]
            valid = false
            for (name, r) in rules
                if r[1][1] <= tickets[i,j] <= r[1][2] || r[2][1] <= tickets[i,j] <= r[2][2]
                    valid = true
                    break
                end
            end
            if !valid
                push!(invalid, tickets[i,j])
                valid_idxs[i] = 0
            end
        end
    end
    tickets = tickets[valid_idxs, :]
    invalid, tickets
end

function find_fields(tickets, rules)
    invalid::Vector{Int} = []
    field_positions::Dict{String,Vector{Int}} = Dict()
    s_tickets = size(tickets)

    valid = true
    for j in 1:s_tickets[2]
        for (name, r) in rules
            valid = true
            for i in 1:s_tickets[1]
                if !(r[1][1] <= tickets[i,j] <= r[1][2] || r[2][1] <= tickets[i,j] <= r[2][2])
                    valid = false
                    break
                end
            end
            if valid
                if haskey(field_positions, name)
                    push!(field_positions[name], j)
                else
                    field_positions[name] = [j]
                end
            end
        end
    end
    field_positions
end

function reduce_to_unique!(fields)
    while any(length(val) != 1 for val in values(fields))
        for (k, v) in fields
            if length(v) == 1
                for (k1, v1) in fields
                    if length(v1) > 1
                        fields[k1] = setdiff!(v1, v[1])
                    end
                end
            end
        end
    end
    fields
end


function main1(path)
    input = read_input(path)
    nearby_tickets = input.nearby_tickets
    invalid, _ = check_tickets_any(nearby_tickets, input.rules)
    sum(invalid)
end

function main2(path)
    input = read_input(path)
    _, valid_tickets = check_tickets_any(input.nearby_tickets, input.rules)
    field_positions = find_fields(valid_tickets, input.rules)
    reduce_to_unique!(field_positions)
    dep_fields = filter(startswith("departure"), keys(field_positions))
    prod(input.your_ticket[[field_positions[k][1] for k in dep_fields]])
end

main1("day16/input_sample.txt")
@btime main1("day16/input.txt")
main2("day16/input_sample.txt")
main2("day16/input_sample2.txt")
@btime main2("day16/input.txt")