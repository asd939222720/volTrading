function isValid = IsValidPairOption(priceTable)

tickers = priceTable.Properties.RowNames;
isValid(1:length(tickers),1) = true;
isValid(1) = false;
stockPrice = priceTable.MarketPrice(1);
for i = 2 :length(tickers)
    tickerInfo = parseTickerName(tickers{i});
    if abs(tickerInfo.strike - stockPrice) >= 3
        isValid(i) = false;
    end
end


end

