
% =================================================================================================================================
% ALGORITHM FOR EVOLVING A SOCIO-ECONOMIC SPACE WITH EGALITARIAN TRADE AND ALLOWING FOR AGENTS TO MAKE MULTIPLE RELATIONSHIPS
% =================================================================================================================================

clear
clc

% ========
% SET UP
% ========


N = 100;							% Number of agents
k = 1;								% Learning effect of good Y
m = 2;								% Learning effect of good X
b = 0;								% Cost base to j
c = 0;								% Cost base to i
R = [1,2,3,4];						% Specialisations
I = [m, 0; 0, k; 0.25, 0.25];		% Income



% ===================
% UPDATABLE CONTENT
% ===================

% Consumption of agents (update)

C = [0,k];
C(N,2) = 0;

% Specialisations of agents (update)

S = [0,2];
S(N,2) = 0;

for i = 1:N
	S(i,1) = i;
end

% Utilities (update)

U(N,2) = 0;

for i = 1:N
	U(i,1) = i;
end

% The network (update)

g = [0,0];



% ===================
% TRADING ALGORITHM
% ===================

for i = 2:N 						% New agents are entering the socio-economic space
	
	Csx(N+1,size(R,2)) = 0;
	Csy(N+1,size(R,2)) = 0;

	% Replicate the utility matrix

	for l = 1:size(R,2)
		Us(:,l) = [U(:,2);l];
	end

	% Replicate the consumption matrix

	for l = 1:size(R,2)
		Csx(:,l) = [C(:,1);l];
	end

	for l = 1:size(R,2)
		Csy(:,l) = [C(:,2);l];
	end

	X = zeros(size(R,2),N);			% Set the connection history to 0

		for s = 1:size(R,2)-1

			T = 0;
			B = 0;

			% FIRST TRADE
			% Calculating the first trade with a given specialisation

			for j = 1:i-1

				T(1,j) = (C(j,1) + I(s,1)) * 0.5;
				T(2,j) = (C(j,1) + I(s,1)) * 0.5;
				T(3,j) = (C(j,2) + I(s,2)) * 0.5;
				T(4,j) = (C(j,2) + I(s,2)) * 0.5;
				T(5,j) = (T(1,j) + 1) * (T(3,j) + 1) - c;

				% i can only connect to j if it is benefical for j
				% If not then j will not accept to i

				if (T(2,j) + 1) * (T(4,j) + 1) - b < Us(j,s);
					T(5,j) = 0;
					T(6,j) = 0;
				else T(6,j) = (T(2,j) + 1) * (T(4,j) + 1)  - b;
				end

				T(7,j) = j;
			end
	
			% Figure out what trade is best initial trade for i
			% Compare utilities from all accepting j's

			V = sortrows(T.',5).';
			V = fliplr(V);

			B = V(:,1);

	 		for j = 1:size(V,2)-1

				if V(5,j) == V(5,j+1)
					B = V(:,j+1);
				else break
				end

			end
	
			% Preliminary update of UPDATABLE CONTENT

			if	B(5,1) > 0
				Csx(B(7,1),s) = B(2,1); 	 				% Update j's consumption of x
				Csy(B(7,1),s) = B(4,1); 	 				% Update j's consumption of y

				Csx(i,s) = B(1,1);		 					% Update i's consumption of x
				Csy(i,s) = B(3,1);							% Update i's consumption of y
			
				Us(i,s) = B(5,1);							% Update i's utility
				Us(B(7,1),s) = B(6,1);						% Update j's utility

				% Record that i has connected to j

				X(s,B(7,1)) = B(7,1);

			end

			% SUBSEQUENT TRADES
			% Connect to some more j

			for x = 1:i-1

				L = 0;
				B = 0;

				for j = 1:i-1

					L(1,j) = (Csx(j,s) + Csx(i,s)) * 0.5;
					L(2,j) = (Csx(j,s) + Csx(i,s)) * 0.5;
					L(3,j) = (Csy(j,s) + Csy(i,s)) * 0.5;
					L(4,j) = (Csy(j,s) + Csy(i,s)) * 0.5;
					L(5,j) = (L(1,j) + 1) * (L(3,j) + 1) - c;

					if (L(2,j) + 1) * (L(4,j) + 1) + b < Us(j,s);
						L(5,j) = 0;
						L(6,j) = 0;
					else L(6,j) = (L(2,j) + 1) * (L(4,j) + 1) - b;
					end

					L(7,j) = j;

					% If i has already connected to j then negate the trade relationship

					if any(j==X(s,:))
						L(:,j) = 0;
					end

					% Out of these, figure out which one i should trade with

					P = sortrows(L.',5).';
					P = fliplr(P);

					B = P(:,1);

	 				for j = 1:size(P,2)-1
						if P(5,j) == P(5,j+1)
							B = P(:,j+1);
						else break
						end
					end
		
					% Update all that shit

					if	B(5,1) > Us(i,s)
						Csx(B(7,1),s) = B(2,1); 	 				% Update j's consumption of x
						Csy(B(7,1),s) = B(4,1); 	 				% Update j's consumption of y

						Csx(i,s) = B(1,1);		 					% Update i's consumption of x
						Csy(i,s) = B(3,1);							% Update i's consumption of y
					
						Us(i,s) = B(5,1);							% Update i's utility
						Us(B(7,1),s) = B(6,1);						% Update j's utility

						% Record that i has connected to j

						X(s,B(7,1)) = B(7,1);

					end
				end
			end
		end

	% Consider the case for autarky

	Us(i,4) = (I(3,1) + 1) * (I(3,2) + 1);
	Csx(i,4) = I(3,1);
	Csy(i,4) = I(3,2);
	X(4,1) = i;

	% Compare total utilities across different specialisations

	Us = sortrows(Us.',i).';
	Us = fliplr(Us);

	% Update specialisation

	S(i,2) = Us(N+1,1);

	% Update consumption

	Csx(N+1,:) = [];
	Csy(N+1,:) = [];

	C(:,1) = Csx(:,Us(N+1,1));
	C(:,2) = Csy(:,Us(N+1,1));

	% Update utility

	for l = 1:i
		U(l,2) = Us(l,1);
	end

	% Construct the network

	RR = X(Us(N+1,1),:);
	RR(RR==0) = [];

	for l = 1:size(RR,2)
		g(size(g,1)+1,:) = [i,RR(1,l)];
	end

end




% ===================
% GIVE ME RESULTS
% ===================

g

S

U

C
