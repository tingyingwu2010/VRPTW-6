
#01 Pure Greedy constructor ====================================================

function get_insert_cost(data, route, insert_loc, cust)
    dist = data["dist"]
    cust_pre = route[insert_loc-1]
    cust_nxt = route[insert_loc]
    insert_cost =
        dist[cust_pre, cust] + dist[cust, cust_nxt] - dist[cust_pre, cust_nxt]
    return insert_cost
end

function construct_greedy(data, s_main, s_child)
    s = deepcopy(s_main)
    for cust in s_child
        s = insert_greedy_cust(data, s, cust)
    end
    return s, 2
end

function insert_greedy_cust(data, s_main, cust)
    x, y = get_greedy_insert_loc(data, s_main, cust)
    if x == 0 && y == 0 # when insert location not found
        route = [1, cust, 1]
        push!(s_main, route)
    else
        route = deepcopy(s_main[x])
        s_main[x] = insert!(route, y, cust)
    end
    return s_main
end


function get_greedy_insert_loc(data, s_main, cust)
    min = nothing
    x, y = 0, 0
    for i = 1:length(s_main)
        for j = 2:length(s_main[i])
            route = deepcopy(s_main[i])
            route_new = insert!(route, j, cust)
            if is_valid_route(data, route_new)
                rand_idx = get_rand_inrange(0.8, 1.2)
                ist_cost = get_insert_cost(data, route, j, cust) * rand_idx
                if min == nothing || ist_cost <= min
                    x, y = i, j
                    min = ist_cost
                end
            end
        end
    end
    return x, y
end


#02 Greedy Pertubation constructor==============================================================================#
function construct_pertubation(data, s_main, s_child)
    s = deepcopy(s_main)
    for cust in s_child
        s = insert_pertubated_cust(data, s, cust)
    end
    return s, 2
end

function insert_pertubated_cust(data, s_main, cust)
    x, y = get_pertubated_insert_loc(data, s_main, cust)
    if x == 0 && y == 0 # when insert location not found
        route = [1, cust, 1]
        push!(s_main, route)
    else
        route = deepcopy(s_main[x])
        s_main[x] = insert!(route, y, cust)
    end
    return s_main
end


function get_pertubated_insert_loc(data, s_main, cust)
    min = nothing
    x, y = 0, 0
    for i = 1:length(s_main)
        for j = 2:length(s_main[i])
            route = deepcopy(s_main[i])
            route_new = insert!(route, j, cust)
            if is_valid_route(data, route_new)
                rand_idx = get_rand_inrange(0.8, 1.2)
                ist_cost = get_insert_cost(data, route, j, cust) * rand_idx
                if min == nothing || ist_cost <= min
                    x, y = i, j
                    min = ist_cost
                end
            end
        end
    end
    return x, y
end


function get_rand_inrange(a::Float64, b::Float64)
    scale = 1 / (b - a)
    mid = (a + b) / 2
    init = rand(1)[1]
    randnum = (init - 0.5) / scale + mid
    return randnum
end

#**picker==============================================================================#

function repair_factory(data, s_main, s_child, w)
    opt = get_repair_operator(w)
    if opt == "construct_greedy"
        return construct_greedy(data, s_main, s_child)
    elseif opt == "construct_pertubation"
        return construct_pertubation(data, s_main, s_child)
    end
end

function get_repair_operator(w)
    r_operators = ["construct_greedy", "construct_pertubation"]
    opt = sample(r_operators, Weights(w))
    return opt
end
