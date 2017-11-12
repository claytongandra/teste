<%
Function fnResumindo(txt,vCrt)
	if Len(txt) <= vCrt then
		response.write (left(txt,vCrt))
	else
		while not ul=" " or vCrt=len(txt) 
			vExibe = left(txt,vCrt) 
			ul= right(vExibe,1) 
			vCrt=vCrt+1
		wend
		if vCrt=len(txt) then 
			Response.Write(txt)
		else 
			vExibe=left(vExibe,(len(vExibe)-1))&"..." 
			Response.Write(vExibe)
		end if
	end if
end function
%>