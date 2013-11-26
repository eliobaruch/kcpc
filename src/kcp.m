%% 
% Author: Srivaths R
% As part of our submission to the "Karnataka Crime Prediction Competition" on Kaggle
% This script loads the features vectors for each crime, trains them and 
% predicts the crime values for the test data.
%%
close all;
clear;

addpath('../lib/gpml-matlab-v3.3-2013-10-19/');
startup; % to run the code required to set GPML paths [required by GPML].

%loading the training and test data
f=cell(1,10);
t=cell(1,10);

f{1}=load('../feature_vectors/feats_1.csv');
t{1}=load('../feature_vectors/feats_1_test.csv');

f{2}=load('../feature_vectors/feats_2.csv');
t{2}=load('../feature_vectors/feats_2_test.csv');

f{3}=load('../feature_vectors/feats_3.csv');
t{3}=load('../feature_vectors/feats_3_test.csv');

f{4}=load('../feature_vectors/feats_4.csv');
t{4}=load('../feature_vectors/feats_4_test.csv');

f{5}=load('../feature_vectors/feats_5.csv');
t{5}=load('../feature_vectors/feats_5_test.csv');

f{6}=load('../feature_vectors/feats_6.csv');
t{6}=load('../feature_vectors/feats_6_test.csv');

f{7}=load('../feature_vectors/feats_7.csv');
t{7}=load('../feature_vectors/feats_7_test.csv');

f{8}=load('../feature_vectors/feats_8.csv');
t{8}=load('../feature_vectors/feats_8_test.csv');

f{9}=load('../feature_vectors/feats_9.csv');
t{9}=load('../feature_vectors/feats_9_test.csv');

f{10}=load('../feature_vectors/feats_10.csv');
t{10}=load('../feature_vectors/feats_10_test.csv');

no_crimes=10; %number of crimes
averages=(1:10);
pred=(1:100)'; %matrix to hold the predicted output

%% 
%training a seperate model for each crime based on the training data files and predicting on the test data
for i=1:no_crimes,
    
    X=f{i}(:,1:end-1);  %training datapoints of the ~20 districts
    Y=f{i}(:,end);      %crime values for the training data
    X1=t{i}(:,1:end-1); %test datapoints to predic on
    
    averages(i)=mean(Y);
    %preprocessing: removing all attributes ehich are only 0's for all the
    %input data points
    a=[find(sum(X)==0)];
    X(:,a)=[];
    X1(:,a)=[];
    
    %scaling the training and test data 
    [temp, scale_pars] = scaledata(X');
    X=temp';
    [temp,~]=scaledata(X1',scale_pars);
    X1=temp';
    
    %Code for training and predicting using Gaussian process models
    covfunc='covSEiso';
    likfunc = @likGauss; 
    hyp2.cov = [5; 10];        
    hyp2.lik = log(0.1);
    hyp2 = minimize(hyp2, @gp, -100, @infExact, [], covfunc, likfunc, X, Y);
    [p s2] = gp(hyp2, @infExact, [], covfunc, likfunc, X, Y, X1);
        
    %adding the predicted output on the test data in the right positions
    %according to id_map
    for j=1:size(X1,1),
        pred(t{i}(j,end),1)=p(j);
    end
    
end
%%
% 
fid=fopen('../outputs/output.txt','w');
fprintf(fid,'id,Crime Measure (Target)\n');

%ouput the predictions
for i=1:size(pred,1),
    p=pred(i,1);    
    %if prediction is less than 0, then print the average of all the districts
    %for that crime.
    if p<=0,
          p=averages(mod(i-1,10)+1);
    end
    fprintf(fid,'%d,%f\n',i-1,p);
end

fclose(fid);