function [c,ceq,GC,GCeq] = Constraints(x,P)

c_1 = x'*P.S*x - P.v;
c_2 = x'*P.T*x - P.q;

c=[c_1
   c_2];

ceq = [];

if nargout > 2   
   GC_1 = P.S*x; 
   GC_2 = P.T*x; 
   
   GC = [GC_1 GC_2];
   
   GCeq = []; 
end