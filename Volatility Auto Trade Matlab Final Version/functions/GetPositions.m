function positionInfo = GetPositions(rit, positionVarNames, tickerNames)

StockNetLimitTotal = 50000;
StockGrossLimitTotal = 50000;
OptionNetLimitTotal = 1000;
OptionGrossLimitTotal = 2500;

StockIndex = 1;
OptionIndex = 2:length(positionVarNames);


positionList = zeros(size(positionVarNames));
for i = 1 : length(positionVarNames)
    positionList(i) = rit.(positionVarNames{i});
end

StockNet = sum(positionList(StockIndex));
StockGross = sum(abs(positionList(StockIndex)));

OptionNet = sum(positionList(OptionIndex));
OptionGross = sum(abs(positionList(OptionIndex)));

Data = positionList;
t=table(Data,'RowNames',tickerNames);
positionInfo.Positions = t;
positionInfo.StockNet = StockNet;
positionInfo.StockGross = StockGross;
positionInfo.OptionNet = OptionNet;
positionInfo.OptionGross = OptionGross;

positionInfo.StockBuyLimit = StockNetLimitTotal - StockNet;
positionInfo.StockSellLimit = StockNetLimitTotal + StockNet;
positionInfo.OptionBuyLimit = min(OptionNetLimitTotal - OptionNet, OptionGrossLimitTotal - OptionGross);
positionInfo.OptionSellLimit = min(OptionNetLimitTotal + OptionNet, OptionGrossLimitTotal - OptionGross);

end

