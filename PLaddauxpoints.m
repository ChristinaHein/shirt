function PLn=PLaddauxpoints(PL,d)

% delete points between last and first point

PLn=CPLaddauxpoints(PL,d);

n=find((PL(end,1)==PLn(:,1)) & (PL(end,2)==PLn(:,2)));
PLn = PLn(1:n,:);
