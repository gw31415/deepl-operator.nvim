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
		noau norm! '[V']y
	else
		noau norm! `[v`]y
	endif
	let input = @"
	let @" = old_reg
	if input == "" | return | endif

	" Add highlights
	let pos = []
	let [_, line1, col1, _] = getpos("'[")
	let [_, line2, col2, _] = getpos("']")
	if a:type == "char"
		for line in range(line1, min([line2, line('w$')]))
			if line != line1 && line != line2
				call add(pos, matchaddpos(s:hlgroup, [ line ]))
			else
				let str = getline(line)
				let start_idx = line == line1 ? col1 : 1
				let end_idx = line == line2 ? col2 : len(str)
				for i in range(start_idx, end_idx)
					call add(pos, matchaddpos(s:hlgroup, [[line, byteidx(str, i)]]))
				endfor
			endif
		endfor
		redraw
	endif
	" Translate
	let output = ''
	try
		echo "Translating..."
		let output = deepl#translate(input, g:deepl_target_lang)
		echo ""
	catch
		echoerr v:exception
	finally
		" Remove highlights
		for id in pos
			call matchdelete(id)
		endfor
		redraw
	endtry

	let lines = split(output, '\n')
	try
		call nvim_buf_set_text(0, line1 - 1, col1 - 1, line2 - 1, col("']"), lines)
	catch
		" If the selected text is up to a newline character
		call nvim_buf_set_text(0, line1 - 1, col1 - 1, line2 - 1, col("']") - 1, lines)
	endtry
endfu
