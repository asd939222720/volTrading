%% Accepting/Declining Tender Offers with Rotman Intractive Trader
% This example shows how to use the rotmanTrader functions to connect to
% and accept/decline tender offers through Rotman Interactive Trader (RIT).
% RIT must be installed on your computer along with the Excel(R) RTD Links.
% For more information visit http://rit.rotman.utoronto.ca/software.asp.
% This example also assumes that RIT is running Liability Trading 3 Case.

% Copyright 2018 The MathWorks, Inc.

%% Create a Connection
% First create a connection to Rotman Interactive Trader and list the
% functions (methods) available.
rit = rotmanTrader;
methods(rit)

%%
% To get more information on the functions, type help or doc and the name
% of the function.  For example:
help rotmanTrader
help rotmanTrader/subscribe
help rotmanTrader/getActiveTender
help rotmanTrader/getActiveTenderInfo
help rotmanTrader/AcceptActiveTender
help rotmanTrader/DeclineActiveTender

%% Get Active Tender and Info
% Wait for a tender offer and then retrieve the tender info.
haveTenderOffer = false;
while ~haveTenderOffer
    id = getActiveTenders(rit);
    if id ~= 0 % have offer so break out of loop
        haveTenderOffer = true;
    end
end
display(id)
%%
% Now get the tender info
tender = getActiveTenderInfo(rit,id)

%% Accept the Tender Offer
% Set a bid price at 90% of tender info price.  If this offer has a set
% bid, bid will be ignored, but an entry is still required
bid = tender.Price*0.9;
tf = acceptActiveTender(rit,id,bid)

%% Wait for Another Tender Offer
% We will wait for another tender, then decline the offer
% Wait for a tender offer and then retrieve the tender info.
haveTenderOffer = false;
while ~haveTenderOffer
    id = getActiveTenders(rit);
    if id ~= 0 % have offer so break out of loop
        haveTenderOffer = true;
    end
end
display(id)
%%
% Now get the tender info
tender = getActiveTenderInfo(rit,id)

%%
% and decline it
tf = declineActiveTender(rit,id)

%% Using |subscribe| for Tender Info
% You can also use the subscribe function to add the tender info to the rit
% object as a property.  You need to first know the tender ID.
haveTenderOffer = false;
while ~haveTenderOffer
    id = getActiveTenders(rit);
    if id ~= 0 % have offer so break out of loop
        haveTenderOffer = true;
    end
end
display(id)
%%
% Now subscribe to get the info for the tender offer.  Note that N in the
% subscription field always returns the current, if available, tender offer.
subscribe(rit,'TENDERINFO|1')
rit
%%
% show the info
rit.('tenderinfo_1')

%% Automating Tender Acceptance/Rejection
% To automate the response to a tender offer, create a function that
% responds to the tender offer event.  This follows examples from working
% with streaming data in |streamingDataExample|.
%
% tenderinfo is already available in rit, as tenderinfo_1, so we can use
% that property to trigger an action.
%
% Let's create a strategy to accept or reject the tender offer based on the
% current bid/ask price and the tender offer price.
%
% First let's subscribe to CRZY and TAME's bid/ask prices
subscribe(rit,{'CRZY|BID';'CRZY|ASK';'TAME|BID';'TAME|ASK'})

%% My Strategy
% Create a buy/sell tender offer strategy in |myTenderStrategy|.  The
% function is
type myTenderStrategy

%%
% What we created here was a function that will print to the command window
% the the action taken with each tender offer we receive. The input in this
% case is the |rotmanTrader| variable.  Let's add the cunction to
% |rotmanTrader| and watch it execute our strategy
subscribe(rit,{'CRZY|POSITION';'TAME|POSITION'})
fcn = @(input) myTenderStrategy(input);
%%
% Now add it to the list of updateFcns and it will be executed every time
% there is an update.
addUpdateFcn(rit,fcn)
rit

%%
% We will also manage our position by reversing any open positions in the
% market immediately
type myPositionManagementStrategy
%%
% Now add it to rit
fcn2 = @(input) myPositionManagementStrategy(input);
addUpdateFcn(rit,fcn2)
rit
%% Watch Strategy Run
% pause is used here to capture any offers before stopping.  Let's pause
% for the time remaining in this round and watch our strategy run.
pause(rit.timeRemaining)

%% Cleaning Up
% To properly clean up, you first need to delete the |rotmanTrader|
% connection before clearing it from the workspace.  This stops the updates
% and disconnect from Rotman Interactive Trader.
delete(rit)
clear rit
%%
% We now no longer have a connection.