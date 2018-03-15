% $Id: graphpaths.pl,v 1.3 2011-05-19 19:53:59-07 - - $ */

% Database
airport( atl, ’Atlanta ’, degmin( 33,39 ), degmin( 84,25 ) ).
airport( bos, ’Boston-Logan ’, degmin( 42,22 ), degmin( 71, 2 ) ).
airport( chi, ’Chicago ’, degmin( 42, 0 ), degmin( 87,53 ) ).
airport( den, ’Denver-Stapleton’, degmin( 39,45 ), degmin( 104,52 ) ).
airport( dfw, ’Dallas-Ft.Worth ’, degmin( 32,54 ), degmin( 97, 2 ) ).
airport( lax, ’Los Angeles ’, degmin( 33,56 ), degmin( 118,24 ) ).
airport( mia, ’Miami ’, degmin( 25,49 ), degmin( 80,17 ) ).
airport( nyc, ’New York City ’, degmin( 40,46 ), degmin( 73,59 ) ).
airport( sea, ’Seattle-Tacoma ’, degmin( 47,27 ), degmin( 122,18 ) ).
airport( sfo, ’San Francisco ’, degmin( 37,37 ), degmin( 122,23 ) ).
airport( sjc, ’San Jose ’, degmin( 37,22 ), degmin( 121,56 ) ).

flight( bos, nyc, time( 7,30 ) ).
flight( dfw, den, time( 8, 0 ) ).
flight( atl, lax, time( 8,30 ) ).
flight( chi, den, time( 8,30 ) ).
flight( mia, atl, time( 9, 0 ) ).

%
% Prolog version of not.
%

not( X ) :- X, !, fail.
not( _ ).

%
% Functions: use functions to return answers to math equations
% here we are getting degrees as fractions and radians in two formulas
% You can write a function to give you
%   hours as a fraction -> hours mins
%   hours and mins to hours as a fraction
%   flight time which is Time = Distance / Rate
%   haversine_radians (but you already have that function, good good)

% degrees, minutes to degrees
degmin_to_degrees( Deg, Min, Degrees ) :-
   Degrees is Deg + (Min/60).

% degrees to radians
degrees_to_radians( Degrees, Radians ) :-
   Pi is pi,
   Radians is ( Degrees * Pi ) / 180.

%
% distance_to_from, takes two airports and returns the distance between the two
%

distance_to_from( To, From, Distance ) :-
  % here we get the airport information that we need for calculations
  airport( To, _, degmin(LatD1,LatM1), degmin(LonD1,LonM1) ),
  airport( From, _, degmin(LatD2,LatM2), degmin(LonD2,LonM2) ),
  % here we will do a lot of math so that we can call the haversine formula

  % for example you can use a degmin_to_degrees function to get degrees in fractions
  degmin_to_degrees( LatD1, LatM1, LatDegs1),


  % finally once we have lat and lon of both airports in radians we can pass
  % the values in to the haversine formula and that returns Distance
  % which assigns the value Distance in distance_to_from( To, From, Distance )
  % and then we have our distance in the listpath function
  haversine_radians( LatRads1, LonRads1, LatRads2, LonRads2, Distance ).



%
% Find a path from one node to another.
%

writeallpaths( Node, Node ) :-
   write( Node ), write( ' is ' ), write( Node ), nl.
writeallpaths( Node, Next ) :-
   listpath( Node, Next, [Node], List ),
   write( Node ), write( ' to ' ), write( Next ), write( ' is ' ),
   writepath( List ),
   fail.

% Modify this after you get listpaths working

writepath( [] ) :-
   nl.
writepath( [Head|Tail] ) :-
   write( ' ' ), write( Head ), writepath( Tail ).

% This listpath probably wont ever me called

listpath( Node, End, Outlist ) :-
   listpath( Node, End, [Node], Outlist ).

% This is where you should do the work to see
% if the flight time and departure time work out

% add arguments to the listpath function to keep track of time
% right now listpath only keeps track of where we have reached
% but time is a factor and it starts at 0
listpath( Node, Node, _, [Node] ).
listpath( Node, End, Tried, [Node|List] ) :-

   % We change link to flight, since our airports are linked with flights
   % link( Node, Next ),
   flight( Node, Next ),

   % Here we check if the airport is in our database
   % If the airports 'Node' or 'Next' are not in the database
   % The line will evaluate to false and prolog will run through the function
   % again with a new line from the database
   airport( Node, _, _, _),
   airport( Next, _, _, _),
   % the underscores mean we dont care about the values in those slots

   % now we want to find the distance from two airports
   % so write a function that takes in two airports and returns Distance
   distance_to_from( Node, Next, Distance),
   % notice that Distance is a new variable name and will be given a value
   % after the distance function is finished

   % now that we have the distance between two airports we can see how long the
   % flight is. We know D = R * T but since we want T we do T = D / R to find airtime
   % the rate is 500 i think and we just found the Distance. So we can get T


   not( member( Next, Tried )),
   listpath( Next, End, [Next|Tried], List ).


% TEST: writeallpaths(a,e).
% TEST: writeallpaths(a,j).
