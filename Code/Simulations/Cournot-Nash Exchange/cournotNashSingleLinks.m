clear
clc

% In this code we simulate the evolution of a socio-economic space with two socio-economic roles whereby all individual agents have the following Stone-Geary utility function : U = (x+1)(y+2)
% In this simulation a new agent enters the socio-economic space, specialises in a socio-economic role, attains an income, and makes a single link to another agent as a trading partner.
% The decision as to what role to specialise into is fully rationalised in that agents maximise their utility which is dependent on their trading partner.

syms p

format long

N  = 100;				% Number of agents
R  = [1,2];				% Specialisations
I  = [10, 0; 0, 20*p];	% Income

% Consumption of agents (update)
C = [10,0];				% Agent 1 always specialises as role 1 first
C(N,2) = 0;

% Specialisations of agents (update)
S = [0,1];
S(N,2) = 0;
for i = 1:N
	S(i,1) = i;
end

% Utilities (update)
U(N,2) = 0;
for i = 1:N
	U(i,1) = i;
end

% Network (update)
g = [0,0];

% Trading algorithm
for i = 2:N
	T = 0;
	F = 0;
	for s = 1:size(R,2)
		for j = 1:i-1
			Dxi = 0.5*((I(s,1) + I(s,2)) + (2 * p) - 1);
			Dxj = 0.5*((C(j,1) + C(j,2)) + (2 * p) - 1);
			
			r = solve(Dxi + Dxj == C(j,1) + I(s,1), p);
			
			Ir = [10, 0; 0, 20*r];
			
			if s == 1
				T(1,j) = 0.5*((Ir(s,1) + Ir(s,2)) + (2 * r) - 1);
				T(2,j) = 0.5*((C(j,1) + C(j,2)) + (2 * r) - 1);
				T(3,j) = ((Ir(s,1) + Ir(s,2)) - (2 * r) + 1)/(2 * r);
				T(4,j) = ((C(j,1) + C(j,2)) - (2 * r) + 1)/(2 * r);
				T(5,j) = (T(1,j) + 1) * (T(3,j) + 2);
				T(6,j) = (T(2,j) + 1) * (T(4,j) + 2);
				T(7,j) = j;
				T(8,j) = s;
			end
			
			if s == 2
				F(1,j) = 0.5*((Ir(s,1) + Ir(s,2)) + (2 * r) - 1);
				F(2,j) = 0.5*((C(j,1) + C(j,2)) + (2 * r) - 1);
				F(3,j) = ((Ir(s,1) + Ir(s,2)) - (2 * r) + 1)/(2 * r);
				F(4,j) = ((C(j,1) + C(j,2)) - (2 * r) + 1)/(2 * r);
				F(5,j) = (F(1,j) + 1) * (F(3,j) + 2);
				F(6,j) = (F(2,j) + 1) * (F(4,j) + 2);
				F(7,j) = j;
				F(8,j) = s;
			end
		end
	end
	
	% Figure out what trade is best for this node
	
	T = double(T);
	F = double(F);
	TF = [T F];
	B = sortrows(TF.',5).';
	B = B(:,size(B,2));
	
	% Update all that shit
	
	C(B(7,1),1) = B(2,1); 	 				% Update j's consumption of x
	C(B(7,1),2) = B(4,1); 	 				% Update j's consumption of y
	C(i,1) = B(1,1);		 				% Update i's consumption of x
	C(i,2) = B(3,1);						% Update i's consumption of y
	
	S(i,2) = B(8,1);						% Update i's specialisation
	
	U(i,2) = U(i,2) + B(5,1);				% Update i's utility
	U(B(7,1),2) = U(B(7,1),2) + B(6,1);		% Update j's utility
	
	% Construct the network
	
	g(i,:) = [i,B(7,1)];
	
end

S
g
U
sum(C)