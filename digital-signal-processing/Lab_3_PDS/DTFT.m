% C�lculo da DTFT
%
%
% M = Qntd de pontos da DTFT
% x = Sinal de entrada (dom�nio do tempo)
% X = Sinal de sa�da (Dom�nio da frequ�ncia
% nX = Eixo das abcisas do sinal de sa�da
%
%

function [ X, nX ] = DTFT( M, x)
    X = zeros(1, 2*M+1);
    nX = -M:1:M;
    for k = -M:M
        aux = 0;
        for nx = 1:length(x)
            aux = aux + x(nx)*exp(-1i*pi/M).^(nx*k);
        end
        X(k+M+1) = aux;
    end
end

