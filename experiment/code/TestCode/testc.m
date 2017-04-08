 x= 6;
y = 9;
b1 = 0;
b2 = 0;
 for i = (x-3):(x+3)
       for j = (y-3):(y+3)
                b1 = b1 + ROIfb(output(j,i),255);
                b2 = b2 + ROIfb(output(j,i),0);
        end
 end
    if (b1 - b2)>1
        output(x,y) = 100;
     end
    if (b1 - b2)<-1
        output(x,y) = 0;           
    end