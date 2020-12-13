using PrettyPrinting

function read_batch(path::String)::Vector{Dict{String,String}}
    out::Vector{Dict{String,String}} = []
    curr_dict = Dict()
    for line in eachline(path)
        if strip(line) == ""
            push!(out, curr_dict)
            curr_dict = Dict()
        else
            pairs = [split(kv, ':') for kv=split(line)]
            for (k, v) in pairs
                curr_dict[k] = v
            end
        end
    end
    if length(curr_dict) > 0
        push!(out, curr_dict)
    end
    return out
end

function read_sample()
    return read_batch("day4/input_sample.txt")
end

function read_sample2()
    return read_batch("day4/input_sample2.txt")
end

function read_input()
    return read_batch("day4/input.txt")
end

function byr_rule(byr::String)::Bool
    byr = parse(Int64, byr)
    valid = 1920 <= byr <= 2002
    return valid
end

function iyr_rule(iyr::String)::Bool
    iyr = parse(Int64, iyr)
    valid = 2010 <= iyr <= 2020
    return valid
end

function eyr_rule(eyr::String)::Bool
    eyr = parse(Int64, eyr)
    valid = 2020 <= eyr <= 2030
    return valid
end

function hgt_rule(hgt::String)::Bool
    char_idx = -1
    len_hgt = length(hgt)
    for i in eachindex(hgt)
        if ~isdigit(hgt[i])
            char_idx = i
            break
        end
    end
    if char_idx >= len_hgt
        return false
    end

    if char_idx < 2
        return false
    end
    num = parse(Int64, hgt[1:char_idx-1])
    msr = hgt[char_idx:len_hgt]
    if msr == "cm"
        if 150 <= num <= 193
            return true
        end
    elseif msr == "in"
        if 59 <= num <= 76
            return true
        end
    end
    return false
end

function hcl_rule(hcl::String)::Bool
    if length(hcl) != 7
        return false
    end
    valid = occursin(r"^([0-9]|[a-f])*$", hcl[2:length(hcl)])
    return valid
end


expected_ecl = Set(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])
function ecl_rule(ecl::String)::Bool
    valid = ecl in expected_ecl
    return valid
end

function pid_rule(pid::String)::Bool
    valid = length(pid) == 9 && (tryparse(Int64, pid) !== nothing)
    return valid
end


passport_rules = Dict(
    "byr" => byr_rule,
    "iyr" => iyr_rule,
    "eyr" => eyr_rule,
    "hgt" => hgt_rule,
    "hcl" => hcl_rule,
    "ecl" => ecl_rule,
    "pid" => pid_rule,
)

required_fields = Set(["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"])
function is_present(keys::Set{String})::Bool
    valid = issubset(required_fields, keys)
    return valid
end

function is_valid(p::Dict{String})::Bool
    for (k, v) in p
        if haskey(passport_rules, k)
            if ~passport_rules[k](v)
                return false
            end
        end
    end
    return true
end

function main_sample()::Int64
    passports = read_sample()
    count_valid = 0
    for p in passports
        if is_present(Set(keys(p)))
            count_valid += 1
            println("VALID PASSPORT:")
            pprint(p)
            println()
        else
            println("INVALID PASSPORT:")
            pprint(p)
            println()
        end
    end
    println()
    println("Number of valid passports in sample: $count_valid")
    return count_valid
end

function main1()
    passports = read_input()
    count_valid = 0
    for p in passports
        if is_present(Set(keys(p)))
            count_valid += 1
        end
    end
    println("Number of valid passports: $count_valid")
    return count_valid
end

function main_sample2()::Int64
    passports = read_sample2()
    count_valid = 0
    for p in passports
        if is_present(Set(keys(p)))
            if is_valid(p)
                count_valid += 1
                println("VALID PASSPORT:")
                pprint(p)
                println()
            else
                println("INVALID PASSPORT:")
                pprint(p)
                println()
            end
        end
    end
    println()
    println("Number of valid passports in sample: $count_valid")
    return count_valid
end

function main2()::Int64
    passports = read_input()
    count_valid = 0
    for p in passports
        if is_present(Set(keys(p)))
            if is_valid(p)
                count_valid += 1
            end
        end
    end
    println()
    println("Number of valid passports: $count_valid")
    return count_valid
end

@time main_sample()
@time main1()
@time main_sample2()
@time main2()