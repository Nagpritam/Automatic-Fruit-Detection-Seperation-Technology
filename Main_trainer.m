clc;
clear all;
close all;

truth_x=[];

Files=dir('Good');

figure('name','Train GOOD Image result');

hold on

ii=1;

lbp_value=[];

for k=1:length(Files)
    
   FileName=Files(k).name;
   
   
   
   if(strcmp(FileName,'.')||strcmp(FileName,'..')||strcmp(FileName,'Thumbs.db'))
       continue;
   end
   
   Train_image=imread(FileName);
   
   I = imresize(Train_image,[256 256]);
   
   
   im = I;
   
   R = im(:,:,1);
   
   G = im(:,:,2);
   
   B = im(:,:,3);
   
   subplot(231);imshow(I,[]);title('Input Image');
   
   subplot(232);imshow(R,[]);title('Red band Image');

   subplot(233);imshow(G,[]);title('Green band Image');

   subplot(234);imshow(B,[]);title('Blue Image');
   
   
    cform = makecform('srgb2lab');
    lab = applycform(I,cform); 
    
    
    %figure('name','Input Image & L*a*b Color space Result');
   % subplot(335);imshow(I,[]);title('Input RGB image');
    subplot(235);imshow(lab);title('L*a*b color space result');
    
    ll = lab(:,:,1);
    aa = lab(:,:,2);
    bb = lab(:,:,3);
    
    
    %% LBP

    a = ll;
    [m,n] = size(a);
    for i = 2:m-1
        for j = 2:n-1
            b = a(i-1:i+1,j-1:j+1);
            B(i-1:i+1,j-1:j+1) = LBP(b);
        end
    end
    subplot(236);imshow(B);
    title('Local Binary Patterns');

    lbp = mean(mean(B));
    disp('the data is ')
    disp(i)
    data = lbp
   
    drawnow();
   
    truth_x(ii) = 1;
    lbp_value(ii)=data;
    ii=ii+1;
end

hold off




Files=dir('Bad');

figure('name','Train Bad Image result');

hold on




for k=1:length(Files)
    
   FileName=Files(k).name;
   
   
   
   if(strcmp(FileName,'.')||strcmp(FileName,'..')||strcmp(FileName,'Thumbs.db'))
       continue;
   end
   
   Train_image=imread(FileName);
   
   I = imresize(Train_image,[256 256]);
   
   
   im = I;
   
   R = im(:,:,1);
   
   G = im(:,:,2);
   
   B = im(:,:,3);
   
   subplot(231);imshow(I,[]);title('Input Image');
   
   subplot(232);imshow(R,[]);title('Red band Image');

   subplot(233);imshow(G,[]);title('Green band Image');

   subplot(234);imshow(B,[]);title('Blue Image');
   
   
    cform = makecform('srgb2lab');
    lab = applycform(I,cform); 
    
    
    %figure('name','Input Image & L*a*b Color space Result');
   % subplot(335);imshow(I,[]);title('Input RGB image');
    subplot(235);imshow(lab);title('L*a*b color space result');
    
    ll = lab(:,:,1);
    aa = lab(:,:,2);
    bb = lab(:,:,3);
    
    
    %% LBP

    a = ll;
    [m,n] = size(a);
    for i = 2:m-1
        for j = 2:n-1
            b = a(i-1:i+1,j-1:j+1);
            B(i-1:i+1,j-1:j+1) = LBP(b);
        end
    end
    subplot(236);imshow(B);
    title('Local Binary Patterns');

    lbp = mean(mean(B));
    disp('the data is ')
    disp(i)
    data = lbp
   
    drawnow();
   
    truth_x(ii) = 0;
    lbp_value(ii)=data;
    ii=ii+1;
end

hold off

%% create a feed forward neural network

net1 = newff(minmax(lbp_value),[30 20 1],{'logsig','logsig','purelin'},'trainrp');
net1.trainParam.show = 1000;
net1.trainParam.lr = 0.04;
net1.trainParam.epochs = 7000;
net1.trainParam.goal = 1e-5;

%% Train the neural network using the input,target and the created network
[net1] = train(net1,lbp_value,truth_x);

%% save the network
save net1 net1
