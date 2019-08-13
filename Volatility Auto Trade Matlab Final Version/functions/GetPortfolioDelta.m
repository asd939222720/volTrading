function totalDelta = GetPortfolioDelta(positions, priceTable,newsInfo, tick)

rate = 0;
vol = RealizedVolatility(newsInfo,tick);
Tenor = (600 - tick)/7200;

indexes = positions.Data~=0;

totalDelta = positions.Data('RTM')/100;

indexes(1) = 0;
openPositions = positions(indexes,:);

for i = 1:length(openPositions.Data)
    ticker = openPositions.Properties.RowNames{i};
    optionInfo = parseTickerName(ticker);
    delta = 0;
    [c,p] = blsdelta(priceTable.MarketPrice('RTM'),optionInfo.strike,rate,Tenor,vol);
    if optionInfo.callOrPut == 'C'
        delta = c;
    elseif optionInfo.callOrPut == 'P'
        delta = p;
    end
    totalDelta = totalDelta + delta * openPositions.Data(i);
end
totalDelta = totalDelta * 100;
display(['Total delta: ' num2str(totalDelta)]);

end

