function [fProbability_] = callback_LogLikelihoodA1A2BValue(vValues, caCatalogs, mControl)
% function [fProbability] = callback_LogLikelihoodABValue(vValues, caCatalogs, mControl)
% --------------------------------------------------------------------------------------
% Helper callback-function for calc_MaxLikelihoodAB.m
%   Computes the negative log-likelihood sum of a given a- and b-value for a
%   set of given catalogs
%
% Input parameters:
%   vValues         Vector with a- and b-value (vValues(1) =a-value, vValues(2) = b-value)
%   caCatalogs      Cell array containing the set of catalogs
%   mControl        Controlmatrix containing informations about the single catalogs
%                   mControl(n,:) contains information about caCatalogs{n}
%                   Column 1: Starting time of catalog
%                   Column 2: Magnitude of completeness
%                   Column 3: Starting magnitude bin
%                   Column 4: Magnitude bin stepsize (must be 0.1)
%
% Output parameters:
%   fProbability    Negative log-likelihood of the given a- and b-value for the set of given catalogs
%
% Danijel Schorlemmer
% July 5, 2002

global fProbability
% Init variable
vProbabilities = [];

[nRow_, nColumn_] = size(mControl);
fTotalLength_ = mControl(nRow_,6)-mControl(1,1);


% Loop over all catalogs
for nCnt_ = 1:length(caCatalogs)
  % Extract catalog from cell array
  mCatalog_ = caCatalogs{nCnt_};
  if length(mCatalog_(:,1)) > 0;
  % Determine maximum magnitude of catalog
  fMaxMag_ = max(mCatalog_(:,6));
  % Set up vector of available magnitude bins
  vCnt_ = (mControl(nCnt_,2):mControl(nCnt_,4):(fMaxMag_+mControl(nCnt_,4)))'; % Add one more magnitude bin for later use of diff()
  % Compute lengths of periods and ajust thea-value
  if mControl(nCnt_,5) == 1;  % this is activity rate 1

      fTimeLength_ = mControl(nCnt_,6) - mControl(nCnt_,1);
      fTimeRatio_ = fTimeLength_/fTotalLength_;
      fA_ = vValues(1) + log10(fTimeRatio_);
      % Compute the cumulative FMD
      vNumber_ = 10.^(fA_ - (vValues(2) * vCnt_));

  elseif  mControl(nCnt_,5) == 2;  % this is activity rate 1
      fTimeLength_ = mControl(nCnt_,6) - mControl(nCnt_,1);
      fTimeRatio_ = fTimeLength_/fTotalLength_;
      fA_ = vValues(3) + log10(fTimeRatio_);
      % Compute the cumulative FMD
      vNumber_ = 10.^(fA_ - (vValues(2) * vCnt_));
  end

  % Determine the number of events in each magnitude bin
  mPredictionFMD_ = -diff(vNumber_);
  % Create the FMD for the period of observation
  vObservedFMD_ = histogram(mCatalog_(:,6), mControl(nCnt_,2):mControl(nCnt_,4):fMaxMag_);
  % Calculate the likelihoods for both of the models
  vProb_ = calc_log10poisspdf(vObservedFMD_', mPredictionFMD_);
  % Return the values (multiply by -1 to return the lowest value for the highest probability
  vProbabilities = [vProbabilities; sum(vProb_)];
end
end
% Sum the probabilities for all given catalogs
fProbability_ = (-1) * sum(vProbabilities);
fProbability = fProbability_;
