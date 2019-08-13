function priceTable = ComparePrices(LastPrices,tick, tickerNames,newsInfo)

transactionCost = 0.00;

N = length(LastPrices);

MarketPrice = LastPrices;
FairPriceNow = nan(N,1);
FairPriceLow = nan(N,1);
FairPriceHigh = nan(N,1);
OverValuedDiff = nan(N,1);
UnderValuedDiff = nan(N,1);
OverValuedRatio = nan(N,1);
UnderValuedRatio = nan(N,1);
AverageFairValue = nan(N,1);
DiffFromAverage = nan(N,1);

for i = 1:N
    ticker = tickerNames{i};
    tickerInfo = parseTickerName(ticker);
    if strcmp(tickerInfo.type, 'Stock')
        stockPrice = LastPrices(i);
        break;
    end
end

for i = 1:N
    [p_n, p_l, p_h] = FairOptionPrice(stockPrice,tickerNames{i},newsInfo,tick);
    FairPriceNow(i) = p_n;
    FairPriceLow(i) = p_l;
    FairPriceHigh(i) = p_h;
    if isnan(p_l)
        OverValuedDiff(i) = max(0, MarketPrice(i) - FairPriceNow(i) - transactionCost);
    else
        OverValuedDiff(i) = max(0, MarketPrice(i) - FairPriceHigh(i) - transactionCost);
    end
    OverValuedRatio(i) = OverValuedDiff(i)/MarketPrice(i);
    
    
    if isnan(p_h)
        UnderValuedDiff(i) = max(0, FairPriceNow(i) - MarketPrice(i) - transactionCost);
    else
        UnderValuedDiff(i) = max(0, FairPriceLow(i) - MarketPrice(i) - transactionCost);
    end
    UnderValuedRatio(i) = UnderValuedDiff(i)/MarketPrice(i);
end

for i = 1:N
    if isnan(FairPriceLow(i))
        AverageFairValue(i) = FairPriceNow(i);
    else
        AverageFairValue(i) = (FairPriceLow(i)+FairPriceHigh(i))/2;
    end
    DiffFromAverage(i) = MarketPrice(i) - AverageFairValue(i);
end

priceTable = table(MarketPrice, FairPriceNow, FairPriceLow, FairPriceHigh, OverValuedDiff, OverValuedRatio, UnderValuedDiff, UnderValuedRatio,AverageFairValue,DiffFromAverage,'RowNames',tickerNames);

% disp(['Market Price -- RTM50C: ' num2str(MarketPrice(12)) ' RTM50P: ' num2str(MarketPrice(13))]);
% disp(['Fair Price -- RTM50C: ' num2str(FairPriceNow(12)) ' RTM50P: ' num2str(FairPriceNow(13))]);
% disp(max(abs(MarketPrice - FairPriceNow)));
% if abs( MarketPrice(13) - FairPriceNow(13) ) > 0.03
%     disp('!!!');
% end


end

