function [fs1] = classify(x)
%     fs1 = abs(MMk(x, 8, 0))/MMk(x, 2,1).^4;
    m80 = MMk(x, 8, 0);
    m60 = MMk(x, 6, 0);
    m40 = MMk(x, 4, 0);
    m20 = MMk(x, 2, 0);
    m21 = MMk(x, 2, 1);
    
    c80 = m80  - 28*m20*m60 - 35*(m40^2) + 420*(m20^2)*m40 - 630*(m20^4);
    c21 = m21;
    
    fs1 = abs(c80)/(abs(c21)^4);
    
    xdm = medfilt1(abs(diff(x)));
    
    md42 = MMk(xdm, 4, 2);
    md20 = MMk(xdm ,2, 0);
    md21 = MMk(xdm, 2, 1);
    md63 = MMk(xdm, 6, 3);
    md41 = MMk(xdm, 4, 1);
    
    cd42 = md42 - abs(md20)^2 - 2*md21^2;
    cd63 = md63 - 6*md41*md20 - 9*md42*md21 + 18*md20^2*md21 + 12*md21^3;
    
    fs2 = (abs(cd63)^2)/(abs(cd42)^3);
    
end