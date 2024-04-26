let s:hlgroup = 'Visual'

fu deepl_operator#replace_opfunc(type = '') abort
	if a:type == ''
		set operatorfunc=deepl_operator#replace_opfunc
		return 'g@'
	elseif a:type == "block"
		echoerr "Block selection is not supported."
		return
	endif

	" Get input
	let old_reg = @"
	if a:type=='line'
		noau sil norm! '[V']y
	else
		noau sil norm! `[v`]y
	endif
	let input = @"
	let @" = old_reg
	if input == "" | return | endif

	" Add highlights
	let pos = []
	let [ line1, col1 ] = [ line("'["), col("'[")  ]
	let [ line2, col2 ] = [ line("']"), col("']")  ]
	if a:type == 'line'
		let col2 = len(getline(line2))
	endif
	for line in range(line1, min([line2, line('w$')]))
		if line != line1 && line != line2
			call add(pos, matchaddpos(s:hlgroup, [ line ]))
		else
			let str = getline(line)
			let start_idx = line == line1 ? col1 : 1
			let end_idx = line == line2 ? col2 : len(str)
			for i in range(start_idx, end_idx)
				call add(pos, matchaddpos(s:hlgroup, [[line, i]]))
			endfor
		endif
	endfor
	redraw
	" Translate
	let output = ''
	try
		echo "Translating..."
		let output = deepl#translate(input, g:deepl_target_lang)
	catch
		echoerr v:exception
	finally
		" Remove highlights
		for id in pos
			call matchdelete(id)
		endfor
		redraw
	endtry

	" Put output
	let old_vw = winsaveview()
	let old_ve = &ve
	set ve=onemore
	let old_reg = @"
	if a:type=='line'
		noau sil norm! '[V']d
	else
		noau sil norm! `[v`]d
	endif
	let @" = output
	noau sil norm! P
	let &ve = old_ve
	call winrestview(old_vw)
	let @" = old_reg

	echo "Translated into " .. g:deepl_target_lang
endfu
