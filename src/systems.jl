export load_start_pairs, save_start_pairs,
    TestSystem, Steiner, Cyclooctane, Bacillus

abstract type TestSystem end

function load_start_pairs(directory)
    start_solutions_real = readdlm(joinpath(directory, "solutions_real.txt"), '\t', Float64, '\n')
    start_solutions_imag = readdlm(joinpath(directory, "solutions_imag.txt"), '\t', Float64, '\n')
    m, n = size(start_solutions_real)
    S = [[complex(start_solutions_real[i, j], start_solutions_imag[i,j]) for j=1:n] for i=1:m]
    p = readdlm(joinpath(directory, "parameters.txt"), '\t', ComplexF64)[:,1]
    S, p
end

function save_start_pairs(directory, S, p)
    A = [S[i][j] for i in 1:length(S), j in 1:length(S[1])]
    A_real = round.(real.(A); sigdigits=8)
    A_imag = round.(imag.(A); sigdigits=8)
    open(joinpath(directory, "solutions_real.txt"), "w") do io
        writedlm(io, A_real, '\t')
    end
    open(joinpath(directory, "solutions_imag.txt"), "w") do io
        writedlm(io, A_imag, '\t')
    end
    open(joinpath(directory, "parameters.txt"), "w") do io
        writedlm(io, p, '\t')
    end
    true
end

export system, parameters, start_solutions, start_parameters, nvariables, npolynomials, nparameters

function system end
parameters(::TestSystem) = nothing
start_solutions(::TestSystem) = nothing
start_parameters(::TestSystem) = nothing

function nvariables end
function npolynomials end
nparameters(::TestSystem) = nothing


include("systems/steiner/system.jl")
include("systems/cyclooctane/system.jl")
include("systems/bacillus/system.jl")