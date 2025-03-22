function [n,m,Con,Nod,anch_ele,frame_ele,rad_ele] = makestr_SW(UCnx,UCny,UCnz,UcL,fr2an,cvx)
    
    center=[0,0,0];
           
    corners=[1, -1, 1;
           1, 1, 1;
           1, -1, -1;
           1, 1, -1;
           -1, -1, 1;
           -1, 1, 1;
           -1, -1, -1;
           -1, 1, -1];
    anchor_Nod=[center;corners]*0.5*UcL;
    frame_Nod=anchor_Nod(2:end,:)*fr2an; %fr2an ratio
    Nod=[anchor_Nod;frame_Nod];
    con_anchor=[2:9;(2:9)+8]';
    
    %% 2-Sc;
    scNod=(10:17)';
    con_SC=reshape((10:17)',2,4);
    con_SC=[con_SC(:,[1,2]);con_SC(:,[3,4])];
    con_SC=[con_SC;scNod(1:4),scNod(1:4)+4];
    con_SC=[con_SC;reshape(scNod,2,4)'];
    radials_Nod=(Nod(con_SC(:,1),:)+Nod(con_SC(:,2),:))/2;
    con_frame=[con_SC(:,1); con_SC(:,2)];
    con_mid=length(Nod)+(1:12);
    con_mid=[con_mid,con_mid]';
    con_frame=[con_frame,con_mid];
    
    radials_Nod=radials_Nod*cvx; %Change the convexity of frames
    
    con_rads=[con_mid(1:12),ones(12,1)];
    
    Nod=[anchor_Nod;frame_Nod;radials_Nod];
    Sw_con=[con_anchor;con_frame;con_rads];
        
    Con=Sw_con;
    uc_con_len=length(Sw_con);
    
    %% Climbing Z
    z_btm=find(Nod(:,3)==-0.5*UcL);
    
    N=length(Nod);
    new_Nod=Nod;
    new_Nod(z_btm,:)=[];
    
    for i=1:UCnz-1
        new_Nod=new_Nod+[0,0,UcL];
        N=length(Nod);
        new_con=Con(1:44,:)+N;
        for j=1:length(z_btm)
            new_con(new_con==z_btm(j)+N)=find(ismember(Nod,Nod(z_btm(j),:)+[0,0,i*UcL],'rows'));
        end
        for j=length(z_btm):-1:1
            new_con(new_con>z_btm(j)+N)=new_con(new_con>z_btm(j)+N)-1;
        end
        Nod=[Nod;new_Nod];
        Con=[Con;new_con];
    end
    
    len_con=length(Con);
    y_btm=find(Nod(:,2)==-0.5*UcL);
    new_Nod=Nod;
    new_Nod(y_btm,:)=[];
    
    for i=1:UCny-1
        new_Nod=new_Nod+[0,UcL,0];
        N=length(Nod);
        new_con=Con(1:len_con,:)+N;
    
        for j=1:length(y_btm)
            new_con(new_con==y_btm(j)+N)=find(ismember(Nod,Nod(y_btm(j),:)+[0,i*UcL,0],'rows'));
        end
        for j=length(y_btm):-1:1
            new_con(new_con>y_btm(j)+N)=new_con(new_con>y_btm(j)+N)-1;
        end
        Nod=[Nod;new_Nod];
        Con=[Con;new_con];
    end
    
    len_con=length(Con);
    x_btm=find(Nod(:,1)==-0.5*UcL);
    new_Nod=Nod;
    new_Nod(x_btm,:)=[];
    
    for i=1:UCnx-1
        new_Nod=new_Nod+[UcL,0,0];
        N=length(Nod);
        new_con=Con(1:len_con,:)+N;
    
        for j=1:length(x_btm)
            new_con(new_con==x_btm(j)+N)=find(ismember(Nod,Nod(x_btm(j),:)+[i*UcL,0,0],'rows'));
        end
        for j=length(x_btm):-1:1
            new_con(new_con>x_btm(j)+N)=new_con(new_con>x_btm(j)+N)-1;
        end
        Nod=[Nod;new_Nod];
        Con=[Con;new_con];
    end
    
    n=length(Nod);
    m=length(Con);
    cubes=UCnx*UCny*UCnz;
    
    
%     anch_con=ones(8*cubes,2);
%     frame_con=ones(24*cubes,2);
%     rad_con=ones(12*cubes,2);
    anch_ele=ones(1,8*cubes);
    frame_ele=ones(1,24*cubes);
    rad_ele=ones(1,12*cubes);
    ta=1;
    tf=1;
    tr=1;
    for i=1:length(Con)
        indx=1+mod(i-1,44);
        if indx<9
%             anch_con(ta,:)=Con(i,:);
            anch_ele(ta)=i;
            ta=ta+1;
        elseif indx>32
%             rad_con(tr,:)=Con(i,:);
            rad_ele(tr)=i;
            tr=tr+1;
        else
%             frame_con(tf,:)=Con(i,:);
            frame_ele(tf)=i;
            tf=tf+1;
        end
    end
end