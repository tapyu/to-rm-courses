function input_fuzzyfication(xₙ, I)
    sets = rand(I)
    if I == 2
        # SMALL fuzzy set, centered at 75 (1th set)
        if xₙ < 75
            sets[1] =  xₙ/75
        elseif xₙ < 150
            sets[1] =  -(xₙ - 150)/75
        else
            sets[1] = 0
        end
        # LARGE fuzzy set, centered at 175 (2th set)
        if xₙ < 100
            sets[2] = 0
        elseif xₙ < 175
            sets[2] = (xₙ - 100)/75
        else
            sets[2] = -(xₙ - 250)/75
        end
    elseif I == 3
        # SMALL fuzzy set, centered at 50 (1th set)
        if xₙ < 50
            sets[1] = xₙ/50
        elseif xₙ < 100
            sets[1] = -(xₙ-100)/50
        else
            sets[1] = 0
        end
        # MEDIUM fuzzy set, centered at 125 (2th set)
        if xₙ < 75 || xₙ > 175
            sets[2] = 0
        elseif xₙ < 125
            sets[2] = (xₙ-75)/50
        else
            sets[2] = -(xₙ-175)/50
        end
        # LARGE fuzzy set, centered at 200 (3th set)
        if xₙ < 150
            sets[3] = 0
        elseif xₙ < 200
            sets[3] = (xₙ-150)/50
        else
            sets[3] = -(xₙ-250)/50
        end
    end
    return sets
end

function output_fuzzyfication(yₙ, I)
    sets = rand(I)
    if I == 2
        # SMALL fuzzy set, centered at 40 (1th set)
        if yₙ < 40
            sets[1] = yₙ/40
        elseif yₙ < 80
            sets[1] =  -(yₙ - 80)/40
        else
            sets[1] = 0
        end
        # LARGE fuzzy set, centered at 100 (2th set)
        if yₙ < 60
            sets[2] = 0
        elseif yₙ < 100
            sets[2] = (yₙ - 60)/40
        else
            sets[2] = -(yₙ - 140)/40
        end
    elseif I == 3
        # SMALL fuzzy set, centered at 30 (1th set)
        if yₙ < 30
            sets[1] = yₙ/30
        elseif yₙ < 60
            sets[1] = -(yₙ-60)/30
        else
            sets[1] = 0
        end
        # MEDIUM fuzzy set, centered at 70 (2th set)
        if yₙ < 40 || yₙ > 100
            sets[2] = 0
        elseif yₙ < 70
            sets[2] = (yₙ-40)/30
        else
            sets[2] = -(yₙ-100)/30
        end
        # LARGE fuzzy set, centered at 110 (3th set)
        if yₙ < 80
            sets[3] = 0
        elseif yₙ < 110
            sets[3] = (yₙ-80)/30
        else
            sets[3] = -(yₙ-140)/30
        end
    end
    return sets
end