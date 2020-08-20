
clear all
close all
 s=serial('COM68','baudRate',9600);
 fopen(s);

load net1.mat

[file,path] = uigetfile('*.jpg;*.bmp;*.png');

fullpath=strcat(path,file);

I = imread(fullpath);

I = imresize(I,[256 256]);

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
    
    y = round(sim(net1,data));
    
    if(y==0)
         
          fprintf(s,'N');
          pause(1.5);
          fclose(s);
        msgbox('BAD APPLE');
        
    elseif(y==1)
          fprintf(s,'S');
          pause(1.5);
          fclose(s);
        msgbox('GOOD APPLE');
    end
        