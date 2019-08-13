function instInfo = parseTickerName(tickerName)

instInfo.name = tickerName;

strikePrice = regexpi(tickerName,'\d*','match');
if isempty(strikePrice)    
    instInfo.type = 'Stock';
    return;
end

instInfo.type = 'Option';
instInfo.strike = str2double(strikePrice);
callOrPut = regexpi(tickerName,'(?<=\d+)[CP]','match');
if isempty(callOrPut)
    error(['Can not parse ticker name: ' tickerName]);
end
instInfo.callOrPut = callOrPut{1};

end

