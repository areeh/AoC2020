using Dates

cookie_token="***REMOVED***"

function make_day(day::Int64)
    day_dir = mkpath(joinpath(pwd(), "day$day"))
    fpath = joinpath(day_dir, "input.txt")
    if isfile(fpath)
        return
    end

    url = "https://adventofcode.com/2020/day/$day/input"
    cmd = `curl $url -H "cookie: session=$cookie_token" -o $fpath`
    print(cmd)
    run(cmd)
    touch(joinpath(day_dir, "main.jl"))
end

function make_until_today()
    today = Dates.day(Dates.today())
    for i in 1:today
        make_day(i)
    end
end

make_until_today()