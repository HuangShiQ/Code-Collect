function Lout = MarkPseudoBlob( L, bwridge, NUMTHRESH, MERGETHRESH )

%% Mark those unqualified blob as -1
LABELNUM = max(L(:));
Metrics = ones([1, LABELNUM ]);
for i = 1:LABELNUM
    blob = (L==i);
    xt = sum(blob(:));
    if( xt>0 )
        blobperim = bwperim(blob); %perimeter
        xt = sum(sum(bwridge&blobperim)); %ridge in the perimeter
        yt = sum(sum(blobperim));
        Metrics(i) = xt/yt;
    end
end
[sval, sid] = sort(Metrics);

Lout = L;
for i = 1:NUMTHRESH
    if( sval(i)<MERGETHRESH )
        Lout(L==sid(i)) = -1;
    end
end