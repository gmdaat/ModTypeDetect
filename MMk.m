function [Mkm] = MMk(x, k, m)
    Mkm = mean(x.^(k-m).*conj(x).^m);
end