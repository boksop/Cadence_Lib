(axlCmdRegister "Jun_NetMsg" 	'Jun_NetMsg ?cmdType "interactive" )
(axlCmdRegister "Jun_NetTool" 	'Jun_NetTool ?cmdType "interactive" )
procedure((Jun_NetTool \@optional cmd s_cmd) 
	prog((file temp msg pin) 
	    if(symbolp(cmd) 
		(cmd = (symbolToString cmd))
	    ) 
	    (cmd = if(stringp(cmd) 
		    upperCase(cmd) ""
		)) 
	    if((cmd == "") then 
		if((boundp('Jun_NetList) && tablep(Jun_NetList) && Jun_NetList["HANDLE"]) then 
		    return((axlShell "Jun_NetMsg"))
		) 
		(Jun_NetList = makeTable("JunTable" nil)) 
		(Jun_NetList["VER"] = "REV1.1   Apr 23rd 2010")
		(Jun_NetList["AS"] = nil) 
		(Jun_NetList["ZS"] = -1) 
		(Jun_NetList["VALUE"] = "View") 
		(Jun_NetList["CS"] = "Pattern State: All") 
		(Jun_NetList["FIELD"] = (Jun_StrReset 
			Jun_NetList["VALUE"] ?s_add "Field_" ?s_new
			"_"
		    ))
		(Jun_NetList["ML"] = nil) 
		(Jun_NetList["ZM"] = nil) 
		(file = outfile((axlTempFile) "w")) 
		(Jun_FormBeginEnd file ?mode "BEGIN" ?f_header
		    "Net Message" ?wh 
		    list(29 50)
		) 
		(Jun_FormTreeView file 
		    Jun_NetList["FIELD"] ?xy 
		    list(0 0)
		    ?wh 
		    list(30 14)
		)
		(Jun_NetList["FADD"] = "") 
		(Jun_NetList["BADD"] = "") 
		(Jun_FormButton file "AN" ?sname "Assign Pin Net"
		    ?xy 
		    list(1 29) ?wh 
		    list(3 3)
		) 
		(Jun_FormCheckList file "U:" ?xy 
		    list(14 29)
		) 
		(Jun_FormSTRFillin file "SN" ?xy 
		    list(18 29)
		    ?wh 
		    list(6 100)
		)
		(Jun_FormButton file "Clean" ?sname "C"
		    ?xy 
		    list(26 29) ?wh 
		    list(3 3)
		) 
		(temp = 0) 
		(Jun_FormCheckList file "A" ?sname "All"
		    ?xy 
		    list((temp = (temp + 0)) 32) ?f_label "AS"
		) 
		(Jun_FormCheckList file "S" ?sname "Single"
		    ?xy 
		    list((temp = (temp + 4)) 32) ?f_label "AS"
		) 
		(Jun_FormCheckList file "ZM" ?sname "Zoom:"
		    ?xy 
		    list((temp = (temp + 7)) 32)
		)
		(Jun_FormSlideBar file "ZS" ?xy 
		    list((temp = (temp + 7)) 32)
		    ?wh 
		    list(2 2) ?d_range 
		    list(-100 100)
		) 
		(Jun_FormButton file "H" ?sname "Help"
		    ?xy 
		    list((temp = (temp + 6)) 32) ?wh 
		    list(4 3)
		) 
		(Jun_FormBeginEnd file) 
		close(file) 
		(Jun_NetList["FORM"] = (file = (axlFormCreate 
			    (Jun_NetList["HANDLE"] = gensym()) 
			    get_filename(file) 
			    '("E" "OUTER") 
			    'Jun_NetToolCallBack
			    t nil
			)))
		if(isFile((file->form)) 
		    (axlTempFileRemove 
			(file->form)
		    )
		) 
		(axlFormSetField file "U:" t) 
		(axlFormSetField file "SN" "*") 
		(axlFormSetField file "A" t) 
		(Jun_NetList[Jun_NetList["FIELD"]] = list(list((axlFormTreeViewAddItem file 
				Jun_NetList["FIELD"] "Null" nil
				nil 
				'TVSELECT_3STATE
			    ) nil
			)
		    ))
		(axlFormTreeViewSet file 
		    Jun_NetList["FIELD"] 
		    'TV_NOEDITLABEL nil
		) 
		(axlFormColorize file 
		    (Jun_StrReset "U:" ?s_add "COLOR" ?s_new
			"_"
		    ) 
		    'text 
		    'red
		) 
		(axlFormSetField file "ZS" 
		    Jun_NetList["ZS"]
		) 
		(axlFormSetFieldEditable file "ZS" 
		    Jun_NetList["ZM"]
		) 
		(axlUIWPerm file t)
		(axlUIWPrint file 
		    Jun_NetList["VER"]
		) 
		(axlFormDisplay file) 
		if(!Jun_NetList["IN_SEL"] 
		    (axlShell "Jun_NetMsg")
		) 
		return(t)
	    ) 
	    if((cmd == "A") then 
		(Jun_NetList["AS"] = !Jun_NetList["AS"]) 
		(axlFormSetField 
		    Jun_NetList["FORM"] 
		    if(Jun_NetList["AS"] "S" "A") t
		) 
		printf((Jun_NetList["CS"] = strcat("Pattern State: " 
			    if(Jun_NetList["AS"] "Single" "All")
			))
		)
		if(!Jun_NetList["IN_SEL"] 
		    (axlShell "Jun_NetMsg")
		)
	    )
	    if((cmd == "C") 
		(axlFormSetField 
		    Jun_NetList["FORM"] "SN" "*"
		)
	    ) 
	    if((cmd == "E") then 
		if(Jun_NetList["IN_SEL"] 
		    (axlFinishEnterFun)
		) 
		if(Jun_NetList["CURRENT_DB"] 
		    (axlDehighlightObject 
			Jun_NetList["CURRENT_DB"]
		    )
		) 
		(axlFormClose 
		    Jun_NetList["FORM"]
		)
		return((Jun_NetList = nil))
	    ) 
	    if((cmd == "Q") then 
		(cmd = makeTable("JunTable" nil)) 
		(cmd["QR"] = (axlDMFileBrowse nil nil ?defaultName "1.net"
			?title "Add Single Quotation ('net_name') for the Net List File ******* Please select the netlist file." ?optFilters "Netlist File(*.net)|*.net|Netlist File(*.txt)|*.txt|"
		    )) 
		if(!(cmd["QR"] && isFile(cmd["QR"])) 
		    return(nil)
		)
		(cmd["QS"] = (axlDMFileBrowse nil t ?defaultName 
			sprintf(nil "%s_out%s" 
			    nth(1 
				(temp = (axlDMFileParts 
					cmd["QR"]
				    ))
			    ) 
			    if((temp = nth(3 temp)) 
				strcat("." temp) ""
			    )
			)
			?title "Add Single Quotation (' ') for the Net List File ******* Please select the save file." ?optFilters "Netlist File(*.net)|*.net|Netlist File(*.txt)|*.txt|"
		    )) 
		if(!cmd["QS"] 
		    return(nil)
		) 
		(file = infile(cmd["QR"])) 
		(cmd["QT"] = outfile((axlTempFile) "w")) 
		while(gets(msg file) 
		    if((temp = parseString(msg)) then 
			case(upperCase(car(temp)) 
			    ("$NETS" 
				(cmd["NET_SE"] = t)
			    ) 
			    ("$END" 
				(cmd["NET_SE"] = nil)
			    ) 
			    (t 
				if((cmd["NET_SE"] && (temp = nindex(msg ";")) && 
					(temp != 1)) then 
				    (cmd["N"] = substring(msg 1 
					    (temp - 1)
					)) 
				    (cmd["P"] = substring(msg 
					    (temp + 1) 
					    strlen(msg)
					)) 
				    if(((temp = parseString(cmd["N"])) && (length(temp) >= 1)) then 
					(cmd["N"] = substring(cmd["N"] 
						nindex(cmd["N"] 
						    car(temp)
						) 
						((nindex(cmd["N"] 
							    car(reverse(temp))
							) + strlen(car(reverse(temp)))) - nindex(cmd["N"] 
							car(temp)
						    ))
					    ))
				    )
				    sprintf(msg "%s%s%s;%s" 
					if((substring(cmd["N"] 1 1) != "'") "'" "") 
					cmd["N"] 
					if((substring(cmd["N"] 
						    strlen(cmd["N"]) 1
						) != "'") "'" ""
					)
					cmd["P"]
				    )
				)
			    )
			)
		    ) 
		    if(!errset(fprintf(cmd["QT"] msg)) 
			foreach(m 
			    parseString(msg "") 
			    fprintf(cmd["QT"] m)
			)
		    )
		)
		close(file) 
		close(cmd["QT"]) 
		(temp = (axlOSFileMove 
			(file = get_filename(cmd["QT"])) 
			cmd["QS"]
		    )) 
		if((!temp && (upperCase(file) != upperCase(cmd["QS"])) && isFile(file)) 
		    (axlTempFileRemove file)
		) 
		printf("%s single quotation. Open the file for the result:\n%s\n" 
		    if(temp "Succeed in adding" "Failed to add") 
		    buildString(parseString(cmd["QS"] "/") "\\")
		)
		return(temp)
	    ) 
	    if((cmd == "AN") then 
		(Cmd = (cmd = makeTable("JunTable" nil))) 
		(cmd["QR"] = (axlDMFileBrowse nil nil ?defaultName "1.lst"
			?title "Assign pins with the new net name." ?optFilters "Netlist File(*.lst)|*.lst|Netlist File(*.txt)|*.txt|"
		    )) 
		if(!(cmd["QR"] && isFile(cmd["QR"])) 
		    return(nil)
		)
		(t0 = getCurrentTime()) 
		(cnt = 0) 
		(file = infile(cmd["QR"])) 
		while(gets(msg file) 
		    (cmd['AS] = nil) 
		    if(((te = (temp = parseString(upperCase(msg)))) && (length(temp) == 5)) then 
			cnt++ 
			if((nth(4 temp) != "DUMMY_NET") then 
			    if((cmd['N] = car((axlSelectByName "NET" 
					    nth(4 temp)
					)
				    )) then 
				(cmd['N] = listToVector(list(t 
					    cmd['N] 
					    (cmd['N]->name)
					)
				    )) else 
				(cmd['IN] = append1(cmd['IN] msg))
			    ) else 
			    (cmd['N] = listToVector(list(t nil "")))
			) 
			if((length(cmd['N]) > 1) then 
			    if((cmd['P] = car((axlSelectByName "PIN" 
					    strcat(nth(1 temp) "." 
						nth(2 temp)
					    )
					)
				    )) then 
				if((((cmd['P]->net) != cmd['N][1]) && (((cmd['P]->net)->name) != cmd['N][2])) then 
				    (cmd['AS] = (axlDBAssignNet 
					    cmd['P] 
					    cmd['N][1]
					)) 
				    (axlDBRefreshId nil) 
				    if(!cmd['AS] then 
					(cmd['IF] = append1(cmd['IF] msg)) 
					(tr = temp)
				    )
				) else 
				(cmd['IP] = append1(cmd['IP] msg))
			    )
			)
		    )
		) 
		close(file)
		if(!(stringp(Jun_NetList['AF]) && isFile(Jun_NetList['AF])) 
		    (Jun_NetList['AF] = (axlTempFile))
		) 
		(file = outfile(Jun_NetList['AF] "w")) 
		fprintf(file "\t\tAssign Pin Net Report\n\n") 
		fprintf(file "Error:\tIllegal New Net...\nNO.\tLine message\n\n") 
		(temp = 0)
		foreach(n 
		    cmd['IN] 
		    fprintf(file "%d\t%s" 
			++temp n
		    )
		) 
		fprintf(file "\nTotal Illegal new net: %d\n\n" temp) 
		fprintf(file "Error:\tIllegal Pin name...\nNO.\tLine message\n\n") 
		(temp = 0) 
		foreach(n 
		    cmd['IP] 
		    fprintf(file "%d\t%s" 
			++temp n
		    )
		)
		fprintf(file "\nTotal Illegal Pin name: %d\n\n" temp) 
		fprintf(file "Error:\tIllegal Pin name...\nNO.\tLine message\n\n") 
		(temp = 0) 
		foreach(n 
		    cmd['IF] 
		    fprintf(file "%d\t%s" 
			++temp n
		    )
		) 
		fprintf(file "\nTotal Illegal Pin name: %d\n\n" temp)
		close(file) 
		if(!Jun_NetList['AFW] 
		    (Jun_NetList['AFW] = (axlUIViewFileCreate 
			    get_filename(file) "Assign Pin Net report" nil 
			    '(60 20)
			)) 
		    (axlUIViewFileReuse 
			Jun_NetList['AFW] 
			get_filename(file) "Assign Pin Net report" nil
		    )
		) 
		printf("Assign pin net successfully.\n") 
		(axlVisibleUpdate t) 
		return((axlDBRefreshId nil))
	    ) 
	    if((cmd == "D") then 
		if(!(boundp('Jun_NetDList) && tablep(Jun_NetDList)) 
		    (Jun_NetDList = makeTable("JunTable" nil))
		) 
		(Jun_NetDList["CS"] = strcat("Export State: " 
			if(Jun_NetDList["DM"] "No" "Yes")
		    )) 
		(Jun_PopSetMenuCmd 
		    list(list("Done" "Jun_PopCmd('d)" "Jun_PopCmd d" "done") 
			list("Oops" "Jun_PopCmd('o)" "Jun_PopCmd o" "oops") 
			list("Cancel" "Jun_PopCmd('c)" "Jun_PopCmd c" "cancel") 
			list("MENU_SEPARATOR" nil) 
			list("Export &Message" "Jun_NetTool('DM)" "skill Jun_NetTool('DM)" "toggle")
			list("Select &All Nets" "Jun_NetTool('DA)")
		    )
		)
		(axlControlRaise 
		    'find
		) 
		(axlClearSelSet) 
		(axlSetFindFilter ?enabled 
		    list("NOALL" "GROUPS" "NETS" "NAMEFORM") ?onButtons 
		    list("NETS")
		) 
		while((axlSelect ?prompt 
			strcat("Select net(s) to highlight with the perm color.\t" 
			    Jun_NetDList["CS"]
			)
		    ) 
		    (sn = (s_cmd = (axlGetSelSet))) 
		    (axlClearSelSet) 
		    (Jun_NetTool 
			'DR s_cmd
		    )
		) 
		if((stringp(Jun_NetDList["DF"]) && isFile(Jun_NetDList["DF"])) 
		    (axlTempFileRemove 
			Jun_NetDList["DF"]
		    )
		)
		(Jun_PopSetMenuCmd)
	    )
	    if((cmd == "DM") then 
		(Jun_NetDList["DM"] = !Jun_NetDList["DM"]) 
		(Jun_NetDList["CS"] = strcat("Export State: " 
			if(Jun_NetDList["DM"] "No" "Yes")
		    )) 
		printf(Jun_NetDList["CS"])
	    ) 
	    if((cmd == "DA") then 
		(s_cmd = nil) 
		foreach(s 
		    ((axlDBGetDesign)->symbols) 
		    if(stringp((s->refdes)) 
			foreach(p 
			    (s->pins) 
			    if(((p->net) && (remove((p->net) s_cmd) == s_cmd)) 
				(s_cmd = append1(s_cmd 
					(p->net)
				    ))
			    )
			)
		    )
		) 
		(Jun_NetTool 
		    'DR s_cmd
		)
	    ) 
	    if((cmd == "DR") then 
		if(!(s_cmd && listp(s_cmd) && (s_cmd = setof(s s_cmd 
				    (s->objType)
				))) 
		    return(nil)
		) 
		(cmd = nil) 
		foreach(s s_cmd 
		    case(lowerCase((s->objType)) 
			("group" 
			    (s = setof(m 
				    (s->groupMembers) 
				    ((m->objType) && (lowerCase((m->objType)) == "net"))
				))
			) 
			("net" 
			    (s = list(s))
			) 
			(t 
			    (s = nil)
			)
		    ) 
		    foreach(n s 
			prog(nil 
			    (temp = 0) 
			    foreach(b 
				(n->branches) 
				foreach(c 
				    (b->children) 
				    if(((lowerCase((c->objType)) == "pin") && (c->component)) 
					temp++
				    ) 
				    if((temp > 1) 
					return(nil)
				    )
				)
			    ) 
			    if(((temp == 1) && (cmd == remove(n cmd))) 
				(cmd = append1(cmd n))
			    )
			)
		    )
		)
		(Jun_NetDList["MS"] = (Jun_NetDList["MD"] = nil)) 
		if(cmd then 
		    foreach(n 
			if(!Jun_NetDList["DM"] cmd) 
			sprintf(temp "%s\t\t%s\t%L\n" 
			    upperCase((axlDbidName 
				    (temp = car((car((n->branches))->children)))
				)
			    ) 
			    (axlDbidName n) 
			    (temp->xy)
			) 
			(Jun_NetDList[(n = if((axlIsDummyNet n) "MD" "MS"))] = 
			    append1(Jun_NetDList[n] temp))
		    ) 
		    (Jun_PopTMark) 
		    (axlHighlightObject cmd t)
		) 
		if(!Jun_NetDList["DM"] then 
		    if(!(stringp(Jun_NetDList["DF"]) && isFile(Jun_NetDList["DF"])) 
			(Jun_NetDList["DF"] = (axlTempFile))
		    ) 
		    (file = outfile(Jun_NetDList["DF"] "w")) 
		    (temp = 0)
		    fprintf(file "Single Pin List. . .\nNO.\tSymbol.Pin\tNet\t\tCoordinate\n\n") 
		    (temp = 0) 
		    foreach(n 
			(Jun_NetDList["MS"] = sort(Jun_NetDList["MS"] nil)) 
			fprintf(file "%d\t%s" 
			    ++temp n
			)
		    ) 
		    fprintf(file "\nTotal single pin net: %d\n\n" temp) 
		    fprintf(file "Dummy Net Pin List. . .\nNO.\tSymbol.Pin\tNet\t\tCoordinate\n\n")
		    (temp = 0) 
		    foreach(n 
			(Jun_NetDList["MD"] = sort(Jun_NetDList["MD"] nil)) 
			fprintf(file "%d\t%s" 
			    ++temp n
			)
		    ) 
		    fprintf(file "\nTotal dummy net pin net: %d\n" temp) 
		    close(file) 
		    if(!Jun_NetDList["FW"] 
			(Jun_NetDList["FW"] = (axlUIViewFileCreate 
				get_filename(file) "Hight light Single Pin or Dummy net report" nil 
				'(60 20)
			    )) 
			(axlUIViewFileReuse 
			    Jun_NetDList["FW"] 
			    get_filename(file) "Hight light Single Pin or Dummy net report" nil
			)
		    )
		) 
		(axlDBRefreshId nil)
	    )
	)
    )
procedure((Jun_NetToolCallBack form) 
	prog((msg temp file field s_path
		p_msg sep cnt flag
	    ) 
	    (axlUIWPrint form "REV1.1   Apr 23rd 2010") 
	    case((field = (form->curField)) 
		(("A" "S") 
		    (Jun_NetList["AS"] = if(((form->curField) == "A") nil t)) 
		    if(!Jun_NetList["IN_SEL"] 
			(axlShell "Jun_NetMsg")
		    )
		) 
		("Clean" 
		    (axlFormSetField form "SN" "*")
		) 
		("AN" 
		    (Jun_NetTool field)
		) 
		(("ZS" "ZM") 
		    (Jun_NetList[field] = (form->curValue)) 
		    (axlFormSetFieldEditable form "ZS" 
			Jun_NetList["ZM"]
		    )
		)
		("H" 
		    (sep = "----------------------------------------------------------------------------------\n") 
		    (file = (axlDMOpenLog 
			    (axlTempFile)
			)) 
		    fprintf(file "                             Encrypt Allegro Skill Files\n\n\n") 
		    fprintf(file "Software Version : %s\n" 
			(axlVersion 
			    'fullVersion
			)
		    )
		    fprintf(file "Date/Time        : %s\n%s\n\n" "Feb 10th, 00:30 2010" sep) 
		    fprintf(file "%s\n\n%s\n\n%s\n\n%s\n\n%s\n\n%s\n\n%s\n\n%s\n\n%s\n\n%s\n\n" "    This routine is used for export net(s) message. It contains two message format." "You can change the format by selecting the checkbox \"All\" or \"Single\"." "   \"All\": NO. Refdes   Pin_Number Net_name (Export Including all the net message)"
			"\"Single\": NO. Net_name                     (Only export the net_name message)" "If you want to only export the ceratin symbols' message, you can add the symbols' " "Refdes name into the \"U:\" control when it's in the \"All\" format only.\n" "And the net message will show when it match the user specified refdes name." "\"Assign Pin Net\": It uses for reset the pin net name. And the import file message"
			"format is: NO. Refdes Pin_Number Old_Net_name New_Net_name." "Note: It is used when you have all the changing net are correct set."
		    ) 
		    (axlDMClose file) 
		    (axlUIViewFileCreate 
			(file = get_filename(file)) "Encrypt Allegro Skill File Help" t
		    ) 
		    if(isFile(file) 
			(axlTempFileRemove file)
		    )
		) 
		("" 
		    if(Jun_NetList["IN_SEL"] 
			(axlFinishEnterFun)
		    ) 
		    if(Jun_NetList["CURRENT_DB"] 
			(axlDehighlightObject 
			    Jun_NetList["CURRENT_DB"]
			)
		    ) 
		    (Jun_NetList = nil)
		) 
		(t 
		    if(((form->curField) == Jun_NetList["FIELD"]) then 
			(parent = car((axlFormTreeViewGetParents form 
				    (form->curField) 
				    (form->curValueInt)
				)
			    )) 
			(Jun_TreeUpdateState form 
			    (form->curField) 
			    Jun_NetList[Jun_NetList["FIELD"]] ?c_tree
			    (form->curValueInt)
			) 
			(temp = (axlFormTreeViewGetSelectState form 
				(form->curField) 
				(form->curValueInt)
			    ))
		    ) 
		    if(parent then 
			if(!stringp((parent = (axlFormTreeViewGetLabel form 
					    (form->curField) parent
					))
				) 
			    return(nil)
			) 
			(temp = Jun_NetList["ML"]) 
			(sn = (pn = nil))
			if((stringp(temp) && (temp = parseString(temp "@")) && 
				(length(temp) > 2)) then 
			    (sn = list(nth(1 temp))) 
			    (pn = list(nth(2 temp)))
			) 
			(Jun_NetList["ML"] = (temp = (axlFormTreeViewGetLabel form 
				    (form->curField) 
				    (form->curValueInt)
				))) 
			if((stringp(temp) && (temp = parseString(temp "@")) && 
				(length(temp) > 2)) then 
			    (sn = cons(nth(1 temp) sn)) 
			    (pn = cons(nth(2 temp) pn))
			) 
			if(((car(sn) == cadr(sn)) && (car(pn) == cadr(pn))) then 
			    (sn = list(car(sn))) 
			    (pn = list(car(pn)))
			) 
			(cnt = 0)
			(find_c = nil) 
			foreach(s 
			    ((axlDBGetDesign)->symbols) 
			    if((stringp((s->refdes)) && (remove((temp = upperCase((s->refdes))) sn) != sn)) then 
				prog((p0) 
				    (p0 = if((temp == car(sn)) 
					    car(pn) 
					    cadr(pn)
					)) 
				    foreach(p 
					(s->pins) 
					if((upperCase((p->number)) == p0) 
					    return((s = p))
					)
				    ) 
				    if((temp == car(sn)) 
					printf("View Pin Error: Couldn't find the pin \"%s.%s\".\n" temp p0)
				    ) 
				    (s = nil)
				) 
				if(s then 
				    ++cnt 
				    if((temp == car(sn)) then 
					if(((axlFormTreeViewGetSelectState form 
						    (form->curField) 
						    (form->curValueInt)
						) == 1) 
					    (axlFormSetField form "SN" temp)
					) 
					if(Jun_NetList["ZM"] then 
					    (Jun_WindowBoxSet 
						(s->bBox) ?z_size 
						Jun_NetList["ZS"]
					    ) 
					    (axlHighlightObject s)
					) 
					(find_c = t)
					(Jun_NetList["CURRENT_DB"] = s) else 
					if(Jun_NetList["ZM"] 
					    (axlDehighlightObject s)
					)
				    )
				) 
				if((cnt == length(sn)) 
				    return(t)
				)
			    )
			) 
			if(!find_c 
			    return(printf("Symbol Error: Couldn't find the symbol \"%s\".\n" 
				    car(sn)
				)
			    )
			)
		    )
		)
	    )
	)
    )
procedure((Jun_NetMsg) 
	prog((file form field msg com_name
		netName pinNum pa ch temp
		cnt net_cnt sn pn
	    ) 
	    if((!boundp('Jun_NetList) || !tablep(Jun_NetList)) 
		return(t)
	    ) 
	    (Jun_NetList["IN_SEL"] = t) 
	    (Jun_PopSetMenuCmd 
		list(list("Done" "Jun_PopCmd('d)" "Jun_PopCmd d" "done") 
		    list("Cancel" "Jun_PopCmd('c)" "Jun_PopCmd c" "cancel") 
		    list("MENU_SEPARATOR" nil) 
		    list("Message &Pattern" "Jun_NetTool('A)" "skill Jun_NetTool 'A" "toggle") 
		    list("Clea&n" "Jun_NetTool('C)")
		    list("&Exit" "Jun_NetTool('E)")
		)
	    ) 
	    (axlClearSelSet)
	    (axlSetFindFilter ?enabled 
		list("NOALL" "GROUPS" "NETS" "NAMEFORM") ?onButtons "NETS"
	    ) 
	    while((axlSelect ?prompt 
		    strcat("Select element(s) to get the net message.\t" 
			Jun_NetList["CS"]
		    )
		) 
		(msg = "") 
		(net_cnt = 0) 
		(form = Jun_NetList["FORM"]) 
		(field = Jun_NetList["FIELD"])
		foreach(p 
		    Jun_NetList[field] 
		    (axlFormTreeViewSet form field 
			'TV_DELETEITEM 
			car(p)
		    )
		) 
		(Jun_NetList[field] = nil) 
		(sn = upperCase((axlFormGetField form "SN"))) 
		if(((sn == "") || (sn == "*") || !parseString(sn "* ")) 
		    (sn = nil)
		) 
		(pa = makeTable("JunTable" nil))
		(ch = makeTable("JunTable" nil)) 
		(cnt = makeTable("JunTable" 0)) 
		foreach(s 
		    (axlGetSelSet) 
		    case(lowerCase((s->objType)) 
			("group" 
			    (s = setof(m 
				    (s->groupMembers) 
				    ((m->objType) && (lowerCase((m->objType)) == "net"))
				))
			) 
			("net" 
			    (s = list(s))
			) 
			(t 
			    (s = nil)
			)
		    ) 
		    foreach(n s 
			net_cnt++ 
			(netName = strcat(Jun_NetList["FADD"] 
				if(((temp = upperCase((axlDbidName n))) == "DUMMY NET") "DUMMY_NET" temp) 
				Jun_NetList["BADD"]
			    )) 
			(pa[net_cnt] = (axlFormTreeViewAddItem form field netName nil
				nil 
				'TVSELECT_2STATE
			    ))
			if(Jun_NetList["AS"] 
			    sprintf(msg "%s%d\t%s\n" msg net_cnt netName)
			) 
			foreach(b 
			    (n->branches) 
			    foreach(c 
				setof(c 
				    (b->children) 
				    (lowerCase((c->objType)) == "pin")
				) 
				(com_name = if((c->component) 
					upperCase(((c->component)->name)) "?"
				    )) 
				(pinNum = upperCase((c->number))) 
				sprintf(temp "%d@%s@%s@%s" 
				    (cnt[net_cnt] = (1 + cnt[net_cnt])) com_name pinNum
				    if((c->isMirrored) "B" "T")
				)
				if((temp = (axlFormTreeViewAddItem form field 
					    upperCase(temp) 
					    pa[net_cnt]
					    nil t
					)) 
				    (ch[net_cnt] = append1(ch[net_cnt] temp))
				) 
				if(!Jun_NetList["AS"] then 
				    (temp = nil) 
				    if(sn then 
					if(((nindex(sn "*") && 
						    nindex(com_name 
							substring(sn 1 
							    (nindex(sn "*") - 1)
							)
						    )) || (com_name == sn)) 
					    (temp = t)
					)
				    ) 
				    if((!sn || temp) 
					sprintf(msg "%s%d\t%s\t%s\t%s\n" msg net_cnt com_name
					    pinNum netName
					)
				    )
				)
			    )
			) 
			if(pa[net_cnt] 
			    (Jun_NetList[field] = append1(Jun_NetList[field] 
				    list(pa[net_cnt] 
					ch[net_cnt]
				    )
				))
			)
		    )
		) 
		if(Jun_NetList["AS"] then 
		    (temp = "Single Net Message") 
		    sprintf(msg "NO.\tNet\n\n%s" msg) else
		    (temp = "All Pins' Net Message") 
		    sprintf(msg "Symbol Filter: S = %s\nNO.\tSymbol\tPin\tNet\n\n%s" 
			(axlFormGetField form "SN") msg
		    )
		) 
		if(!(stringp(Jun_NetList["FV"]) && isFile(Jun_NetList["FV"])) 
		    (Jun_NetList["FV"] = (axlTempFile))
		)
		(file = outfile(Jun_NetList["FV"] "w")) 
		fprintf(file "%s\n#Total selected: %d" msg net_cnt) 
		close(file) 
		if(!Jun_NetList["FW"] 
		    (Jun_NetList["FW"] = (axlUIViewFileCreate 
			    get_filename(file) temp nil 
			    '(40 20)
			)) 
		    (axlUIViewFileReuse 
			Jun_NetList["FW"] 
			get_filename(file) temp nil
		    )
		)
	    ) 
	    (Jun_PopSetMenuCmd) 
	    if((boundp('Jun_NetList) && tablep(Jun_NetList) && Jun_NetList["IN_SEL"]) 
		(Jun_NetList["IN_SEL"] = nil)
	    ) 
	    if((portp(file) && isFile((file = get_filename(file)))) 
		(axlTempFileRemove file)
	    )
	)
    )