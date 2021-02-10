
% Sukurkite daugiasluoksnio perceptrono koeficientams apskaičiuoti skirtą programą. 
% Daugiasluoksnis perceptronas turi atlikti aproksimatoriaus funkciją. 
% Daugiasluoksnio perceptrono struktūra:
% vienas įėjimas (įėjime paduodamas 20 skaičių vektorius X, su reikšmėmis intervale nuo 0 iki 1, pvz., x = 0.1:1/22:1; ).
% vienas išėjimas (pvz., išėjime tikimasi tokio norimo atsako, kurį galima būtų apskaičiuoti pagal formulę: 
% y = (1 + 0.6*sin(2*pi*x/0.7)) + 0.3*sin(2*pi*x))/2; - kuriamas neuronų tinklas 
% turėtų "modeliuoti/imituoti šios formulės elgesį" naudodamas visiškai kitokią matematinę išraišką nei ši);
% vienas paslėptasis sluoksnis su hiperbolinio tangento arba sigmoidinėmis aktyvavimo funkcijomis neuronuose (neuronų skaičius: 4-8);
% tiesine aktyvavimo funkcija išėjimo neurone;
% mokymo algoritmas - Backpropagation (atgalinio sklidimo).

clc; clear; close all;

% Instruktažas:
%%% Žr. IMG_20201021_181308.jpg schemą dešinėje ir formules
% 1. Duomenų mokymui paruošimas(atranka)
% x = 0.1:1/22:1;
% d = (1 + 0.6 * sin(2*pi*x/0.7)) + 0.3 * sin(2*pi*x) / 2;
% 
% 2. skaičiuojame tinklo atsaką
% 2.1 Susigeneruojame rand W1_1, W2_1, W3_1, W4_1, W1_2, W2_2, W3_2, W4_2, b1_1, b2_1;
% 2.2 Skaičiuojame pirmo sluoksnio išėjimus:
% 2.2.1. V1_1=x(1)*w1_1+b1_1;
%        V2_1=x(1)*w2_1+b2_1;
%        <...>
% 2.2.2 pritaikome aktyvacijos funkciją:
% Y1_1=1/(1+exp(-v1_1));
% Y2.1=1/(1+exp(-v2_1));
% <..>
% 
% 2.3 skaičiuojame antro sluoksnio išėjimus:
%  Y=V=Y1_1*w1_2+y2_1*w2_2+Y3_1*w3_2+..+b1_2;
%  
% 2.4 skaičiuojame klaidą:
% e=d-y;
% 
% 3. atnaujiname koeficientus:  n=bet koks (psueorandom) pvz n=0.1
% 3.1. w=w+n*delta*y_in;
% delta_out=e;
% w1_2=w1_2+n*delta_out*y1_1;
% w2_2=w2_2+n*delta_out*y2_1;
% w3_2=w2_2+n*delta_out*y3_1;
% w4_2=w2_2+n*delta_out*y4_1;
% b1_2=b1_2+n*delta_out;
% 
% 3.2 Pirmo sluoksnio koeficientų atnaujinimas:
% delta1=Fi1' * delta_out *W1_2
% Fi1'= 1/(1+exp(-v))=y1_1(1-y1_1);
%
%%%%% generuojame pvz 10000 kartų

%%%nusipiešiam funkciją pagal kurią reikės orientuotis 

disp('pasirenkame keturis neuronais paslėptame sluoksnyje');
disp('aktyvavimo funkcija y1_1=1/(1+exp(-(v1_1))');

% 1. Duomenų mokymui paruošimas(atranka)
% x = 0.1:1/22:1;
% d = (1 + 0.6 * sin(2*pi*x/0.7)) + 0.3 * sin(2*pi*x) / 2;
z = 0.1:1/22:1;
d = (1 + 0.6 * sin(2*pi*z/0.7)) + 0.3 * sin(2*pi*z) / 2;
plot ( z, d );
%disp(z');


% 2. skaičiuojame tinklo atsaką
% 2.1 Susigeneruojame rand W1_1, W2_1, W3_1, W4_1, W1_2, W2_2, W3_2, W4_2, b1_1, b2_1;
disp('generuojame rand w1, w2 ir b');

w11 = randn(1);  
w21 = randn(1);
w31 = randn(1);
w41 = randn(1);

w12 = randn(1);
w22 = randn(1);
w32 = randn(1);
w42 = randn(1);

b11 = randn(1);
b21 = randn(1);
b31 = randn(1);
b41 = randn(1);

b12 = randn(1);

disp('sugeneruoti rand w1, w2 ir b');

disp('skaičiuojam pirmąjį sluoksnį:');
disp('kartojam iteracijas');
disp('dėliojame taškus praeinant per visą X skalę');

for iteracija=0:1:1000    %pradedame nuo 100, 1000, 10000, 100000
 for x = 0.1:1/22:1
    
     d = (1 + 0.6*sin(2*pi*x/0.7)) + 0.3*sin(2*pi*x)/2;
     % 2.2 Skaičiuojame pirmo sluoksnio išėjimus:
     % 2.2.1. V1_1=x(1)*w1_1+b1_1;
     %        <...>
     v11=x*w11+b11;
     v21=x*w21+b21;
     v31=x*w31+b31;
     v41=x*w41+b41;
     
     % 2.2.2 pritaikome aktyvacijos funkciją:
     % Y1_1=1/(1+exp(-v1_1));
     % Y2.1=1/(1+exp(-v2_1));
     % <..>
     y11=1/(1+exp(-v11));
     y21=1/(1+exp(-v21));
     y31=1/(1+exp(-v31));
     y41=1/(1+exp(-v41));
     
     
     % 2.3 skaičiuojame antro sluoksnio išėjimus:
     %  Y=V=Y1_1*w1_2+y2_1*w2_2+Y3_1*w3_2+..+b1_2;
     
     v = y11 * w12 + y21 * w22 + y31 * w32 + y41 * w42 + b12;
     y=v;
      
     % 2.4 skaičiuojame klaidą:
     % e=d-y;
     e=d-y;
     
     % 3. atnaujiname koeficientus:  n=bet koks (psueorandom) pvz n=0.1
     % 3.1. w=w+n*delta*y_in;
     % delta_out=e;
     % w1_2=w1_2+n*delta_out*y1_1;
     % w2_2=w2_2+n*delta_out*y2_1;
     % w3_2=w2_2+n*delta_out*y3_1;
     % w4_2=w2_2+n*delta_out*y4_1;
     % b1_2=b1_2+n*delta_out;
     %
     n=0.1;   %%%%%%%%%%%%%%%%%% 0.9 visus koeficientus NaN verčia
     delta_out=e;
     w12 = w12 + n * delta_out * y11;
     w22 = w22 + n * delta_out * y21;
     w32 = w32 + n * delta_out * y31 ;
     w42 = w42 + n * delta_out * y41 ;
     b12 = b12 + n * delta_out ;
     
     % 3.2 Pirmo sluoksnio koeficientų atnaujinimas:
     % delta1=Fi1' * delta_out *W1_2
     % Fi1'= 1/(1+exp(-v))=y1_1(1-y1_1);
     
     delta1 = (y11 * (1-y11)) * delta_out * w12;
     delta2 = (y21 * (1-y21)) * delta_out * w22;
     delta3 = (y31 * (1-y31)) * delta_out * w32;
     delta4 = (y41 * (1-y41)) * delta_out * w42;
     
     
     w11 = w11 + n * delta1 * x;
     w21 = w21 + n * delta2 * x;
     w31 = w31 + n * delta3 * x;
     w41 = w41 + n * delta4 * x;
     
     b11 = b11 + n * delta1;
     b21 = b21 + n * delta2;
     b31 = b31 + n * delta3;
     b41 = b41 + n * delta4;
 end
end


%%%%% patikriname ar ką nors padaro
rezultatas_y = []; 


for x = 0.1:1/22:1
    d = (1 + 0.6 * sin(2*pi*x/0.7)) + 0.3 * sin(2*pi*x) / 2;
    % 2.2 Skaičiuojame pirmo sluoksnio išėjimus:
    % 2.2.1. V1_1=x(1)*w1_1+b1_1;
    %        <...>
    v11=x*w11+b11;
    v21=x*w21+b21;
    v31=x*w31+b31;
    v41=x*w41+b41;

    % 2.2.2 pritaikome aktyvacijos funkciją:
    % Y1_1=1/(1+exp(-v1_1));
    % Y2.1=1/(1+exp(-v2_1));
    % <..>
    y11=1/(1+exp(-v11));
    y21=1/(1+exp(-v21));
    y31=1/(1+exp(-v31));
    y41=1/(1+exp(-v41));
    % 2.3 skaičiuojame antro sluoksnio išėjimus:
    %  Y=V=Y1_1*w1_2+y2_1*w2_2+Y3_1*w3_2+..+b1_2;
    y = y11 * w12 + y21 * w22 + y31 * w32 + y41 * w42 + b12;
    rezultatas_y = [rezultatas_y, y];        %%%% surašom vertes po vieną į galą
end


disp('rezultatas');disp(rezultatas_y'); 
%palyginame su etalonine funkcija
paklaida=abs(rezultatas_y -d) ;

disp('paklaida');disp(paklaida);

vaizdavimas =[];
 vaizdavimas=[vaizdavimas;rezultatas_y'];
 vaizdavimas=[vaizdavimas;paklaida'];
 disp('vaizdavimas');disp(vaizdavimas);


