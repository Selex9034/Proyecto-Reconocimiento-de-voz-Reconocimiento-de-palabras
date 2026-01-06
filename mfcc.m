function c = mfcc(s, fs)
% MFCC Calculate the mel frequencey cepstrum coefficients (MFCC) of a signal
%
% Inputs:
%       s       : speech signal
%       fs      : sample rate in Hz
%
% Outputs:
%       c       : MFCC output, each column contains the MFCC's for one speech frame

N = 256;                        % frame size
M = 100;                        % inter frame distance
len = length(s);
numberOfFrames = 1 + floor((len - N)/double(M));
mat = zeros(N, numberOfFrames); % vector of frame vectors

for i=1:numberOfFrames
    index = 100*(i-1) + 1;
    for j=1:N
        mat(j,i) = s(index);
        index = index + 1;
    end
end

hamW = 0.54 - 0.46 * cos(2 * pi * (0:N-1)' / (N-1));             % hamming window
afterWinMat = diag(hamW)*mat;   
freqDomMat = fft(afterWinMat);  % FFT into freq domain

filterBankMat = melFilterBank(20, N, fs);                % matrix for a mel-spaced filterbank
nby2 = 1 + floor(N/2);
ms = filterBankMat*abs(freqDomMat(1:nby2,:)).^2; % mel spectrum
inputVal = log(ms + eps);
    [nFilters, nFrames] = size(inputVal);
    dctMat = zeros(nFilters, nFilters);
    
    for k = 0:nFilters-1
        if k == 0
            w = sqrt(1/nFilters);
        else
            w = sqrt(2/nFilters);
        end
        for n = 0:nFilters-1
            dctMat(k+1, n+1) = w * cos(pi * k * (2*n + 1) / (2*nFilters));
        end
    end
    c = dctMat * inputVal;
c(1,:) = [];                                     % exclude 0'th order cepstral coefficient