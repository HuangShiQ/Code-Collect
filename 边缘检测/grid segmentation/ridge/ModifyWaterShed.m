function Lout = ModifyWaterShed(L, Lt)

%% combine L and Lt using the "winner take all vote stratage"
[label, num] = bwlabel(L<0);
Lout = L;

for i = 1:num
    % winner vote
    regiontags = Lt(label==i);
    regiontags = regiontags(regiontags>0);
    regiontag = mode(regiontags); %Most frequent values in array
   
    %corrpondence to L
    regiontags1 = L(Lt==regiontag(1));
    regiontags1 = regiontags1(regiontags1>0);
    regiontag1 = mode(regiontags1);
   
    Lout(label==i) = regiontag1;
end