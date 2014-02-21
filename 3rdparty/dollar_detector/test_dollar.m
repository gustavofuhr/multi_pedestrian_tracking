clear; close all; clc;


nm='I.png'; I=imread(nm);
prm=struct('imgNm',I,'modelNm','ChnFtrs01','resize',1,'fast',1);
tic, bbs=detect(prm); toc
figure(1); im(I,[],0); bbApply('draw',bbs,'g');