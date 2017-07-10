function [JPI1,JPI2,p1,p,q]=ExtractJPI(PartInfo)
%       ******************************************************************
%       *                          ADMAT - 2.0                           *
%       *              Copyright (c) 2008-2009 Cayuga Research           *
%       *                Associates, LLC. All Rights Reserved.           *
%       ******************************************************************

	index=1;
        len = PartInfo(index);
        si = PartInfo(index+3:index+2+len);
        sj = PartInfo(index+3+len:index+2+2*len);
        v = PartInfo(index+3+2*len:index+2+3*len);
        JPI1 = sparse(si,sj,v,PartInfo(index+1),PartInfo(index+2),len);
        index=index+3*(len+1);
        len = PartInfo(index);
        si = PartInfo(index+3:index+2+len);
        sj = PartInfo(index+3+len:index+2+2*len);
        v = PartInfo(index+3+2*len:index+2+3*len);
        JPI2 = sparse(si,sj,v,PartInfo(index+1),PartInfo(index+2),len);
	n=PartInfo(index+2);
        index=index+3*(len+1);
	p1=full(PartInfo(index:index+n-1)); 
	p=full(PartInfo(index+n:index+2*n-1)); 
	q=full(PartInfo(index+2*n:index+3*n-1)); 
