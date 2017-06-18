% close all;
% clc;
figure;


lineStyle = ['o-';  'h-';  '*-';  '.-';  'x-';  's-';  'd-';  '^-';  'p-'; '+-'; '<-'];

% signal generation;�����Ҫ����100������Ĳ��ԣ����Խ���100��ѭ��������100�����������
the = zeros(1,11);
for j = 1:11  % bit per symbol: 1. BPSK; 2. QPSK; 3.8QAM; 4. 16QAM; 5. 32QAM; 6.64QAM; 7.2FSK; 8.4FSK; 9.8FSK; 10.4ASK; 11.8ASK

    if j < 10
        System.BitPerSymbol = j;
    else
        System.BitPerSymbol = j - 8;
    end
    snr = -5:30;  %SNR����ȵ����ã���λdB
    fs1 = zeros(1,16);

    acc = zeros(1, length(snr));
    for snrIndex= 1:length(snr)
        cnt = 0;
        for repeat = 1:100
            Tx.SampleRate = 32e9; %symbol Rate���źŵ���Ԫ���ʣ��������ж���
            Tx.Linewidth = 0;%�����źŵ��ز����߿�һ�����źŵ���λ�����йأ���С���������ã�������ʱ����Ϊ0
            Tx.Carrier = 0;%�����źŵ��ز�Ƶ�ʣ����������ã���������Ϊ0
            M = 2^System.BitPerSymbol;

            if j == 7 || j == 8 || j == 9 %fsk
                Tx.DataSymbol = randi([0 M/64-1],1,10000);
            else
                Tx.DataSymbol = randi([0 M-1],1,10000);%ÿһ�������������������������ʱ��Ϊ���ݵ����Ϊ10000��
            end

            %���ݵĲ�ͬ���Ʒ�ʽ�����������2^3��8QAM������ʽ�����ó������ã���Ϊ��ʵ�����ŵ�����8QAM����ͼ
            if j == 7 || j == 8 || j == 9 %fsk            
%                 Tx.DataConstel = fskmod(Tx.DataSymbol,M/64,50,j,15000);
                    Tx.DataConstel = fskmod(Tx.DataSymbol, M/64, log2((M/64)), 2, 32);
            elseif j > 9
                Tx.DataConstel = Tx.DataSymbol;
            elseif M ~= 8
    %             h = modem.qammod('M', M, 'SymbolOrder', 'Gray');
    %             Tx.DataConstel = modulate(h,Tx.DataSymbol);
                    Tx.DataConstel = qammod(Tx.DataSymbol, M, 'gray');
            else
                    tmp = Tx.DataSymbol;
                    tmp2  = zeros(1,length(Tx.DataSymbol));
                    for kk = 1:length(Tx.DataSymbol)
                        switch tmp(kk)
                            case 0
                                tmp2(kk) = 1 + 1i;
                            case 1
                                tmp2(kk) = -1 + 1i;
                            case 2
                                tmp2(kk) = -1 - 1i;
                            case 3
                                tmp2(kk) = 1 - 1i;
                            case 4
                                tmp2(kk) = 1+sqrt(3);
                            case 5
                                tmp2(kk) = 0 + 1i .* (1+sqrt(3));
                            case 6
                                tmp2(kk) = 0 - 1i .* (1+sqrt(3));
                            case 7
                                tmp2(kk) = -1-sqrt(3);
                        end
                    end
                    Tx.DataConstel = tmp2;
                    clear tmp tmp2;
            end

            Tx.Signal = Tx.DataConstel;

            %���ݵ��ز����أ����ǵ���λ������
            N = length(Tx.Signal);
            dt = 1/Tx.SampleRate;
            t = dt*(0:N-1);
            Phase1 = [0, cumsum(normrnd(0,sqrt(2*pi*Tx.Linewidth/(Tx.SampleRate)), 1, N-1))];
            carrier1 = exp(1i*(2*pi*t*Tx.Carrier + Phase1));
            Tx.Signal = Tx.Signal.*carrier1;

            if(j == 1 || j >=10 )
                Tx.Signal = complex(Tx.Signal);
            end

            Rx.Signal = awgn(Tx.Signal,snr(snrIndex),'measured');%������AWGN�ŵ��µĽ���
%             Rx.Signal = Tx.Signal;

            CMAOUT = Rx.Signal;

            %normalization�����źŹ��ʹ�һ��
    %         CMAOUT=CMAOUT/sqrt(mean(abs(CMAOUT).^2));
    
%             subplot(1,4,snrIndex); 
%             plot(Rx.Signal,'.');

            type = classify(Rx.Signal);
            
            if type == j
                cnt = cnt +1;
            end
            
%             fs1(snrIndex) = classify(Rx.Signal);

    %         si = [real(Rx.Signal)' imag(Rx.Signal)'];
    %         center = subclust(si, [0.1 0.1]);
    %         hold on;
    %         center = complex(center( : , 1)', center(:,2)');
    %         plot(center,'*');
    %         options = statset('MaxIter',1000);
    %         gmfit = fitgmdist(si,3,'CovarianceType','diagonal',...
    %             'SharedCovariance','true','Options',options);
    %         center = cluster(gmfit, si);
    %         hold on;
    %         plot(center, '.');
        
        end
        acc(snrIndex) = cnt/100;

    end
%     hold on
%     plot(fs1,lineStyle(j,:));
%     the(j) = mean(fs1);
    hold on
    plot(snr, acc,lineStyle(j,:));
    axis([-5 30 0 1]);
end
grid on
legend('BPSK', 'QPSK', '8QAM', '16QAM', '32QAM', '64QAM', '2FSK', '4FSK', '8FSK', '4ASK', '8ASK');
% legend( 'QPSK', '8QAM', '16QAM', '32QAM', '64QAM', '2FSK', '4FSK', '8FSK', '4ASK', '8ASK');
