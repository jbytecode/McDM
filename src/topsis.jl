function topsis(decisionMat::DataFrame, weights::Array{Float64,1})
    
    w = unitize(weights)
    nalternatives, ncriteria = size(decisionMat)
    
    normalizedMat = normalize(decisionMat)
    
    weightednormalizedMat = w * normalizedMat
    
    col_max = colmaxs(weightednormalizedMat)
    col_min = colmins(weightednormalizedMat)

    distances_plus  = zeros(Float64, nalternatives)
    distances_minus = zeros(Float64, nalternatives)

    scores = zeros(Float64, nalternatives)

    @inbounds for i in 1:nalternatives
		distances_plus[i]  = euclidean(col_max, weightednormalizedMat[i,:] |> Array{Float64,1})
		distances_minus[i] = euclidean(col_min, weightednormalizedMat[i,:] |> Array{Float64,1})
		scores[i] = distances_minus[i] / (distances_minus[i] + distances_plus[i])
    end
    
    best_index = sortperm(scores) |> last
    
    topsisresult = TopsisResult(
        decisionMat,
        w,
        normalizedMat,
        weightednormalizedMat,
        best_index,
        scores
    ) 

    return topsisresult
end