function [callPrice, putPrice, callVol, putVol] = blsprice_piecewise(stockPrice, strikePrice, rate, expireTime, timeList, sigmaList)
%BLSPRICE_PIECEWISE COMPUTE A EUROPEAN OPTION OF PIECEWISE VOLATILITY
%   Return the price and equivalent vol at timeList(1)
%   
%   Inputs:
%   timeList    - a vector of time. Result of the time in first element
%                 will be returned.
%   sigmaList   - a vector of sigma. It should have same length as
%                 timeList. sigmaList(i) represent volatility in
%                 [timeList(i),timeList(i+1)). Let timeList(end+1) be
%                 expireTime.

if length(timeList)~=length(sigmaList)
    error("timeList and sigmaList should have same length");
end

callPrice = 0;
putPrice = 0;

for i = 1 : length(sigmaList)-1
    [call0, put0] = blsprice(stockPrice, strikePrice, rate, expireTime - timeList(i), sigmaList(i)); 
    [call1, put1] = blsprice(stockPrice, strikePrice, rate, expireTime - timeList(i+1), sigmaList(i));
    callPrice = callPrice + call0 - call1;
    putPrice = putPrice + put0 - put1;
end
[callT, putT] = blsprice(stockPrice, strikePrice, rate, expireTime - timeList(end), sigmaList(end));
callPrice = callPrice + callT;
putPrice = putPrice + putT;


if nargout>2
    callVol = impliedVolatilityNewton(callPrice,stockPrice,strikePrice,rate,expireTime-timeList(1),'call');
end

if nargout>3
    putVol = impliedVolatilityNewton(putPrice,stockPrice,strikePrice,rate,expireTime-timeList(1),'put');
end
