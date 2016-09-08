clear
clc

N = 10;							% Number of agents
k = 6;								% Learning effect of good Y
m = 6;								% Learning effect of good X
b = 0;								% Cost base to j
c = 0;								% Cost base to i
R = [1,2,3];						% Specialisations
I = [m, 0; 0, k; 2, 2];				% Income

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

% Trading algorithm
for i = 2:N
	T = 0;
	F = 0;
	G = 0;
	A = 0;
	X = 0;
	for x = 1:i-1
		for s = 1:size(R,2)
			for j = 1:i-1
				
			if 	any(j==X)
				continue
			end

			if 	s == 1
				T(1,j) = (C(j,1) + I(s,1)) * 0.5;
				T(2,j) = (C(j,1) + I(s,1)) * 0.5;
				T(3,j) = (C(j,2) + I(s,2)) * 0.5;
				T(4,j) = (C(j,2) + I(s,2)) * 0.5;
				T(5,j) = (T(1,j) + 1) * (T(3,j) + 1);

				if (T(2,j) + 1) * (T(4,j) + 1) < U(j,2);
					T(5,j) = 0;
					T(6,j) = 0;
				else T(6,j) = (T(2,j) + 1) * (T(4,j) + 1);
				end

				T(7,j) = j;
				T(8,j) = s;
			end
			
			if 	s == 2
				F(1,j) = (C(j,1) + I(s,1)) * 0.5;
				F(2,j) = (C(j,1) + I(s,1)) * 0.5;
				F(3,j) = (C(j,2) + I(s,2)) * 0.5;
				F(4,j) = (C(j,2) + I(s,2)) * 0.5;
				F(5,j) = (F(1,j) + 1) * (F(3,j) + 1);
				
				if (F(2,j) + 1) * (F(4,j) + 1) < U(j,2);
					F(5,j) = 0;
					F(6,j) = 0;
				else F(6,j) = (F(2,j) + 1) * (F(4,j) + 1);
				end

				F(7,j) = j;
				F(8,j) = s;
			end
			
			if 	s == 3
				G(1,j) = (C(j,1) + I(s,1)) * 0.5;
				G(2,j) = (C(j,1) + I(s,1)) * 0.5;
				G(3,j) = (C(j,2) + I(s,2)) * 0.5;
				G(4,j) = (C(j,2) + I(s,2)) * 0.5;
				G(5,j) = (G(1,j) + 1) * (G(3,j) + 1);
				
				if (G(2,j) + 1) * (G(4,j) + 1) < U(j,2);
					G(5,j) = 0;
					G(6,j) = 0;
				else G(6,j) = (G(2,j) + 1) * (G(4,j) + 1);
				end

				G(7,j) = j;
				G(8,j) = s;
			end
			end
		
			if 	s == 3
				A(1,1) = 2;
				A(2,1) = 2;
				A(3,1) = 2;
				A(4,1) = 2;
				A(5,1) = (2 + 1) * (2 + 1);
				A(6,1) = 0;
				A(7,1) = i;
				A(8,1) = 4;
			end
		end
	
		% Figure out what trade is best for this node
	
		TFGA = [T F G A];

		for j = 1:size(TFGA,2)
			if 	TFGA(6,j) < 0
				TFGA(:,j) = 0;
			end
		end

		V = sortrows(TFGA.',5).';
		V = fliplr(V)

		B = V(:,1);

 		for j = 1:size(V,2)-1

			if V(5,j) == V(5,j+1)
				B = V(:,j+1);
			else break
			end

		end
	
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

		% Record that i has connected to j

		X(1,size(X,2)+1) = j;
	end
end

[S U(:,2)]

g(1,:) = []

sum(C) 