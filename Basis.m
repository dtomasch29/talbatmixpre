function z = Basis(basisID,x,y)

    if(basisID == 1)
        z = Basis1(x,y);
    elseif(basisID == 2)
        z = Basis2(x,y);
    elseif(basisID == 3)
        z = Basis3(x,y);
    elseif(basisID == 4)
        z = Basis4(x,y);
    elseif(basisID == 5)
        z = Basis5(x,y);
    elseif(basisID == 6)
        z = Basis6(x,y);
    elseif(basisID == 7)
        z = Basis7(x,y);
    elseif(basisID == 8)
        z = Basis8(x,y);
    elseif(basisID == 9)
        z = Basis9(x,y);
    endif

end

function z = Basis1(x,y)

    z = 0.25.*(1-x).*(1-y) - 0.5*Basis5(x,y) - 0.5*Basis8(x,y) - 0.25*Basis9(x,y);
end

function z = Basis2(x,y)
    z = 0.25*(1+x).*(1-y) - 0.5*Basis5(x,y) - 0.5*Basis6(x,y) - 0.25*Basis9(x,y);
end

function z = Basis3(x,y)
    z = 0.25*(1+x).*(1+y) - 0.5*Basis6(x,y) - 0.5*Basis7(x,y) - 0.25*Basis9(x,y);
end

function z = Basis4(x,y)
    z = 0.25*(1-x).*(1+y) - 0.5*Basis7(x,y) - 0.5*Basis8(x,y) - 0.25*Basis9(x,y);
end

function z = Basis5(x,y)
    z = 0.5 * (1-x.^2).*(1-y) - 0.5*Basis9(x,y);
end

function z = Basis6(x,y)
    z = 0.5*(1+x).*(1-y.^2) - 0.5*Basis9(x,y);
end

function z = Basis7(x,y)
    z = 0.5 * (1-x.^2).*(1+y) - 0.5*Basis9(x,y);
end

function z = Basis8(x,y)
    z = 0.5*(1-x).*(1-y.^2) - 0.5*Basis9(x,y);
end

function z = Basis9(x,y)

    z = (1-x.^2) .* (1-y.^2);
end
