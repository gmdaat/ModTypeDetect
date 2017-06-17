function [fs1] = classify(x)
%     fs1 = abs(MMk(x, 8, 0))/MMk(x, 2,1).^4;
    m80 = MMk(x, 8, 0);
    m60 = MMk(x, 6, 0);
    m40 = MMk(x, 4, 0);
    m20 = MMk(x, 2, 0);
    m21 = MMk(x, 2, 1);
    c80 = m80  - 28*m20*m60 - 35*m40^2 + 420*m20^2*m40 - 630*m20^4;
    c21 = m21;
    fs1 = abs(c80)/c21^4;
end