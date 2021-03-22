function bipo_mni=mni_mono2bipolar(mono_mni, mono_labels, bipo_labels)
%% ---------------------------
%% [script name] mni_mono2bipolar.m
%%
%% SCRIPT to ...
%%
%% By Shuai Wang, [date] 2021-03-22
%%
%% ---------------------------
%% Notes: - bipo_labels (cell array), N_{bipolar channels} x 2
%%   
%%
%% ---------------------------

%% main function
  b1_mni = cell2mat(cellfun(@(x) label2mni(x, mono_labels, mono_mni), bipo_labels(:,1), 'UniformOutput', 0));
  b2_mni = cell2mat(cellfun(@(x) label2mni(x, mono_labels, mono_mni), bipo_labels(:,2), 'UniformOutput', 0));
  bipo_mni = (b1_mni + b2_mni)/2;
%% ---------------------------
end

%% sub-functions
% label to MNI (monopolar)
function mni=label2mni(label, mono_labels, mono_mni)
  ilabel = cell2mat(cellfun(@(x) strcmp(x, label), mono_labels, 'UniformOutput', 0));
  mni = mono_mni(ilabel, :);  % x y z
end
%% ---------------------------