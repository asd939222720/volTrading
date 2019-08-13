function myTenderStrategy(input)
%% My Tender Trading Strategy
% Simple but illustrative example% extract the inormation in the tender
% offer when a change is detected.  Input is a |rotmanTrader| object.
%
%   Example:
%   rit = rotmanTrader;
%   subscribe(rit,{'CRZY|BID';'CRZY|ASK';'TAME|BID';'TAME|ASK'})
%   fcn = @(input) myTenderStrategy(fcn);
%   addUpdateFcn(rit,fcn)

% Copyright 2018 The MathWorks, Inc.

if ~isempty(input.tenderinfo_1)
    % we have an offer, parse it and get the quantity/price info
    str = input.tenderinfo_1;
    data = strsplit(str,',');
    T = table;
    T.TenderID = str2num(data{1});
    T.Ticker = data{2};
    T.Quantity = str2num(data{3});
    T.Price = str2num(data{4});
    T.ReceivedTick = str2num(data{5});
    T.ExpiryTick = str2num(data{6});
    
    bidVar = lower([T.Ticker,'_bid']);
    askVar = lower([T.Ticker,'_ask']);
    action = 'none';
    
    if T.Quantity > 0 % Long tender
        % accept the tender offer if the price is at or above the bid
        if T.Price >= input.(bidVar)
            tf = acceptActiveTender(input,T.TenderID,input.(bidVar));
            if tf
                action = 'Accepted';
            else
                action = 'Rejected';
            end
        else % reject it
            tf = declineActiveTender(input,T.TenderID);
            action = 'Declined';
        end
    else % Short tender
        % accept the tender offer if the price is at or above the ask
        if T.Price >= input.(askVar)
            tf = acceptActiveTender(input,T.TenderID,input.(askVar));
            if tf
                action = 'Accepted';
            else
                action = 'Rejected';
            end
        else % reject it
            tf = declineActiveTender(input,T.TenderID);
            action = 'Declined';
        end
    end
    
    % Print out information to command window to know we've had a tender
    % offer and took action
    fprintf('TENDER OFFER Received for %d shares of %s at price of %3.2f\n',...
            T.Quantity,T.Ticker,T.Price)
    fprintf('%s is trading with bid of %3.2f and ask of %3.2f\n',...
        T.Ticker,input.(bidVar),input.(askVar));
    fprintf('ACTION TAKEN: %s tender offer\n\n',action);
end