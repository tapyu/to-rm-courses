%% Lab 4
%% b

% Usando o comando descrito em (b), fa�a o gr�fico do m�dulo e da fase da
% resposta em frequ�ncia do sistema que obedece a seguinte equa��o de
% diferen�as: y[n]=x[n]-x[n-2]+0.81y[n-2].


% h = (1 - z^-2)/(1 - 0.81z^-2)

b = [1 0 -1];
a = [1 0 -.81];
n = 2001;

[h1,w] = freqz(b,a,'whole',n);

plot(w/pi,20*log10(abs(h1)))
ax = gca;
ax.YLim = [-100 20];
ax.XTick = 0:.5:2;
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')




%% c

% Aplicando o comando descrito em (c), encontre a resposta impulsiva do sistema cuja fun��o do sistema �  
% Fa�a o gr�fico de h[n] para n no intervalo de 0 at� 100. Determine h[n] usando
% o comando h= filter(b,a, x) e compare com o resultado anterior.

b = [0 1 1];
a = [1 -.9 .81];

[r,p,k] = residuez(b,a);

% r = [-0.6 - 1i;-0.6 + 1i]
% p = [0.45 + 0.8i 0.45 - 0.8i]

delta = [1 zeros(1,99)];
t = 0:1:99;
figure(1)

h1= filter(b,a, delta);
h2 = 2.34.*ones(1,length(t)) .* .9.^t .* cos((pi/3)*t-.71*pi);

stem(t, h1)
hold on
stem(t, h2)
legend('Resposta impulsiva atrav�s da fun��o filter', 'Resposta impulsiva atrav�s da expans�o parcial');


%% d

%  Fa�a o gr�fico da solu��o da seguinte equa��o de diferen�as: y[n]=x[n]+3y[n-
%  1]/2+y[n-2]/2, para n no intervalo de 0 at� 100, x[n]= (0.25)n u[n], sendo y(-1)=4 e
%  y(-2)=10.


b = 1;
a = [1 -3/2 1/2];
yo = [10 4];

xic = filtic(b, a, yo, []);

t = 0:1:99;
x = (.25).^t;

y = filter(b, a, x, xic);
stem(t, y)
title('y[n]');




