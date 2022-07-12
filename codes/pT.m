bigNum=1e4;
for b=1:bigNum
    for a=1:bigNum
        val=Struct_A(a).dat(b);
        Struct_B(b).dat(a)=val;
    end
end