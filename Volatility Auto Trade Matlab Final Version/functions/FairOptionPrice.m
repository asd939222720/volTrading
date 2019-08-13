function [price_CurrentVol,price_LowerVol, price_UpperVol] = FairOptionPrice(stockPrice,optionName,newsInfo,tick)

timePeriod = 600;
ticksInOneWeek = 150;
ticksInOneYear = 7200;

optionInfo = parseTickerName(optionName);

if strcmp(optionInfo.type, 'Stock')
    price_CurrentVol = NaN;
    price_LowerVol = NaN;
    price_UpperVol = NaN;
    return;
end

K = optionInfo.strike;
CorP = optionInfo.callOrPut;

N = length(stockPrice);
price_CurrentVol = nan(N,1);
price_LowerVol = nan(N,1);
price_UpperVol = nan(N,1);

for i = 1:N
    S = stockPrice(i);
    r = newsInfo(i).interestRate;
    T = timePeriod - tick(i);
    week = ceil(tick(i)/ticksInOneWeek);
    Vol_C = newsInfo(i).volatility.realizedVolatility(week) / sqrt(ticksInOneYear);
    if week < 4 && week > 0
        Vol_L = newsInfo(i).volatility.expectedVolatility(week + 1, 1) / sqrt(ticksInOneYear);
        Vol_U = newsInfo(i).volatility.expectedVolatility(week + 1, 2) / sqrt(ticksInOneYear);
    else
        Vol_L = NaN;
        Vol_U = NaN;
    end
    
    if ~isnan(Vol_C)
        if upper(CorP) == 'C'
            price_CurrentVol(i) = blsprice(S,K,r,T,Vol_C);
        elseif upper(CorP) == 'P'
            [~,price_CurrentVol(i)] = blsprice(S,K,r,T,Vol_C);
        end
    end
    if ~isnan(Vol_C) && ~isnan(Vol_L) && ~isnan(Vol_U)
        if upper(CorP) == 'C'
            price_LowerVol(i) = blsprice_piecewise(S,K,r,timePeriod,[tick(i), week * ticksInOneWeek + 1],[Vol_C, Vol_L]);
            price_UpperVol(i) = blsprice_piecewise(S,K,r,timePeriod,[tick(i), week * ticksInOneWeek + 1],[Vol_C, Vol_U]);
        elseif upper(CorP) == 'P'
            [~, price_LowerVol(i)] = blsprice_piecewise(S,K,r,timePeriod,[tick(i), week * ticksInOneWeek + 1],[Vol_C, Vol_L]);
            [~, price_UpperVol(i)] = blsprice_piecewise(S,K,r,timePeriod,[tick(i), week * ticksInOneWeek + 1],[Vol_C, Vol_U]);
        end
    end
end

