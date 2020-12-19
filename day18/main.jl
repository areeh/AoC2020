using DataStructures
using Underscores
using BenchmarkTools

function shunting_yard(tokens, p::Dict{Char,Int})
    """
    Based on shunting-yard algorithm
    https://en.wikipedia.org/wiki/Shunting-yard_algorithm
    """
    valid_ops = Set(['*', '+'])
    out::Vector{Char} = []
    ops = Stack{Char}()
    for t in tokens
        if !isnothing(tryparse(Int, string(t)))
            push!(out, t)
        elseif t in valid_ops
            while !isempty(ops) && first(ops) != '(' && (p[first(ops)] > p[t] || p[first(ops)] == p[t])
                push!(out, pop!(ops))
            end
            push!(ops, t)
        elseif t == '('
            push!(ops, t)
        elseif t == ')'
            while first(ops) != '('
                try
                    push!(out, pop!(ops))
                catch exc
                    throw(ArgumentError("Mismatched parenthesis"))
                end
            end
            if first(ops) == '('
                pop!(ops)
            end
        end
    end
    while !isempty(ops)
        op = pop!(ops)
        if op in ('(', ')')
            throw(ArgumentError("Mismatched parenthesis"))
        end
        push!(out, op)
    end
    out
end

function reverse_polish_notation(s::Vector{String})
    """
    Evaluate Reverse Polish Notation
    https://en.wikipedia.org/wiki/Reverse_Polish_notation
    """
    stack = Stack{Union{Function,Number}}()
    for op in map(eval, map(Meta.parse, s))
        if isa(op, Function)
            r = pop!(stack)
            l = pop!(stack)
            push!(stack, op(l, r))
        else
            push!(stack, op)
        end
    end
    first(stack)
end

function evaluate(s, precedences)
    s = @_ filter(!isspace(_), s)
    rpn = shunting_yard(s, precedences) |> @_ map(string(_), __)
    reverse_polish_notation(rpn)
end


function samples1()
    for s in (("2 * 3 + (4 * 5)", 26),
        ("1 + 2 * 3 + 4 * 5 + 6", 71),)
        out = evaluate(s[1], Dict('*' => 1, '+' => 1))
        @assert out == s[2]
    end
end

function samples2()
    for s in (("2 * 3 + (4 * 5)", 46),
        ("1 + 2 * 3 + 4 * 5 + 6", 231),)
        out = evaluate(s[1], Dict('*' => 1, '+' => 2))
        @assert out == s[2]
    end
end

function main1(path)
    sum([evaluate(line, Dict('*' => 1, '+' => 1)) for line in readlines(path)])
end

function main2(path)
    sum([evaluate(line, Dict('*' => 1, '+' => 2)) for line in readlines(path)])
end

samples1()
samples2()
@btime main1("day18/input.txt")
@btime main2("day18/input.txt")