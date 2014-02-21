function bbs = detect( prm )
% Matlab wrapper for Piotr Dollar's BMVC09/BMVC10 pedestrian detector.
%
% Used to detect all pedestrians (peds) in an image. If the fast flag is
% set to true uses BMVC10 sped up version of detector (which approximates
% features at nearby scales), otherwise uses BMVC09 version. Default model
% size is 100 pixels, to detect larger peds set the resize flag to a value
% greater than 1 (e.g. resize=2 detects 50+ pixel peds, resize=.5 detects
% 200+ pixel peds). If a results file is specified writes result to disk,
% otherwise returns them. For fast speed, set fast to true, d to be large,
% and resize, nScale and pad to be small. Of course, these changes may also
% degrade performance. Expected runtimes for the fast version with the
% default settings are between 3-6 fps for 640x480 images (but will vary
% depending on your computer and the amount of clutter in the image).
%
% Note: first call after parameters change is slow as it performs
% classifier intialization. So parameters should be set once and then the
% detect command should be used repeatedly. Initialization can take 5-10s.
% For example, running the example code below takes about 5s and then each
% subsequent call to detect takes a small fraction of a second.
%
% The detect command requires the Matlab mex file boost.mex. Binaries are
% provided for 64 bit Windows and Linux. A pre-trained model is necessary,
% this consists of two files (model_clf.txt and model_dPrm.txt).
% Additionally the support file boostClfRescale.m is necessary for the fast
% version of the detector. Finally Piotr's Matlab toolbox is necessary for
% performing NMS and other various support functions. It is available at:
%  http://vision.ucsd.edu/~pdollar/toolbox/doc/
%
% If you use this code please cite the following papers:
%  [1] P. Dollár, Z. Tu, P. Perona and S. Belongie
%      "Integral Channel Features", BMVC 2009.
%  [2] P. Dollár, S. Belongie and P. Perona,
%      "The Fastest Pedestrian Detector in the West," BMVC 2010.
% More details about the method can also be found in the above papers.
%
% Finally, to compute the channels used by a classifer, use the following:
%   prm = boost('frFile','ChnFtrs01_dPrm.txt');
%   nm = 'I.png'; I = imread(nm);
%   chs = boost('compChs',prm.chnPrm,I);
%   figure(1); im(chs(:,:,1));
%
% USAGE
%  bbs = detect( prm )
%
% INPUTS
%  prm
%   .imgNm      - ['REQ'] image file name or actual image
%   .resNm      - [''] target file name (if empty output bbs)
%   .resize     - [1] image upscaling (increase to detect small peds)
%   .modelNm    - ['REQ'] file name for trained classifer
%   .thr        - [-100] detection threshold (discard bbs below thr)
%   .nScale     - [10] number of scale per octave (8-10 work well)
%   .d          - [4] spatial step in pixels (4-8 work well)
%   .pad        - [0] image padding in pixels (pad=1 is max padding)
%   .fast       - [1] if true use BMVC10 fast features
%
% OUTPUTS
%   bbs         - [nx5] array of detected bbs and confidences
%
% EXAMPLE
%   nm='I.png'; I=imread(nm);
%   prm=struct('imgNm',nm,'modelNm','ChnFtrs01','resize',1,'fast',1);
%   tic, bbs=detect(prm); toc
%   figure(1); im(I,[],0); bbApply('draw',bbs,'g');
%
% See also bbNms, bbApply, bbApply>draw, bbApply>embed

% get parameters
dfs = {'imgNm','REQ', 'resNm',[], 'resize',1, 'modelNm','REQ', ...
  'thr',-100, 'nScale',10, 'd',4, 'pad', 0, 'fast',1 };
[imgNm,resNm,resize,modelNm,thr,nScale,d,pad,fast] = getPrmDflt(prm,dfs,1);

% load/setup model (cache for efficiency)
persistent pDetId prmPr
prm=getPrmDflt(prm,dfs,1); prm.imgNm=''; prm.resNm='';
if( isempty(pDetId) || ~isequal(prm,prmPr) )
  modelDir = fileparts(mfilename('fullpath')); prmPr=prm;
  pData = boost('frFile',[modelDir '/' modelNm '_dPrm.txt']);
  clf = boost('frFile',[modelDir '/' modelNm '_clf.txt']);
  if( fast )
    pResc = {'m',nScale,'r',1,'r0',log2(resize),'dx',d,'dy',d,...
      'lambdas',[1.13 log(4)]};
    pDet = boostClfRescale(clf,pData.chnPrm,pResc);
    pDet.thr=thr; pDet.chnPrm.padx=1; pDet.chnPrm.pady=1; pDet.pad=pad;
  else
    pDet=boost('getPrms','DetectImg'); pDet.chnPrm=pData.chnPrm;
    pDet.clf.val=clf; pDet.resize=resize;
    pDet.ss=2^(1/nScale); pDet.dx=d; pDet.dy=d;
    pDet.thr=thr; pDet.chnPrm.padx=2; pDet.chnPrm.pady=2; pDet.pad=pad;
  end
  pDetId=boost('addToCache',pDet);
end
pNms=struct('type','maxg','overlap',.65,'ovrDnm','min',...
  'maxn',5000,'resize',{{100/128 43/64 0}});

% load image, run detect command
if(ischar(imgNm)), I=imread(imgNm); else I=imgNm; end
bbs=bbNms(boost('detectImg',I,pDetId),pNms);
bbs=bbs(:,1:5);

% if resNm specified, save to disk
if(~isempty(resNm)), dlmwrite(resNm,bbs); bbs=1; end

end
