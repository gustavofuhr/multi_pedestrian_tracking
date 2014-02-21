function pDet = boostClfRescale( clf, chnPrm, varargin )
% Create multiple rescaled versions of original clf.
%
% Assumes decision trees of stumps as weak clfs, and each stump must be
% computed over a single rectangle haar. Channel types and lambdas for each
% type must be specified manually. The channel type is used to specify
% which lambda to use for a given channel index. For example, if using 6
% orientation bins, grad magnitude, and color channels, then:
%  types = [1 1 1 1 1 1 1 2 2 2]
%  lambdas = [1.1 log(4)]
% specifies that lambda=1.1 should be used for the gradient channels, and
% lambda=log(4) for the intensity channels.
%
% USAGE
%  pDet = boostClfRescale( clf, chnPrm, [varargin] )
%
% INPUTS
%  clf        - original clf to rescale
%  chnPrm     - channel parameters associated w clf
%  varargin   - additional params (struct or name/value pairs)
%   .m          - [8] number of scales per octave
%   .r          - [1] octave step size (m*r must be an integer)
%   .del        - [(m*r-1)/2] initial scale relative to model scale
%   .r0         - [0] extra octaves for detecting small objects
%   .dx         - [4] spatial stride: step size in x
%   .dy         - [4] spatial stride: step size in y
%   .types      - [see above] integer channel types
%   .lambdas    - [see above] decay rates for different channel types
%
% OUTPUTS
%  pDet       - contains multiple rescaled versions of the clf
%
% EXAMPLE
%
% See also
%
% Piotr's Image&Video Toolbox      Version NEW
% Copyright 2010 Piotr Dollar.  [pdollar-at-caltech.edu]
% Please email me if you find bugs, or have suggestions or questions!
% Licensed under the Lesser GPL [see external/lgpl.txt]

% get parameters
types=[1 1 1 1 1 1 1 2 2 2]; lambdas=[1.1 log(4)];
dfs={'m',8,'r',1,'del',[],'r0',0,'dx',4,'dy',4,...
  'types',types,'lambdas',lambdas};
[m,r,del,r0,dx,dy,types,lambdas] = getPrmDflt(varargin,dfs,1);
% determine all the scale and lock parameters (confusing)
n=r*m; n0=r0*m; assert(mod(n,1)==0); assert(mod(n0,1)==0);
if(isempty(del)), del=floor((n-1)/2); end; assert(del>=0 && del<=n);
scales=(-max(n0,del):n-del-1)/m; t=n0-del; n=length(scales);
locks=int32([sign(t)*ones(1,abs(t)) zeros(1,n-abs(t))]);
% set up pDet
pDet=boost('getPrms','DetectImg'); pDet.ss=2^r;
w=double(chnPrm.w); h=double(chnPrm.h); shrink=double(chnPrm.shrink);
pDet.chnPrm=chnPrm; pDet.clf.val=repmat(clf,1,n); pDet.scales=locks;
% add original and rescaled clfs
for s=1:n, scale=scales(s);
  % add original clf unchanged if at original scale
  if(scale==0), pDet.ws(s)=w; pDet.hs(s)=h;
    pDet.dxs(s)=dx; pDet.dys(s)=dy; continue; end
  % compute clf size (w and h) and step strides (dx and dy)
  ratio=2^(scale); mults=ratio.^-(2-lambdas/log(2));
  w1=round(w*ratio); h1=round(h*ratio);
  pDet.ws(s)=w1; pDet.dxs(s)=round(max(shrink,dx*ratio));
  pDet.hs(s)=h1; pDet.dys(s)=round(max(shrink,dy*ratio));
  rsMax=floor(double([w1 h1])/shrink); clf1=clf;
  % adjust each weak clf (rectangle dims and stump threshold)
  for i=1:length(clf1.clfs.val)
    for j=1:length(clf1.clfs.val(i).clfs.val)
      cWeak=clf1.clfs.val(i).clfs.val(j);
      rs0=double(cWeak.ftr.haar.rs(1:4)); rs1=round(rs0*ratio);
      rs1([2 4])=min(max(rs1([2 4]),rs1([1 3])+1),rsMax);
      rs1([1 3])=max(min(rs1([1 3]),rs1([2 4])-1),0);
      a0=(rs0(2)-rs0(1))*(rs0(4)-rs0(3));
      a1=(rs1(2)-rs1(1))*(rs1(4)-rs1(3)); assert(a1>0);
      cWeak.ftr.haar.rs(1:4)=rs1; type=cWeak.ftr.haar.rs(5)+1;
      cWeak.stump(3)=cWeak.stump(3)*a1/a0*mults(types(type));
      clf1.clfs.val(i).clfs.val(j)=cWeak;
    end
  end
  pDet.clf.val(s)=clf1;
end
end
