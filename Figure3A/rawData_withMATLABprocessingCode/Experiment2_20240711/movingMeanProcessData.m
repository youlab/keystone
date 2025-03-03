% Emrah Simsek %

% now do the moving averages for the time series data

k = 4; 

time = movmean(time, k);

M(M<0) = 0;

BgNoCB = mean([M(2, 8, :); M(3, 8, :); M(4, 8, :)], 1);

BgCB10 = mean([M(5, 8, :); M(6, 8, :); M(6, 8, :)], 1);


B2 = M(2, 2, :) - BgNoCB; B2 = movmean(B2(:), k); B2(B2<0) = 0;

B3 = M(3, 2, :) - BgNoCB; B3 = movmean(B3(:), k); B3(B3<0) = 0;

B4 = M(4, 2, :) - BgNoCB; B4 = movmean(B4(:), k); B4(B4<0) = 0;

B5 = M(5, 2, :) - BgCB10; B5 = movmean(B5(:), k); B5(B5<0) = 0;

B6 = M(6, 2, :) - BgCB10; B6 = movmean(B6(:), k); B6(B6<0) = 0;

B7 = M(7, 2, :) - BgCB10; B7 = movmean(B7(:), k); B7(B7<0) = 0;


C2 = M(2, 3, :) - BgNoCB; C2 = movmean(C2(:), k); C2(C2<0) = 0;

C3 = M(3, 3, :) - BgNoCB; C3 = movmean(C3(:), k); C3(C3<0) = 0;

C4 = M(4, 3, :) - BgNoCB; C4 = movmean(C4(:), k); C4(C4<0) = 0;

C5 = M(5, 3, :) - BgCB10; C5 = movmean(C5(:), k); C5(C5<0) = 0;

C6 = M(6, 3, :) - BgCB10; C6 = movmean(C6(:), k); C6(C6<0) = 0;

C7 = M(7, 3, :) - BgCB10; C7 = movmean(C7(:), k); C7(C7<0) = 0;



D2 = M(2, 4, :) - BgNoCB; D2 = movmean(D2(:), k); D2(D2<0) = 0;

D3 = M(3, 4, :) - BgNoCB; D3 = movmean(D3(:), k); D3(D3<0) = 0;

D4 = M(4, 4, :) - BgNoCB; D4 = movmean(D4(:), k); D4(D4<0) = 0;

D5 = M(5, 4, :) - BgCB10; D5 = movmean(D5(:), k); D5(D5<0) = 0;

D6 = M(6, 4, :) - BgCB10; D6 = movmean(D6(:), k); D6(D6<0) = 0;

D7 = M(7, 4, :) - BgCB10; D7 = movmean(D7(:), k); D7(D7<0) = 0;


E2 = M(2, 5, :) - BgNoCB; E2 = movmean(E2(:), k); E2(E2<0) = 0;

E3 = M(3, 5, :) - BgNoCB; E3 = movmean(E3(:), k); E3(E3<0) = 0;

E4 = M(4, 5, :) - BgNoCB; E4 = movmean(E4(:), k); E4(E4<0) = 0;

E5 = M(5, 5, :) - BgCB10; E5 = movmean(E5(:), k); E5(E5<0) = 0;

E6 = M(6, 5, :) - BgCB10; E6 = movmean(E6(:), k); E6(E6<0) = 0;

E7 = M(7, 5, :) - BgCB10; E7 = movmean(E7(:), k); E7(E7<0) = 0;


F2 = M(2, 6, :) - BgNoCB; F2 = movmean(F2(:), k); F2(F2<0) = 0;

F3 = M(3, 6, :) - BgNoCB; F3 = movmean(F3(:), k); F3(F3<0) = 0;

F4 = M(4, 6, :) - BgNoCB; F4 = movmean(F4(:), k); F4(F4<0) = 0;

F5 = M(5, 6, :) - BgCB10; F5 = movmean(F5(:), k); F5(F5<0) = 0;

F6 = M(6, 6, :) - BgCB10; F6 = movmean(F6(:), k); F6(F6<0) = 0;

F7 = M(7, 6, :) - BgCB10; F7 = movmean(F7(:), k); F7(F7<0) = 0;


G2 = M(2, 7, :) - BgNoCB; G2 = movmean(G2(:), k); G2(G2<0) = 0;

G3 = M(3, 7, :) - BgNoCB; G3 = movmean(G3(:), k); G3(G3<0) = 0;

G4 = M(4, 7, :) - BgNoCB; G4 = movmean(G4(:), k); G4(G4<0) = 0;

G5 = M(5, 7, :) - BgCB10; G5 = movmean(G5(:), k); G5(G5<0) = 0;

G6 = M(6, 7, :) - BgCB10; G6 = movmean(G6(:), k); G6(G6<0) = 0;

G7 = M(7, 7, :) - BgCB10; G7 = movmean(G7(:), k); G7(G7<0) = 0;


H2 = M(2, 9, :) - BgNoCB; H2 = movmean(H2(:), k); H2(H2<0) = 0;

H3 = M(3, 9, :) - BgNoCB; H3 = movmean(H3(:), k); H3(H3<0) = 0;

H4 = M(4, 9, :) - BgNoCB; H4 = movmean(H4(:), k); H4(H4<0) = 0;

H5 = M(5, 9, :) - BgCB10; H5 = movmean(H5(:), k); H5(H5<0) = 0;

H6 = M(6, 9, :) - BgCB10; H6 = movmean(H6(:), k); H6(H6<0) = 0;

H7 = M(7, 9, :) - BgCB10; H7 = movmean(H7(:), k); H7(H7<0) = 0;


I2 = M(2, 10, :) - BgNoCB; I2 = movmean(I2(:), k); I2(I2<0) = 0;

I3 = M(3, 10, :) - BgNoCB; I3 = movmean(I3(:), k); I3(I3<0) = 0;

I4 = M(4, 10, :) - BgNoCB; I4 = movmean(I4(:), k); I4(I4<0) = 0;

I5 = M(5, 10, :) - BgCB10; I5 = movmean(I5(:), k); I5(I5<0) = 0;

I6 = M(6, 10, :) - BgCB10; I6 = movmean(I6(:), k); I6(I6<0) = 0;

I7 = M(7, 10, :) - BgCB10; I7 = movmean(I7(:), k); I7(I7<0) = 0;


J2 = M(2, 11, :) - BgNoCB; J2 = movmean(J2(:), k); J2(J2<0) = 0;

J3 = M(3, 11, :) - BgNoCB; J3 = movmean(J3(:), k); J3(J3<0) = 0;

J4 = M(4, 11, :) - BgNoCB; J4 = movmean(J4(:), k); J4(J4<0) = 0;

J5 = M(5, 11, :) - BgCB10; J5 = movmean(J5(:), k); J5(J5<0) = 0;

J6 = M(6, 11, :) - BgCB10; J6 = movmean(J6(:), k); J6(J6<0) = 0;

J7 = M(7, 11, :) - BgCB10; J7 = movmean(J7(:), k); J7(J7<0) = 0;
