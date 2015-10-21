set(0,'DefaultFigureWindowStyle','docked')
set(0,'defaulttextinterpreter','latex')
%% 
A = userpath;
A=A(1:end-1);
addpath(genpath(A))
clear all

A=A(1:end-1);
C= strsplit(A,'/')
C=C(1:end-1);
addpath('/Applications/Fiji.app/scripts')