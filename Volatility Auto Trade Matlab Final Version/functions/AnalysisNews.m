function newsInfo = AnalysisNews(news,newsInfo)
%ANALYSISNEWS Summary of this function goes here
%   Detailed explanation goes here

    if nargin < 2 || isempty(newsInfo)
        volatilityInfo = table((1:4)',nan(4,1),nan(4,2),'VariableNames',{'week', 'realizedVolatility', 'expectedVolatility'});
        newsInfo.volatility = volatilityInfo;
        newsInfo.volatilityTick = volatilityInfo;
        newsInfo.interestRate = nan;
        newsInfo.interestRateTick = nan;
        newsInfo.deltaLimit = nan;
        newsInfo.deltaLimitTick = nan;
        newsInfo.lastNewsIndex = 0;
    end
    
    volatilityInfo = newsInfo.volatility;
    volatilityInfoTick = newsInfo.volatilityTick;

    newsDetail(length(news),1) = struct('period',[],'tick',[],'week',[],'headLine',[],'content',[]);
    for i = 1:length(news)
        info = split(news{i},',');
        newsDetail(i).period = str2double(info{1});
        newsDetail(i).tick = str2double(info{2});
        newsDetail(i).week = info{3};
        newsDetail(i).headLine = info{4};
        newsDetail(i).content = horzcat(info{5:end});
    end
    
    for i = 1:length(newsDetail)
        
        % First realized vol news
        if strfind(newsDetail(i).headLine,'annualized volatility')
            weekIndex = 1;
            realizedVol = regexpi(newsDetail(i).content,'(?<=annualized volatility\D*)\d*(?=%)','match');
            if ~isempty(realizedVol)
                realizedVol = str2double(realizedVol{1}) / 100;
                if isnan(volatilityInfo.realizedVolatility(weekIndex))
                    volatilityInfo.realizedVolatility(weekIndex) = realizedVol;
                    volatilityInfoTick.realizedVolatility(weekIndex) = newsDetail(i).tick;
                end
            end
        end
        
        % Risk free rate
        if contains(lower(newsDetail(i).headLine),'free rate')
            interestRate = regexpi(newsDetail(i).content,'(?<=free rate\D*)\d*(?=%)','match');
            if ~isempty(interestRate)
                interestRate = str2double(interestRate{1});
                newsInfo.interestRate = interestRate;
                newsInfo.interestRateTick = newsDetail(i).tick;
            end
        end
        
        % delta limit
        if contains(lower(newsDetail(i).headLine),'delta limit')
            deltaLimit = regexpi(newsDetail(i).content,'(?<=delta limit\D*)[\d,]*','match');
            if ~isempty(deltaLimit)
                deltaLimit = str2double(deltaLimit{1});
                newsInfo.deltaLimit = deltaLimit;
                newsInfo.deltaLimitTick = newsDetail(i).tick;
            end
        end
        
        
        % Subsequent realized vol news
        if strfind(newsDetail(i).headLine,'Announcement')
            weekIndex = regexpi(newsDetail(i).week, '\d*','match');
            realizedVol = regexpi(newsDetail(i).content,'(?<=annualized volatility\D*)\d*(?=%)','match');
            if ~isempty(weekIndex) && ~isempty(realizedVol)
                weekIndex = str2double(weekIndex{1});
                realizedVol = str2double(realizedVol{1}) / 100;
                if isnan(volatilityInfo.realizedVolatility(weekIndex))
                    volatilityInfo.realizedVolatility(weekIndex) = realizedVol;
                    volatilityInfoTick.realizedVolatility(weekIndex) = newsDetail(i).tick;
                end
            end            
        end
        
        % Expeted vol
        if strfind(newsDetail(i).headLine,'News')
            weekIndex = regexpi(newsDetail(i).content, '(?<=Week )\d*','match');
            expetedVol = regexpi(newsDetail(i).content, '\d*(?=%)','match');
            if ~isempty(weekIndex) && length(expetedVol) >= 2
                weekIndex = str2double(weekIndex{1});
                lowerLimit = str2double(expetedVol{1}) / 100;
                upperLimit = str2double(expetedVol{2}) / 100;
                if isnan(volatilityInfo.realizedVolatility(weekIndex))
                    volatilityInfo.expectedVolatility(weekIndex,:) =[lowerLimit, upperLimit] ;
                    volatilityInfoTick.expectedVolatility(weekIndex,:) =[newsDetail(i).tick, newsDetail(i).tick] ;
                end
            end
        end
        
    end

    newsInfo.volatility = volatilityInfo;
    newsInfo.volatilityTick = volatilityInfoTick;
        
end

