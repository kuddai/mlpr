A = [1 2 3; 0 0 15; 1 1 1] ;
mean(A, 2)
C = bsxfun(@minus, A, mean(A, 2))
abs(C)
