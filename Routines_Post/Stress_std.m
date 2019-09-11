function [s_ij,s_xy] = Stress_std(mNDspS,mNdCrd,vElStd,mLNodS,vElPhz,...
                                  cDMatx,mPrLod,mGsShp,mGsDrv)

%--------------------------------------------------------------------------
% Stress at Gauss points (std. el.)
%--------------------------------------------------------------------------

global constitutive_field;

vElStd = vElStd(:)';

ngp = size(mGsShp,1);
ngt = length(vElStd)*ngp;

s_ij = zeros(3,ngt);
s_xy = zeros(ngt,2);
e    = zeros(3,1);

dXdx = zeros(2,2);
igd0 = 1:2;
igt  = 0;

% for i_phz = 1:nPhase
% 
% D = cDMatx{i_phz};
%    
% for iel = vElStd(vElPhz(vElStd)==i_phz)
 
for iel = vElStd
    
    mElCrd = mNdCrd(mLNodS(iel,:),:);
    
    mLDspS = mNDspS(:,mLNodS(iel,:))';
    
    xs    = mGsShp*mElCrd;
    dxdX = mGsDrv*mElCrd;
    dudX = mGsDrv*mLDspS;
    
    s_xy(igt+1:igt+ngp,:) = xs;
    s0 = mPrLod(:,iel);
    
    igd = igd0;
    
    for igp = 1:ngp
        
        J = dxdX(igd,:); detJ = J(1)*J(4)-J(2)*J(3);
        
        dXdx(1) =  J(4)/detJ; dXdx(3) = -J(3)/detJ;
        dXdx(2) = -J(2)/detJ; dXdx(4) =  J(1)/detJ;
        
        dudx = dXdx*dudX(igd,:);
        
        igd = igd + 2;
        igt = igt + 1;
        
        e(1) = dudx(1);
        e(2) = dudx(4);
        e(3) = dudx(2)+dudx(3);
        
        D = constitutive_field(xs(igp,:));
        
        s_ij(:,igt) = D*e + s0;
        
    end
    
end
% end
end
