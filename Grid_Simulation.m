function mpc = Grid_Simulation

define_constants;
%   $Id: case9.m,v 1.7 2007/09/17 16:07:48 ray Exp $ (/ 225 400.0) (/ 1 1.1)

mpc.version = '2';

%%-----  Power Flow Data  -----%% (/ 400 225.0)
%% system MVA base
mpc.baseMVA = 100; %correspond à Sb=100Mva



%% bus data type 2=gene 1=charge 3=bilan
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = [
	        1	3	0	0	0	0	1	1	0	400	1	1.1	0.7;%noeud 1 de référence=type3      
	        2	1	10	40	0	0	1	1	0	225	2	1.1	0.7;%noeuds restants consommateurs=type1  
	        3	2	0	0	0	0	1	1	0	225	2	1.1	0.7;%noeuds 3 et 11 générateurs=type2	 
            4	1	35	40	0	0	1	1	0	225	2	1.1	0.7;
            5	1	60	20	0	0	1	1	0	225	2	1.1	0.7;
            6	1	50	25	0	0	1	1	0	225	2	1.1	0.7;
            7	1	0	0	0	0	1	1	0	225	2	1.1	0.7;
            8	1	15	5	0	0	1	1	0	90	2	1.1	0.7;
            9	1	10	6	0	0	1	1	0	90	2	1.1	0.7;
            10	1	14	8	0	0	1	1	0	90	2	1.1	0.7;
            11	2	0	0	0	0	1	1	0	90	2	1.1	0.7;
            12	1	12	9	0	0	1	1	0	90	2	1.1	0.7;
            13	1	12	8	0	0	1	1	0	90	2	1.1	0.7;
            14	1	8	5	0	0	1	1	0	90	2	1.1	0.7;
];


%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	        mBase	status	Pmax	Pmin
mpc.gen = [
        1	0	0	300	-300	416/400	    100	1	300	10;
	    3	80	0	300	-300	229.5/225   100	1	300	10;
	    11	20	0	300	-300	89.1/90	    100	1	300	10;
   
];


pt=1; %%% pt == pertes

%On doit calculer x=X/Zb . Comme on a X donné par l'énoncé on va calculer
%Zb avec Zb=Ub/Ib = Ub²/Sb .
Ub=225*10^3;       
Sb=100*10^6;
Zb=(Ub^2)/Sb;
%Pour les lignes 225kV on prend r + jx = 1.3 + j18Ω, b = 1.57 × 10−4 Ω^-1
R=1.3;  X=18;       B=1.57e-4;   b=B*Zb;
r=R/Zb; x=X/Zb;   %x=réactance de la ligne 400kv

%pour les 7 lignes 90 kV : r + jx = 1.5 + j21Ω, b = 1.41 × 10−4 Ω^-1
Ub2=90*10^3;
Zb2=(Ub2^2)/Sb;

B2=1.41e-4;  b2=B2*Zb2;      r2=1.5/Zb2; x2=21/Zb2; %x2=réactance de la ligne 225kv  


%Le transformateur entre les points 1 et 2 a S=250MVa
Xcc=0.125; % dans la base du transformateur
Sb=100*10^6;
Sbt=250*10^6;
xcc=Xcc*Sb/Sbt; %xcc est la réactance du transformateur en P.U dans la base 100MVA

%Le transformateur entre les points 7 et 8 a S=100Mva
xp=0.12; xs=0.1; xt=0.1;

%% branch data
%	fbus tbus	r	    x	        b	rateA	rateB	rateC	ratio	angle	status
mpc.branch = [
	    2	1	0	   xcc	    0	100	100	100 1	0	1;
	    2	3	r      x	        b	100	100	100	0	0	1;
        2	5	r      x	        b	100	100	100	0	0	1;
        2	4	r      x	        b	100	100	100	0	0	1;
        3	4	r      x	        b	100	100	100	0	0	1;
        4	5	r      x	        b	100	100	100	0	0	1;
	    5	6	r      x	        b	100	100	100	0	0	1;
        4	6	r      x	        b	100	100	100	0	0	1;
        6	7	0      xp	        0	100	100	100	1	0	1;
        8	7	0      xs	        0	100	100	100	1.15	0	1;
        8	9	r2     x2	        b2	100	100	100	0	0	1;
        8	10	r2     x2	        b2	100	100	100	0	0	1;
        10	12	r2     x2	        b2	100	100	100	0	0	1;
        9	11	r2     x2	        b2	100	100	100	0	0	1;
        11	12	r2     x2	        b2	100	100	100	0	0	1;
        12	13	r2     x2	        b2	100	100	100	0	0	1;
        13	14	r2     x2	        b2	100	100	100	0	0	1;
        ];

return;
