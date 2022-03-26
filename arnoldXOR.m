function temp3=arnoldXOR(im)
% a=imread('lenagray.tif');
% a=imread('Peppersgray.tif');
% a=imread('Baboongray.tif');
% a=imread('lake.tif');
% if(size(a,3)==3) a=rgb2gray(a);
%  end
% One  A=[1 1; 1 2]  Arnold matrix   p=1 q=1 p1=1 q1=2
% We can generate many Arnold matrix .....
%tic;
IMG=im;
T=10;
key1=243;
key2=133;
key3=87;
key4=53;

p=1;
q=1;
p1=1;
q1=2;
imhist(im);
newim=zeros(size(im));
newim1=zeros(size(im));

[rown,coln]=size(im);
im1=im;
for inc=1:T
    for i=1:rown
        for j=1:coln
            x=p*i+q*j;    
            y=p1*i+q1*j;
            %x=i+p*j;
            %y=q*i+(p*q+1)*j;
            x=mod(x,size(IMG,1));
            y=mod(y,size(IMG,2));
            newim(x+1,y+1)=im(i,j);%(mod(nrowp,rown)+1),(mod(ncolp,coln)+1));
            
        end
    end
   
    for i=1:2:rown
        for j=1:2:coln
            newim(i,j)=bitxor(uint8(newim(i,j)),uint8(key1));
            newim(i,j+1)=bitxor(uint8(newim(i,j+1)),uint8(key2));
            newim(i+1,j)=bitxor(uint8(newim(i+1,j)),uint8(key3));
            newim(i+1,j+1)=bitxor(uint8(newim(i+1,j+1)),uint8(key4));
        end
    end
 im=newim;
end
%toc;
for inc=1:T
    for i=1:rown
        for j=1:coln
           
            x=i+p1*j;
            y=q1*i+(p1*q1+1)*j;
            x=mod(x,size(IMG,1));
            y=mod(y,size(IMG,2));
            newim1(x+1,y+1)=im1(i,j);%(mod(nrowp,rown)+1),(mod(ncolp,coln)+1));
        end
    end
   
    
    for i=1:2:rown
        for j=1:2:coln
            newim1(i,j)=bitxor(uint8(newim1(i,j)),uint8(key2));
            newim1(i,j+1)=bitxor(uint8(newim1(i,j+1)),uint8(key4));
            newim1(i+1,j)=bitxor(uint8(newim1(i+1,j)),uint8(key1));
            newim1(i+1,j+1)=bitxor(uint8(newim1(i+1,j+1)),uint8(key3));
        end
    end
im1=newim1;
end
temp3=im1;
figure,imhist(uint8(im1));
figure,imshow(uint8(newim));
%figure,imhist(uint8(newim));
%[hc vc dc]=correlationCoefficient(IMG);
%[hc vd dc]=correlationCoefficient(im);
% 
 [e,p,r1,r2]=correlations(IMG);
 fprintf('\n\n\nOrg image entrpty=%f corV=%f corH=%f corD=%f\n',e,p,r1,r2);
% 
 [e,p,r1,r2]=correlations(im);
 fprintf('Enc image entrpty=%f corV=%f corH=%f corD=%f\n',e,p,r1,r2);
 fprintf('For latex file:enrtopy =%f & %f & %f & %f & %f\n',e,r1,p,r2,(abs(p)+abs(r1)+abs(r2))/3.0);
% 
%[npcr,uaci]=NPCR_and_UACI(newim,newim1);
%fprintf('key change: NPCR=%f  UACI=%f\n',npcr,uaci);

% 
[histdev, irrgdev, devideal]=histanalysis(IMG,newim);
fprintf('Hist deviation=%f Irregular Devation=%f  Deviation from Ideal=%f\n',histdev, irrgdev, devideal);
figure,imhist(uint8(im));
% pause;
end


function [e, pv, ph, pd]=correlations(im)
e=entropy(uint8(im));
a=im(1:size(im,1)-1,:);
b=im(2:size(im,1),:);
pv = corr2(a,b);


a=im(:,1:size(im,2)-1);
b=im(:,2:size(im,2));
ph = corr2(a,b);

a=im(1:size(im,1)-1,1:size(im,2)-1);
b=im(2:size(im,1),2:size(im,2));
pd = corr2(a,b);
end

function [histdev, irrgdev, devideal]=histanalysis(im,B)
%%%%%%%%%%%%%%%5 hitogram deviation %%%%%%%%%%%%%%%%555
%figure, imhist(uint8(im))
histo=imhist(im);
%figure; imhist(uint8(B))
histe=imhist(uint8(B));
sumT=0.0;
for i=1:256
    if(histo(i)>=histe(i))
        sumT=sumT+(histo(i)-histe(i));
    else
        sumT=sumT+(histe(i)-histo(i));
    end
end
histdev=sumT/(size(im,1)*size(im,2));

%%%%%%%%%%%%%%55 irregular deviation %%%%%%%%%%%%%%%%%55
imd=double(im);
Bd=double(B);
diffimage=uint8(abs(imd-Bd));
histirre=imhist(diffimage);
mh=mean(mean(diffimage));
md=sum(histirre-mh);
irrgdev=md/(size(im,1)*size(im,2));
%%%%%%%%%%%% deviation from idelaity %%%%%%%%%%%%%%5555555
HISTu=histe;
HISTu(:,1)=(size(im,1)*size(im,2))/256;
sumT=0.0;
for i=1:256
    if(HISTu(i)>=histe(i))
        sumT=sumT+(HISTu(i)-histe(i));
    else
        sumT=sumT+(histe(i)-HISTu(i));
    end
end
devideal=sumT/(size(im,1)*size(im,2));

end